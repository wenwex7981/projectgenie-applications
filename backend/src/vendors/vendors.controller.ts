import { Controller, Get, Post, Put, Param, Query, Body, HttpException, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';

@ApiTags('Vendors')
@Controller('vendors')
export class VendorsController {
    constructor(private prisma: PrismaService) { }

    // ─── Auth ─────────────────────────────────────────────────────────
    @Post('login')
    async login(@Body() body: { email: string; password: string }) {
        const vendor = await this.prisma.vendor.findUnique({ where: { email: body.email } });
        if (!vendor || vendor.password !== body.password) {
            throw new HttpException('Invalid credentials', HttpStatus.UNAUTHORIZED);
        }
        const { password, ...result } = vendor;
        return { vendor: result, token: `vendor_token_${vendor.id}` };
    }

    @Post('register')
    async register(@Body() data: any) {
        const existing = await this.prisma.vendor.findUnique({ where: { email: data.email } });
        if (existing) throw new HttpException('Email already registered', HttpStatus.CONFLICT);
        const vendor = await this.prisma.vendor.create({ data });
        const { password, ...result } = vendor;
        return { vendor: result, token: `vendor_token_${vendor.id}` };
    }

    // ─── Profile ──────────────────────────────────────────────────────
    @Get(':id')
    async getProfile(@Param('id') id: string) {
        const vendor = await this.prisma.vendor.findUnique({
            where: { id },
            include: {
                _count: { select: { services: true, projects: true, orders: true, customOrders: true } },
            },
        });
        if (!vendor) throw new HttpException('Vendor not found', HttpStatus.NOT_FOUND);
        const { password, ...result } = vendor;
        return result;
    }

    @Put(':id')
    async updateProfile(@Param('id') id: string, @Body() data: any) {
        delete data.password; // Don't allow password update here
        const vendor = await this.prisma.vendor.update({ where: { id }, data });
        const { password, ...result } = vendor;
        return result;
    }

    // ─── Vendor Dashboard Stats ───────────────────────────────────────
    @Get(':id/dashboard')
    async getDashboard(@Param('id') id: string) {
        const [totalOrders, activeOrders, completedOrders, totalServices, totalProjects,
            pendingCustomOrders, totalEarnings, recentOrders, recentTransactions] = await Promise.all([
                this.prisma.order.count({ where: { vendorId: id } }),
                this.prisma.order.count({ where: { vendorId: id, status: 'Active' } }),
                this.prisma.order.count({ where: { vendorId: id, status: 'Completed' } }),
                this.prisma.service.count({ where: { vendorId: id, isActive: true } }),
                this.prisma.project.count({ where: { vendorId: id, isActive: true } }),
                this.prisma.customOrder.count({ where: { vendorId: id, status: { in: ['Pending Review', 'Accepted'] } } }),
                this.prisma.transaction.aggregate({ where: { vendorId: id, type: 'credit', status: 'completed' }, _sum: { amount: true } }),
                this.prisma.order.findMany({
                    where: { vendorId: id }, orderBy: { date: 'desc' }, take: 5,
                    include: { user: { select: { name: true, email: true } }, service: { select: { title: true } } },
                }),
                this.prisma.transaction.findMany({
                    where: { vendorId: id }, orderBy: { createdAt: 'desc' }, take: 10,
                }),
            ]);

        return {
            stats: {
                totalOrders, activeOrders, completedOrders,
                totalServices, totalProjects, pendingCustomOrders,
                totalEarnings: totalEarnings._sum.amount || 0,
            },
            recentOrders,
            recentTransactions,
        };
    }

    // ─── Vendor's Services ────────────────────────────────────────────
    @Get(':id/services')
    async getVendorServices(@Param('id') id: string) {
        return this.prisma.service.findMany({
            where: { vendorId: id },
            include: { category: true, _count: { select: { orders: true, reviews: true } } },
            orderBy: { createdAt: 'desc' },
        });
    }

    // ─── Vendor's Projects ────────────────────────────────────────────
    @Get(':id/projects')
    async getVendorProjects(@Param('id') id: string) {
        return this.prisma.project.findMany({
            where: { vendorId: id },
            orderBy: { createdAt: 'desc' },
        });
    }

    // ─── Vendor's Orders ──────────────────────────────────────────────
    @Get(':id/orders')
    async getVendorOrders(@Param('id') id: string, @Query('status') status?: string) {
        const where: any = { vendorId: id };
        if (status) where.status = status;
        return this.prisma.order.findMany({
            where,
            include: {
                user: { select: { id: true, name: true, email: true, phone: true } },
                service: { select: { id: true, title: true, imageUrl: true } },
            },
            orderBy: { date: 'desc' },
        });
    }

    // ─── Vendor's Custom Orders ───────────────────────────────────────
    @Get(':id/custom-orders')
    async getVendorCustomOrders(@Param('id') id: string) {
        return this.prisma.customOrder.findMany({
            where: { vendorId: id },
            include: { user: { select: { id: true, name: true, email: true, phone: true } } },
            orderBy: { createdAt: 'desc' },
        });
    }

    // ─── Vendor's Transactions / Earnings ─────────────────────────────
    @Get(':id/transactions')
    async getVendorTransactions(@Param('id') id: string) {
        return this.prisma.transaction.findMany({
            where: { vendorId: id },
            orderBy: { createdAt: 'desc' },
        });
    }

    @Get(':id/earnings')
    async getVendorEarnings(@Param('id') id: string) {
        const [total, pending, thisMonth] = await Promise.all([
            this.prisma.transaction.aggregate({ where: { vendorId: id, type: 'credit', status: 'completed' }, _sum: { amount: true } }),
            this.prisma.transaction.aggregate({ where: { vendorId: id, type: 'credit', status: 'pending' }, _sum: { amount: true } }),
            this.prisma.transaction.aggregate({
                where: {
                    vendorId: id, type: 'credit', status: 'completed',
                    createdAt: { gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1) },
                },
                _sum: { amount: true },
            }),
        ]);
        return {
            totalEarnings: total._sum.amount || 0,
            pendingEarnings: pending._sum.amount || 0,
            thisMonthEarnings: thisMonth._sum.amount || 0,
        };
    }
}
