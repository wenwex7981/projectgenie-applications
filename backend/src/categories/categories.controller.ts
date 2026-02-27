import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll() {
        return this.prisma.category.findMany({
            include: {
                _count: { select: { services: true, projects: true } },
            },
            orderBy: { sortOrder: 'asc' },
        });
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.category.findUnique({
            where: { id },
            include: {
                services: { where: { isActive: true }, orderBy: { rating: 'desc' }, take: 20 },
                projects: { where: { isActive: true }, orderBy: { rating: 'desc' }, take: 20 },
            },
        });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.category.create({ data });
    }
}
