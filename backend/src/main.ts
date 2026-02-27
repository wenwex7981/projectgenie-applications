import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import * as dotenv from 'dotenv';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { GlobalExceptionFilter } from './common/filters/http-exception.filter';
import { TransformResponseInterceptor } from './common/interceptors/transform-response.interceptor';

dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for all origins (Flutter apps connect from different origins)
  app.enableCors({
    origin: true,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });

  // ─── Enterprise Global Pipes ────────────────────────────────────
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: false,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  // ─── Enterprise Global Filters & Interceptors ──────────────────
  app.useGlobalFilters(new GlobalExceptionFilter());
  app.useGlobalInterceptors(new TransformResponseInterceptor());

  // ─── Swagger / OpenAPI Documentation ────────────────────────────
  const config = new DocumentBuilder()
    .setTitle('ProjectGenie Enterprise API')
    .setDescription(
      `## Enterprise SaaS Platform API\n\n` +
      `ProjectGenie is a premium SaaS marketplace for academic projects, services, and mentorship.\n\n` +
      `### Authentication\n` +
      `All protected endpoints require a Bearer JWT token obtained via the Auth endpoints.\n\n` +
      `### Modules\n` +
      `- **Auth** — Registration, Login, OTP Verification, Token Validation\n` +
      `- **Users** — Buyer Profile, Orders, Wallet, Chats, Reviews\n` +
      `- **Vendors** — Seller Profile, Dashboard, Services, Projects, Earnings\n` +
      `- **Services** — Browse, Search, Featured, Trending\n` +
      `- **Projects** — Academic Projects Marketplace\n` +
      `- **Orders** — Order Management & Tracking\n` +
      `- **Custom Orders** — Custom Project Requests\n` +
      `- **Categories** — Service & Project Categories\n` +
      `- **Bundles** — Package Deals\n` +
      `- **Search** — Full-text Search\n` +
      `- **Reviews** — Ratings & Feedback\n` +
      `- **Notifications** — Real-time Notifications\n` +
      `- **Chats** — Messaging System`
    )
    .setVersion('2.0')
    .setContact('ProjectGenie Team', 'https://projectgenie.io', 'api@projectgenie.io')
    .setLicense('Proprietary', 'https://projectgenie.io/license')
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT', description: 'JWT access token' },
      'JWT-auth',
    )
    .addTag('Health', 'API health check and system status')
    .addTag('Auth', 'Authentication — Register, Login, OTP, Token Verification')
    .addTag('Users', 'Buyer/Student profile management, orders, wallet')
    .addTag('Vendors', 'Seller profile, dashboard, services, projects, earnings')
    .addTag('Services', 'Service marketplace — browse, featured, trending')
    .addTag('Projects', 'Academic projects marketplace')
    .addTag('Orders', 'Order management and lifecycle')
    .addTag('Custom Orders', 'Custom project order requests and management')
    .addTag('Categories', 'Service and project categories')
    .addTag('Bundles', 'Bundle/package deals')
    .addTag('Search', 'Full-text search across services and projects')
    .addTag('Reviews', 'Ratings and reviews')
    .addTag('Notifications', 'User/vendor notifications')
    .addTag('Chats', 'Messaging between buyers and vendors')
    .build();

  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, documentFactory, {
    customSiteTitle: 'ProjectGenie API Documentation',
    customfavIcon: 'https://www.svgrepo.com/show/530440/machine-learning.svg',
    customCss: `
      .swagger-ui .topbar { display: none; }
      .swagger-ui .info .title { font-size: 2.2rem; font-weight: 900; }
      .swagger-ui .info { margin: 30px 0; }
    `,
    swaggerOptions: {
      persistAuthorization: true,
      docExpansion: 'none',
      filter: true,
      tagsSorter: 'alpha',
    },
  });

  const port = process.env.PORT ?? 3000;
  await app.listen(port);

  console.log(`\n🧞 ═══════════════════════════════════════════════════════════`);
  console.log(`   ProjectGenie Enterprise API v2.0`);
  console.log(`   Server:    http://localhost:${port}`);
  console.log(`   API Docs:  http://localhost:${port}/api/docs`);
  console.log(`   Health:    http://localhost:${port}/health`);
  console.log(`   Database:  ${process.env.DATABASE_URL?.includes('supabase') ? 'Supabase PostgreSQL' : 'PostgreSQL'}`);
  console.log(`═══════════════════════════════════════════════════════════════\n`);
  console.log(`📡 API Modules: Auth • Users • Vendors • Services • Projects`);
  console.log(`                Orders • Custom Orders • Categories • Bundles`);
  console.log(`                Search • Reviews • Notifications • Chats`);
  console.log(`\n🚀 Enterprise server is ready!\n`);
}
bootstrap();
