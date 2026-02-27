import { Controller, Get, Post, Put, Param, Query, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Custom Orders')
@Controller('custom-orders')
export class CustomOrdersController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll(@Query('userId') userId?: string, @Query('vendorId') vendorId?: string, @Query('status') status?: string) {
        const where: any = {};
        if (userId) where.userId = userId;
        if (vendorId) where.vendorId = vendorId;
        if (status) where.status = status;

        return this.prisma.customOrder.findMany({
            where,
            include: {
                user: { select: { id: true, name: true, email: true, phone: true, college: true } },
                vendor: { select: { id: true, name: true, businessName: true } },
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.customOrder.findUnique({
            where: { id },
            include: { user: true, vendor: true },
        });
    }

    @Post()
    async create(@Body() data: any) {
        // Auto-assign to a vendor if none specified
        if (!data.vendorId) {
            const topVendor = await this.prisma.vendor.findFirst({
                where: { isVerified: true, status: 'active' },
                orderBy: { rating: 'desc' },
            });
            if (topVendor) data.vendorId = topVendor.id;
        }
        return this.prisma.customOrder.create({ data });
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.customOrder.update({ where: { id }, data });
    }

    @Put(':id/accept')
    async accept(@Param('id') id: string, @Body() body: { vendorNotes?: string; quotedPrice?: number }) {
        return this.prisma.customOrder.update({
            where: { id },
            data: { status: 'Accepted', vendorNotes: body.vendorNotes, quotedPrice: body.quotedPrice },
        });
    }

    @Put(':id/reject')
    async reject(@Param('id') id: string, @Body() body: { vendorNotes?: string }) {
        return this.prisma.customOrder.update({
            where: { id },
            data: { status: 'Rejected', vendorNotes: body.vendorNotes },
        });
    }

    @Put(':id/complete')
    async complete(@Param('id') id: string) {
        return this.prisma.customOrder.update({
            where: { id },
            data: { status: 'Completed' },
        });
    }
}
