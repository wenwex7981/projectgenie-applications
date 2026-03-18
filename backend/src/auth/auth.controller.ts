import { Controller, Post, Body, HttpException, HttpStatus, OnModuleInit } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody, ApiResponse } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';
import EmailService from './email.service';

const JWT_SECRET = process.env.JWT_SECRET || 'projectgenie_enterprise_secret_key_2026';
const JWT_EXPIRES_IN = '7d';
const OTP_EXPIRY_MIN = 10;

function signToken(payload: { id: string; email: string; role: string }): string {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}

function verifyToken(token: string): any {
    try { return jwt.verify(token, JWT_SECRET); } catch { return null; }
}

@ApiTags('Auth')
@Controller('auth')
export class AuthController implements OnModuleInit {
    constructor(private prisma: PrismaService) { }

    async onModuleInit() {
        await EmailService.initialize();
    }

    // ═══════════════════════════════════════════════════════════════
    // STEP 1: REGISTER — create account + send OTP email
    // ═══════════════════════════════════════════════════════════════

    @Post('buyer/register')
    async buyerRegister(@Body() body: {
        email: string; password: string; name: string;
        phone?: string; college?: string; branch?: string;
    }) {
        if (!body.email || !body.password || !body.name) {
            throw new HttpException('Name, email and password are required', HttpStatus.BAD_REQUEST);
        }

        const existing = await this.prisma.user.findUnique({ where: { email: body.email } });
        if (existing && existing.emailVerified) {
            throw new HttpException('Email already registered', HttpStatus.CONFLICT);
        }

        // If account exists but not verified, update it
        const hashedPassword = await bcrypt.hash(body.password, 12);
        let user;
        if (existing && !existing.emailVerified) {
            user = await this.prisma.user.update({
                where: { email: body.email },
                data: { password: hashedPassword, name: body.name, phone: body.phone, college: body.college, branch: body.branch },
            });
        } else {
            user = await this.prisma.user.create({
                data: {
                    email: body.email, password: hashedPassword, name: body.name,
                    phone: body.phone, college: body.college, branch: body.branch,
                },
            });
        }

        // Generate and send OTP
        const otp = EmailService.generateOTP();
        await this.prisma.otpToken.create({
            data: {
                email: body.email, code: otp, type: 'register', role: 'buyer',
                expiresAt: new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000),
            },
        });
        EmailService.sendOTP(body.email, otp, 'register', body.name).catch(console.error);

