import { Controller, Get, Post, Put, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Services')
@Controller('services')
export class ServicesController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll(@Query('category') category?: string, @Query('vendorId') vendorId?: string) {
        const where: any = { isActive: true };
        if (category) where.category = { title: category };
        if (vendorId) where.vendorId = vendorId;

        return this.prisma.service.findMany({
            where,
            include: { category: true, reviews: true, vendor: { select: { id: true, name: true, businessName: true } } },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get('featured')
    async findFeatured() {
        return this.prisma.service.findMany({
            where: { isFeatured: true, isActive: true },
            include: { category: true, reviews: true },
            orderBy: { rating: 'desc' },
        });
    }

    @Get('trending')
    async findTrending() {
        return this.prisma.service.findMany({
            where: { isTrending: true, isActive: true },
            include: { category: true, reviews: true },
            orderBy: { rating: 'desc' },
        });
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.service.findUnique({
            where: { id },
            include: { category: true, reviews: true, vendor: true },
        });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.service.create({ data });
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.service.update({ where: { id }, data });
    }

    @Delete(':id')
    async delete(@Param('id') id: string) {
        return this.prisma.service.update({
            where: { id },
            data: { isActive: false },
        });
    }
}
