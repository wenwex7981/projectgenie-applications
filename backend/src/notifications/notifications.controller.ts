import { Controller, Get, Put, Post, Param, Query, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Notifications')
@Controller('notifications')
export class NotificationsController {
    constructor(private prisma: PrismaService) { }

    @Get()
    async findAll(@Query('targetId') targetId?: string, @Query('type') type?: string) {
        const where: any = {};
        if (targetId) where.targetId = targetId;
        if (type) where.type = type;
        return this.prisma.notification.findMany({
            where,
            orderBy: { createdAt: 'desc' },
            take: 50,
        });
    }

    @Post()
    async create(@Body() data: any) {
        return this.prisma.notification.create({ data });
    }

    @Put(':id/read')
    async markRead(@Param('id') id: string) {
        return this.prisma.notification.update({
            where: { id },
            data: { isRead: true },
        });
    }

    @Put('read-all')
    async markAllRead(@Body() body: { targetId: string }) {
        await this.prisma.notification.updateMany({
            where: { targetId: body.targetId, isRead: false },
            data: { isRead: true },
        });
        return { message: 'All notifications marked as read' };
    }
}
