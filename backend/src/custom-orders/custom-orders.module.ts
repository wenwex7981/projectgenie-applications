import { Module } from '@nestjs/common';
import { CustomOrdersController } from './custom-orders.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
    imports: [PrismaModule],
    controllers: [CustomOrdersController],
})
export class CustomOrdersModule { }
