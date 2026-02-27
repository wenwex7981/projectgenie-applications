import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PrismaService } from './prisma/prisma.service';

@ApiTags('Health')
@Controller()
export class AppController {
  constructor(private prisma: PrismaService) { }

  @Get()
  @ApiOperation({ summary: 'API Status', description: 'Returns the current API status and version information.' })
  @ApiResponse({ status: 200, description: 'API is running' })
  getHello() {
    return {
      name: 'ProjectGenie Enterprise API',
      version: '2.0.0',
      status: 'running',
      environment: process.env.NODE_ENV || 'development',
      timestamp: new Date().toISOString(),
    };
  }

  @Get('health')
  @ApiOperation({ summary: 'Health Check', description: 'Checks API health, database connectivity, and system metrics.' })
  @ApiResponse({ status: 200, description: 'System is healthy' })
  async healthCheck() {
    const startTime = Date.now();
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      return {
        status: 'healthy',
        version: '2.0.0',
        database: 'connected',
        uptime: process.uptime(),
        responseTimeMs: Date.now() - startTime,
        memory: {
          heapUsed: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + 'MB',
          heapTotal: Math.round(process.memoryUsage().heapTotal / 1024 / 1024) + 'MB',
        },
        timestamp: new Date().toISOString(),
      };
    } catch (e) {
      return {
        status: 'unhealthy',
        database: 'disconnected',
        error: (e as Error).message,
        responseTimeMs: Date.now() - startTime,
        timestamp: new Date().toISOString(),
      };
    }
  }
}
