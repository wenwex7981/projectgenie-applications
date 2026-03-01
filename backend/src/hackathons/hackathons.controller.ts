import { Controller, Get, Post, Put, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Hackathons')
@Controller('hackathons')
export class HackathonsController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll(@Query('vendorId') vendorId?: string) {
        const where: any = { isActive: true };
        if (vendorId) where.vendorId = vendorId;

        return this.prisma.hackathon.findMany({
            where,
            include: { vendor: { select: { id: true, name: true, businessName: true } } },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get('featured')
    async findFeatured() {
        return this.prisma.hackathon.findMany({
            where: { isFeatured: true, isActive: true },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.hackathon.findUnique({
            where: { id },
            include: { vendor: true },
        });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.hackathon.create({ data });
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.hackathon.update({ where: { id }, data });
    }

    @Delete(':id')
    async delete(@Param('id') id: string) {
        return this.prisma.hackathon.update({
            where: { id },
            data: { isActive: false },
        });
    }
}
