import { Controller, Get, Post, Put, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Orders')
@Controller('orders')
export class OrdersController {
    constructor(private prisma: PrismaService) { }

    @Get()
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
    async findOne(@Param('id') id: string) {
        return this.prisma.order.findUnique({
            where: { id },
            include: { service: true, user: true, vendor: true },
        });
    }

    @Post()
    async create(@Body() data: any) {
        // Generate order number
        const count = await this.prisma.order.count();
        data.orderNumber = `PG-2026-${String(count + 1).padStart(4, '0')}`;
        return this.prisma.order.create({ data });
    }

    @Put(':id/status')
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
        }
        return order;
    }
}
