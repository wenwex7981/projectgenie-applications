import { Controller, Get, Post, Put, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Projects')
@Controller('projects')
export class ProjectsController {
    constructor(private prisma: PrismaService) { }

    @Get()
    @ApiOperation({ summary: 'List all active projects with filters' })
    async findAll(
        @Query('domain') domain?: string,
        @Query('featured') featured?: string,
        @Query('vendorId') vendorId?: string,
    ) {
        const where: any = { isActive: true };
        if (domain && domain !== 'All') where.domain = { contains: domain };
        if (featured === 'true') where.isFeatured = true;
        if (vendorId) where.vendorId = vendorId;

        return this.prisma.project.findMany({
            where,
            include: {
                vendor: { select: { id: true, name: true, businessName: true, rating: true, profileImage: true } },
                category: true,
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get('featured')
    @ApiOperation({ summary: 'Get featured projects' })
    async findFeatured() {
        return this.prisma.project.findMany({
            where: { isFeatured: true, isActive: true },
            include: {
                vendor: { select: { id: true, name: true, businessName: true, profileImage: true } },
                category: true,
            },
            orderBy: { rating: 'desc' },
            take: 10,
        });
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get project details by ID' })
    async findOne(@Param('id') id: string) {
        return this.prisma.project.findUnique({
            where: { id },
            include: {
                vendor: {
                    select: {
                        id: true, name: true, businessName: true,
                        profileImage: true, rating: true, bio: true,
                        _count: { select: { projects: true, orders: true } },
                    },
                },
                category: true,
            },
        });
    }

    @Post()
    @ApiOperation({ summary: 'Create a new project listing' })
    async create(@Body() data: any) {
        const project = await this.prisma.project.create({ data });

        // Create notification
        try {
            await this.prisma.notification.create({
                data: {
                    title: 'New Project Listed',
                    message: `"${project.title}" is now available on the marketplace`,
                    type: 'system',
                    targetId: data.vendorId,
                },
            });
        } catch (e) { /* notification is optional */ }

        return project;
    }

    @Put(':id')
    @ApiOperation({ summary: 'Update a project listing' })
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.project.update({ where: { id }, data });
    }

    @Delete(':id')
    @ApiOperation({ summary: 'Soft-delete a project listing' })
    async delete(@Param('id') id: string) {
        return this.prisma.project.update({
            where: { id },
            data: { isActive: false },
        });
    }
}
