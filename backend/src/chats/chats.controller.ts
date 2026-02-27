import { Controller, Get, Post, Param, Query, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Chats')
@Controller('chats')
export class ChatsController {
    constructor(private prisma: PrismaService) { }

    // ─── Get messages between a user and a vendor ────────────────────
    @Get()
    async getMessages(
        @Query('userId') userId: string,
        @Query('vendorId') vendorId: string,
    ) {
        return this.prisma.chatMessage.findMany({
            where: { userId, vendorId },
            orderBy: { time: 'asc' },
        });
    }

    // ─── Send a message ──────────────────────────────────────────────
    @Post()
    async sendMessage(@Body() body: {
        text: string;
        userId: string;
        vendorId: string;
        isSender: boolean;
    }) {
        const message = await this.prisma.chatMessage.create({
            data: {
                text: body.text,
                userId: body.userId,
                vendorId: body.vendorId,
                isSender: body.isSender,
            },
        });
        return message;
    }

    // ─── Get all chat threads for a user ─────────────────────────────
    @Get('threads/user/:userId')
    async getUserThreads(@Param('userId') userId: string) {
        const messages = await this.prisma.chatMessage.findMany({
            where: { userId },
            orderBy: { time: 'desc' },
        });

        const threads: Record<string, any> = {};
        for (const msg of messages) {
            if (!threads[msg.vendorId]) {
                threads[msg.vendorId] = {
                    vendorId: msg.vendorId,
                    lastMessage: msg.text,
                    lastTime: msg.time,
                    isSender: msg.isSender,
                };
            }
        }

        const results: any[] = [];
        for (const t of Object.values(threads)) {
            const vendor = await this.prisma.vendor.findUnique({
                where: { id: t.vendorId },
                select: { id: true, name: true, businessName: true, profileImage: true },
            });
            results.push({ ...t, vendor });
        }

        return results;
    }

    // ─── Get all chat threads for a vendor ───────────────────────────
    @Get('threads/vendor/:vendorId')
    async getVendorThreads(@Param('vendorId') vendorId: string) {
        const messages = await this.prisma.chatMessage.findMany({
            where: { vendorId },
            orderBy: { time: 'desc' },
        });

        const threads: Record<string, any> = {};
        for (const msg of messages) {
            if (!threads[msg.userId]) {
                threads[msg.userId] = {
                    userId: msg.userId,
                    lastMessage: msg.text,
                    lastTime: msg.time,
                    isSender: msg.isSender,
                };
            }
        }

        const results: any[] = [];
        for (const t of Object.values(threads)) {
            const user = await this.prisma.user.findUnique({
                where: { id: t.userId },
                select: { id: true, name: true, email: true, profileImage: true, college: true },
            });
            results.push({ ...t, user });
        }

        return results;
    }
}
