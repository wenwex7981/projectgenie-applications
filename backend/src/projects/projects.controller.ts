import { Controller, Get, Post, Put, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Projects')
@Controller('projects')
export class ProjectsController {
    constructor(private prisma: PrismaService) { }

    @Get()
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
            include: { vendor: { select: { id: true, name: true, businessName: true, rating: true } } },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get('featured')
    async findFeatured() {
        return this.prisma.project.findMany({
            where: { isFeatured: true, isActive: true },
            include: { vendor: { select: { id: true, name: true, businessName: true } } },
            orderBy: { rating: 'desc' },
            take: 10,
        });
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.project.findUnique({
            where: { id },
            include: { vendor: true },
        });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.project.create({ data });
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.project.update({ where: { id }, data });
    }

    @Delete(':id')
    async delete(@Param('id') id: string) {
        return this.prisma.project.update({
            where: { id },
            data: { isActive: false },
        });
    }
}
