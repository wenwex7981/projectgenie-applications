import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { ServicesModule } from './services/services.module';
import { CategoriesModule } from './categories/categories.module';
import { OrdersModule } from './orders/orders.module';
import { UsersModule } from './users/users.module';
import { BundlesModule } from './bundles/bundles.module';
import { ProjectsModule } from './projects/projects.module';
import { VendorsModule } from './vendors/vendors.module';
import { CustomOrdersModule } from './custom-orders/custom-orders.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ChatsModule } from './chats/chats.module';
import { ReviewsModule } from './reviews/reviews.module';
import { SearchModule } from './search/search.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    ServicesModule,
    CategoriesModule,
    OrdersModule,
    UsersModule,
    BundlesModule,
    ProjectsModule,
    VendorsModule,
    CustomOrdersModule,
    NotificationsModule,
    ChatsModule,
    ReviewsModule,
    SearchModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
