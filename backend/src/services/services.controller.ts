import { Controller, Get, Post, Put, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiParam } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Services')
@Controller('services')
export class ServicesController {
    constructor(private prisma: PrismaService) { }

    @Get()
    @ApiOperation({ summary: 'List all active services with filters' })
    async findAll(@Query('category') category?: string, @Query('vendorId') vendorId?: string) {
        const where: any = { isActive: true };
        if (category) where.category = { title: category };
        if (vendorId) where.vendorId = vendorId;

        return this.prisma.service.findMany({
            where,
            include: {
                category: true,
                reviews: true,
                vendor: { select: { id: true, name: true, businessName: true, profileImage: true, rating: true } },
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get('featured')
    @ApiOperation({ summary: 'Get featured services' })
    async findFeatured() {
        return this.prisma.service.findMany({
            where: { isFeatured: true, isActive: true },
            include: {
                category: true,
                reviews: true,
                vendor: { select: { id: true, name: true, businessName: true, profileImage: true } },
            },
            orderBy: { rating: 'desc' },
        });
    }

    @Get('trending')
    @ApiOperation({ summary: 'Get trending services' })
    async findTrending() {
        return this.prisma.service.findMany({
            where: { isTrending: true, isActive: true },
            include: {
                category: true,
                reviews: true,
                vendor: { select: { id: true, name: true, businessName: true, profileImage: true } },
            },
            orderBy: { rating: 'desc' },
        });
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get service details by ID' })
    async findOne(@Param('id') id: string) {
        return this.prisma.service.findUnique({
            where: { id },
            include: {
                category: true,
                reviews: true,
                vendor: {
                    select: {
                        id: true, name: true, businessName: true,
                        profileImage: true, rating: true, bio: true,
                        _count: { select: { services: true, orders: true } },
                    },
                },
            },
        });
    }

    @Post()
    @ApiOperation({ summary: 'Create a new service listing' })
    async create(@Body() data: any) {
        // If vendorId is given, automatically populate vendorName from vendor
        if (data.vendorId && (!data.vendorName || data.vendorName === 'Vendor')) {
            const vendor = await this.prisma.vendor.findUnique({
                where: { id: data.vendorId },
                select: { name: true, businessName: true },
            });
            if (vendor) {
                data.vendorName = vendor.businessName || vendor.name;
            }
        }

        // Fallback for missing categoryId
        if (!data.categoryId) {
            let defaultCategory = await this.prisma.category.findFirst({
                where: { title: 'General' },
            });
            if (!defaultCategory) {
                defaultCategory = await this.prisma.category.create({
                    data: { title: 'General', icon: 'category', count: 0, sortOrder: 99 },
                });
            }
            data.categoryId = defaultCategory.id;
        }

        const service = await this.prisma.service.create({ data });

        // Create notification for the system
        try {
            await this.prisma.notification.create({
                data: {
                    title: 'New Service Listed',
                    message: `"${service.title}" is now available on the marketplace`,
                    type: 'system',
                    targetId: data.vendorId,
                },
            });
        } catch (e) { /* notification is optional */ }

        return service;
    }

    @Put(':id')
    @ApiOperation({ summary: 'Update a service listing' })
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.service.update({ where: { id }, data });
    }

    @Delete(':id')
    @ApiOperation({ summary: 'Soft-delete a service listing' })
    async delete(@Param('id') id: string) {
        return this.prisma.service.update({
            where: { id },
            data: { isActive: false },
        });
    }
}
