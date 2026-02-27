import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiQuery } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Search')
@Controller('search')
export class SearchController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async search(@Query('q') query: string, @Query('type') type?: string) {
        if (!query || query.trim().length === 0) {
            return { services: [], projects: [] };
        }

        const q = query.trim();

        const results: any = {};

        if (!type || type === 'services' || type === 'all') {
            results.services = await this.prisma.service.findMany({
                where: {
                    isActive: true,
                    OR: [
                        { title: { contains: q, mode: 'insensitive' } },
                        { description: { contains: q, mode: 'insensitive' } },
                        { vendorName: { contains: q, mode: 'insensitive' } },
                    ],
                },
                include: { category: true },
                orderBy: { rating: 'desc' },
                take: 20,
            });
        }

        if (!type || type === 'projects' || type === 'all') {
            results.projects = await this.prisma.project.findMany({
                where: {
                    isActive: true,
                    OR: [
                        { title: { contains: q, mode: 'insensitive' } },
                        { description: { contains: q, mode: 'insensitive' } },
                        { domain: { contains: q, mode: 'insensitive' } },
                    ],
                },
                include: { vendor: { select: { id: true, name: true, businessName: true } } },
                orderBy: { rating: 'desc' },
                take: 20,
            });
        }

        return results;
    }
}
