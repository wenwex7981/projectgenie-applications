import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Bundles')
@Controller('bundles')
export class BundlesController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll() {
        return this.prisma.bundle.findMany();
    }

    @Get(':id')
    async findOne(@Param('id') id: string) {
        return this.prisma.bundle.findUnique({ where: { id } });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.bundle.create({ data });
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        return this.prisma.bundle.update({ where: { id }, data });
    }

    @Delete(':id')
    async delete(@Param('id') id: string) {
        return this.prisma.bundle.delete({ where: { id } });
    }
}
