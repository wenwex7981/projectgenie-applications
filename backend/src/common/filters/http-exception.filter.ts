import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    HttpStatus,
    Logger,
} from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
    private readonly logger = new Logger(GlobalExceptionFilter.name);

    catch(exception: unknown, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest();

        let status = HttpStatus.INTERNAL_SERVER_ERROR;
        let message = 'Internal server error';
        let error = 'Internal Server Error';

        if (exception instanceof HttpException) {
            status = exception.getStatus();
            const exResponse = exception.getResponse();
            if (typeof exResponse === 'object' && exResponse !== null) {
                message = (exResponse as any).message || exception.message;
                error = (exResponse as any).error || 'Error';
            } else {
                message = exResponse as string;
            }
        } else if (exception instanceof Error) {
            message = exception.message;
            this.logger.error(
                `Unhandled exception: ${exception.message}`,
                exception.stack,
            );
        }

        const errorResponse = {
            success: false,
            statusCode: status,
            error,
            message: Array.isArray(message) ? message : [message],
            timestamp: new Date().toISOString(),
            path: request.url,
        };

        response.status(status).json(errorResponse);
    }
}
