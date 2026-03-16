import { Controller, Get, Post, Put, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Orders')
@Controller('orders')
export class OrdersController {
    constructor(private prisma: PrismaService) { }

    @Get()
    @ApiOperation({ summary: 'List all orders with filters' })
    async findAll(@Query('userId') userId?: string, @Query('vendorId') vendorId?: string, @Query('status') status?: string) {
        const where: any = {};
        if (userId) where.userId = userId;
        if (vendorId) where.vendorId = vendorId;
        if (status) where.status = status;

        return this.prisma.order.findMany({
            where,
            include: {
                service: { select: { id: true, title: true, imageUrl: true, vendorName: true } },
                user: { select: { id: true, name: true, email: true } },
                vendor: { select: { id: true, name: true, businessName: true } },
            },
            orderBy: { date: 'desc' },
        });
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get order details by ID' })
    async findOne(@Param('id') id: string) {
        return this.prisma.order.findUnique({
            where: { id },
            include: { service: true, user: true, vendor: true },
        });
    }

    @Post()
    @ApiOperation({ summary: 'Create a new order' })
    async create(@Body() data: any) {
        // Generate order number
        const count = await this.prisma.order.count();
        data.orderNumber = `PG-2026-${String(count + 1).padStart(4, '0')}`;

        // Auto-set vendorId from the service if not provided
        if (!data.vendorId && data.serviceId) {
            const service = await this.prisma.service.findUnique({
                where: { id: data.serviceId },
                select: { vendorId: true },
            });
            if (service?.vendorId) {
                data.vendorId = service.vendorId;
            }
        }

        const order = await this.prisma.order.create({ data });

        // Create notifications for buyer and vendor
        try {
            // Notify buyer
            await this.prisma.notification.create({
                data: {
                    title: 'Order Placed',
                    message: `Your order ${order.orderNumber} has been placed successfully`,
                    type: 'order',
                    targetId: order.userId,
                },
            });
            // Notify vendor
            if (order.vendorId) {
                await this.prisma.notification.create({
                    data: {
                        title: 'New Order Received',
                        message: `New order ${order.orderNumber} received`,
                        type: 'order',
                        targetId: order.vendorId,
                    },
                });
            }
        } catch (e) { /* notifications are optional */ }

        return order;
    }

    @Put(':id/status')
    @ApiOperation({ summary: 'Update order status' })
    async updateStatus(@Param('id') id: string, @Body() body: { status: string }) {
        const order = await this.prisma.order.update({
            where: { id },
            data: { status: body.status },
        });

        // If completed, update vendor earnings
        if (body.status === 'Completed' && order.vendorId) {
            await this.prisma.transaction.create({
                data: {
                    type: 'credit',
                    amount: order.totalPrice,
                    description: `Order ${order.orderNumber} completed`,
                    vendorId: order.vendorId,
                },
            });

            // Notify buyer
            try {
                await this.prisma.notification.create({
                    data: {
                        title: 'Order Completed',
                        message: `Your order ${order.orderNumber} has been completed!`,
                        type: 'order',
                        targetId: order.userId,
                    },
                });
            } catch (e) { /* optional */ }
        }

        // Notify on status change
        if (body.status !== 'Completed') {
            try {
                await this.prisma.notification.create({
                    data: {
                        title: 'Order Status Updated',
                        message: `Order ${order.orderNumber} is now ${body.status}`,
                        type: 'order',
                        targetId: order.userId,
                    },
                });
            } catch (e) { /* optional */ }
        }

        return order;
    }
}
