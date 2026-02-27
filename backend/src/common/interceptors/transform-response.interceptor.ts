import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
    Logger,
} from '@nestjs/common';
import { Observable, tap } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable()
export class TransformResponseInterceptor implements NestInterceptor {
    private readonly logger = new Logger('HTTP');

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const request = context.switchToHttp().getRequest();
        const method = request.method;
        const url = request.url;
        const now = Date.now();

        return next.handle().pipe(
            tap(() => {
                const elapsed = Date.now() - now;
                this.logger.log(`${method} ${url} — ${elapsed}ms`);
            }),
            map((data) => ({
                success: true,
                data,
                timestamp: new Date().toISOString(),
            })),
        );
    }
}
