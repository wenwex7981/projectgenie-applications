import { Controller, Get, Post, Param, Query, Body, HttpException, HttpStatus } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
    constructor(private prisma: PrismaService) { }

    // ─── Get reviews for a service ───────────────────────────────────
    @Get()
    async findAll(@Query('serviceId') serviceId?: string) {
        const where: any = {};
        if (serviceId) where.serviceId = serviceId;
        return this.prisma.review.findMany({
            where,
            orderBy: { date: 'desc' },
        });
    }

    // ─── Create a review ─────────────────────────────────────────────
    @Post()
    async create(@Body() body: {
        serviceId: string;
        userId?: string;
        userName: string;
        rating: number;
        comment: string;
    }) {
        if (!body.serviceId || !body.userName || !body.rating || !body.comment) {
            throw new HttpException('serviceId, userName, rating, and comment are required', HttpStatus.BAD_REQUEST);
        }

        const review = await this.prisma.review.create({
            data: {
                serviceId: body.serviceId,
                userId: body.userId,
                userName: body.userName,
                rating: body.rating,
                comment: body.comment,
                date: new Date().toISOString().split('T')[0],
            },
        });

        // Recompute average rating for service
        const agg = await this.prisma.review.aggregate({
            where: { serviceId: body.serviceId },
            _avg: { rating: true },
            _count: true,
        });

        await this.prisma.service.update({
            where: { id: body.serviceId },
            data: {
                rating: agg._avg.rating ?? 0,
                reviewCount: agg._count,
            },
        });

        return review;
    }

    // ─── Get reviews for a service by ID ─────────────────────────────
    @Get('service/:serviceId')
    async findByService(@Param('serviceId') serviceId: string) {
        return this.prisma.review.findMany({
            where: { serviceId },
            orderBy: { date: 'desc' },
        });
    }
}
