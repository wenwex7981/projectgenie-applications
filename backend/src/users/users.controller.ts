import { Controller, Get, Put, Param, Body, Query, HttpException, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Users')
@Controller('users')
export class UsersController {
    constructor(private prisma: PrismaService) { }

    // ─── Get User Profile ────────────────────────────────────────────
    @Get(':id')
    async findOne(@Param('id') id: string) {
        const user = await this.prisma.user.findUnique({
            where: { id },
            include: {
                _count: { select: { orders: true, customOrders: true, reviews: true } },
            },
        });
        if (!user) throw new HttpException('User not found', HttpStatus.NOT_FOUND);
        const { password, ...result } = user;
        return result;
    }

    // ─── Update User Profile ─────────────────────────────────────────
    @Put(':id')
    async update(@Param('id') id: string, @Body() data: any) {
        delete data.password;
        delete data.walletBalance;
        const user = await this.prisma.user.update({ where: { id }, data });
        const { password, ...result } = user;
        return result;
    }

    // ─── User Orders ─────────────────────────────────────────────────
    @Get(':id/orders')
    async getUserOrders(@Param('id') id: string, @Query('status') status?: string) {
        const where: any = { userId: id };
        if (status) where.status = status;
        return this.prisma.order.findMany({
            where,
            include: {
                service: { select: { id: true, title: true, imageUrl: true, vendorName: true, price: true } },
                vendor: { select: { id: true, name: true, businessName: true } },
            },
            orderBy: { date: 'desc' },
        });
    }

    // ─── User Custom Orders ──────────────────────────────────────────
    @Get(':id/custom-orders')
    async getUserCustomOrders(@Param('id') id: string) {
        return this.prisma.customOrder.findMany({
            where: { userId: id },
            include: {
                vendor: { select: { id: true, name: true, businessName: true } },
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    // ─── Wallet Balance ──────────────────────────────────────────────
    @Get(':id/wallet')
    async getWallet(@Param('id') id: string) {
        const user = await this.prisma.user.findUnique({
            where: { id },
            select: { walletBalance: true },
        });
        if (!user) throw new HttpException('User not found', HttpStatus.NOT_FOUND);
        return { balance: user.walletBalance };
    }

    @Put(':id/wallet/topup')
    async topupWallet(@Param('id') id: string, @Body() body: { amount: number }) {
        if (!body.amount || body.amount <= 0) {
            throw new HttpException('Invalid amount', HttpStatus.BAD_REQUEST);
        }
        const user = await this.prisma.user.update({
            where: { id },
            data: { walletBalance: { increment: body.amount } },
        });
        return { balance: user.walletBalance };
    }

    // ─── Notifications ───────────────────────────────────────────────
    @Get(':id/notifications')
    async getNotifications(@Param('id') id: string) {
        return this.prisma.notification.findMany({
            where: { targetId: id },
            orderBy: { createdAt: 'desc' },
        });
    }

    // ─── User Reviews ────────────────────────────────────────────────
    @Get(':id/reviews')
    async getUserReviews(@Param('id') id: string) {
        return this.prisma.review.findMany({
            where: { userId: id },
            include: { service: { select: { id: true, title: true, imageUrl: true } } },
            orderBy: { date: 'desc' },
        });
    }

    // ─── User Chat Threads ───────────────────────────────────────────
    @Get(':id/chats')
    async getUserChats(@Param('id') id: string) {
        // Get distinct vendor IDs with latest messages
        const messages = await this.prisma.chatMessage.findMany({
            where: { userId: id },
            orderBy: { time: 'desc' },
        });

        // Group by vendorId and get the last message per thread
        const threads: Record<string, any> = {};
        for (const msg of messages) {
            if (!threads[msg.vendorId]) {
                threads[msg.vendorId] = {
                    vendorId: msg.vendorId,
                    lastMessage: msg.text,
                    lastTime: msg.time,
                    unreadCount: 0,
                };
            }
        }

        // Enrich with vendor info
        const threadList = Object.values(threads);
        for (const t of threadList) {
            const vendor = await this.prisma.vendor.findUnique({
                where: { id: t.vendorId },
                select: { id: true, name: true, businessName: true, profileImage: true },
            });
            t.vendor = vendor;
        }

        return threadList;
    }
}