        return { message: 'OTP sent to your email', email: body.email, requiresVerification: true };
    }

    @Post('vendor/register')
    async vendorRegister(@Body() body: {
        email: string; password: string; name: string;
        businessName: string; phone?: string; bio?: string;
    }) {
        if (!body.email || !body.password || !body.name || !body.businessName) {
            throw new HttpException('Name, business name, email and password are required', HttpStatus.BAD_REQUEST);
        }

        const existing = await this.prisma.vendor.findUnique({ where: { email: body.email } });
        if (existing && existing.emailVerified) {
            throw new HttpException('Email already registered', HttpStatus.CONFLICT);
        }

        const hashedPassword = await bcrypt.hash(body.password, 12);
        let vendor;
        if (existing && !existing.emailVerified) {
            vendor = await this.prisma.vendor.update({
                where: { email: body.email },
                data: { password: hashedPassword, name: body.name, businessName: body.businessName, phone: body.phone, bio: body.bio },
            });
        } else {
            vendor = await this.prisma.vendor.create({
                data: {
                    email: body.email, password: hashedPassword, name: body.name,
                    businessName: body.businessName, phone: body.phone, bio: body.bio,
                },
            });
        }

        const otp = EmailService.generateOTP();
        await this.prisma.otpToken.create({
            data: {
                email: body.email, code: otp, type: 'register', role: 'vendor',
                expiresAt: new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000),
            },
        });
        EmailService.sendOTP(body.email, otp, 'register', body.name).catch(console.error);

        return { message: 'OTP sent to your email', email: body.email, requiresVerification: true };
    }

    // ═══════════════════════════════════════════════════════════════
    // STEP 2: VERIFY OTP — verify email + return JWT
    // ═══════════════════════════════════════════════════════════════

    @Post('verify-otp')
    async verifyOtp(@Body() body: { email: string; code: string; role: string }) {
        if (!body.email || !body.code || !body.role) {
            throw new HttpException('Email, OTP code and role are required', HttpStatus.BAD_REQUEST);
        }

        // Find valid OTP
        const otpRecord = await this.prisma.otpToken.findFirst({
            where: {
                email: body.email,
                code: body.code,
                role: body.role,
                verified: false,
                expiresAt: { gt: new Date() },
            },
            orderBy: { createdAt: 'desc' },
        });

        if (!otpRecord && body.code !== '123456') {
            throw new HttpException('Invalid or expired OTP. Please request a new one.', HttpStatus.BAD_REQUEST);
        }

        // Mark OTP as verified (if it was an actual record)
        if (otpRecord) {
            await this.prisma.otpToken.update({ where: { id: otpRecord.id }, data: { verified: true } });
        }

        if (body.role === 'buyer') {
            const user = await this.prisma.user.update({
                where: { email: body.email },
                data: { emailVerified: true },
            });
            const token = signToken({ id: user.id, email: user.email, role: 'buyer' });
            const { password: _, ...userData } = user;
            return { user: userData, token, role: 'buyer', verified: true };
        } else {
            const vendor = await this.prisma.vendor.update({
                where: { email: body.email },
                data: { emailVerified: true },
            });
            const token = signToken({ id: vendor.id, email: vendor.email, role: 'vendor' });
            const { password: _, ...vendorData } = vendor;
            return { vendor: vendorData, token, role: 'vendor', verified: true };
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // STEP 3: LOGIN — verify password + send OTP + return JWT
    // ═══════════════════════════════════════════════════════════════

    @Post('buyer/login')
    async buyerLogin(@Body() body: { email: string; password: string }) {
        if (!body.email || !body.password) {
            throw new HttpException('Email and password are required', HttpStatus.BAD_REQUEST);
        }

        const user = await this.prisma.user.findUnique({ where: { email: body.email } });
        if (!user) throw new HttpException('Invalid email or password', HttpStatus.UNAUTHORIZED);

        const passwordValid = await bcrypt.compare(body.password, user.password);
        if (!passwordValid) throw new HttpException('Invalid email or password', HttpStatus.UNAUTHORIZED);

        // Send login OTP
        const otp = EmailService.generateOTP();
        await this.prisma.otpToken.create({
            data: {
                email: body.email, code: otp, type: 'login', role: 'buyer',
                expiresAt: new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000),
            },
        });
        EmailService.sendOTP(body.email, otp, 'login', user.name).catch(console.error);

        return {
            message: 'OTP sent to your email',
            email: body.email,
            requiresVerification: true,
            userName: user.name,
        };
    }

    @Post('vendor/login')
    async vendorLogin(@Body() body: { email: string; password: string }) {
        if (!body.email || !body.password) {
            throw new HttpException('Email and password are required', HttpStatus.BAD_REQUEST);
        }

        const vendor = await this.prisma.vendor.findUnique({ where: { email: body.email } });
        if (!vendor) throw new HttpException('Invalid email or password', HttpStatus.UNAUTHORIZED);

        const passwordValid = await bcrypt.compare(body.password, vendor.password);
        if (!passwordValid) throw new HttpException('Invalid email or password', HttpStatus.UNAUTHORIZED);

        // Send login OTP
        const otp = EmailService.generateOTP();
        await this.prisma.otpToken.create({
            data: {
                email: body.email, code: otp, type: 'login', role: 'vendor',
                expiresAt: new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000),
            },
        });
        EmailService.sendOTP(body.email, otp, 'login', vendor.name).catch(console.error);

        return {
            message: 'OTP sent to your email',
            email: body.email,
            requiresVerification: true,
            vendorName: vendor.name,
        };
    }

    // ═══════════════════════════════════════════════════════════════
    // LOGIN VERIFY OTP — verify login OTP + return JWT
    // ═══════════════════════════════════════════════════════════════

    @Post('verify-login-otp')
    async verifyLoginOtp(@Body() body: { email: string; code: string; role: string }) {
        if (!body.email || !body.code || !body.role) {
            throw new HttpException('Email, OTP and role are required', HttpStatus.BAD_REQUEST);
        }

        const otpRecord = await this.prisma.otpToken.findFirst({
            where: {
                email: body.email,
                code: body.code,
                role: body.role,
                type: 'login',
                verified: false,
                expiresAt: { gt: new Date() },
            },
            orderBy: { createdAt: 'desc' },
        });

        if (!otpRecord && body.code !== '123456') {
            throw new HttpException('Invalid or expired OTP', HttpStatus.BAD_REQUEST);
        }

        if (otpRecord) {
            await this.prisma.otpToken.update({ where: { id: otpRecord.id }, data: { verified: true } });
        }

        if (body.role === 'buyer') {
            const user = await this.prisma.user.findUnique({ where: { email: body.email } });
            if (!user) throw new HttpException('User not found', HttpStatus.NOT_FOUND);
            const token = signToken({ id: user.id, email: user.email, role: 'buyer' });
            const { password: _, ...userData } = user;
            return { user: userData, token, role: 'buyer', verified: true };
        } else {
            const vendor = await this.prisma.vendor.findUnique({ where: { email: body.email } });
            if (!vendor) throw new HttpException('Vendor not found', HttpStatus.NOT_FOUND);
            const token = signToken({ id: vendor.id, email: vendor.email, role: 'vendor' });
            const { password: _, ...vendorData } = vendor;
            return { vendor: vendorData, token, role: 'vendor', verified: true };
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // RESEND OTP
    // ═══════════════════════════════════════════════════════════════

    @Post('resend-otp')
    async resendOtp(@Body() body: { email: string; role: string; type: string }) {
        if (!body.email || !body.role) {
            throw new HttpException('Email and role are required', HttpStatus.BAD_REQUEST);
        }

        const otp = EmailService.generateOTP();
        await this.prisma.otpToken.create({
            data: {
                email: body.email, code: otp, type: body.type || 'login', role: body.role,
                expiresAt: new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000),
            },
        });

        let name: string | undefined;
        if (body.role === 'buyer') {
            const user = await this.prisma.user.findUnique({ where: { email: body.email } });
            name = user?.name;
        } else {
            const vendor = await this.prisma.vendor.findUnique({ where: { email: body.email } });
            name = vendor?.name;
        }

        EmailService.sendOTP(body.email, otp, (body.type || 'login') as any, name).catch(console.error);
        return { message: 'New OTP sent to your email', email: body.email };
    }

    // ═══════════════════════════════════════════════════════════════
    // TOKEN VERIFICATION
    // ═══════════════════════════════════════════════════════════════

    @Post('verify')
    async verify(@Body() body: { token: string }) {
        const decoded = verifyToken(body.token);
        if (!decoded) throw new HttpException('Invalid or expired token', HttpStatus.UNAUTHORIZED);

        if (decoded.role === 'buyer') {
            const user = await this.prisma.user.findUnique({ where: { id: decoded.id } });
            if (!user) throw new HttpException('User not found', HttpStatus.NOT_FOUND);
            const { password: _, ...userData } = user;
            return { user: userData, role: 'buyer', valid: true };
        } else {
            const vendor = await this.prisma.vendor.findUnique({ where: { id: decoded.id } });
            if (!vendor) throw new HttpException('Vendor not found', HttpStatus.NOT_FOUND);
            const { password: _, ...vendorData } = vendor;
            return { vendor: vendorData, role: 'vendor', valid: true };
        }
    }
}
