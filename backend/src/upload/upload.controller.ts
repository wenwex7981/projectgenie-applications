import { Controller, Post, Body, HttpException, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://pweuldjxqksffmaednjc.supabase.co';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

@ApiTags('Upload')
@Controller('upload')
export class UploadController {
    private supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    @Post('signed-url')
    @ApiOperation({ summary: 'Get a signed upload URL for Supabase storage' })
    async getSignedUploadUrl(@Body() body: {
        bucket: string;
        path: string;
        contentType?: string;
    }) {
        if (!body.bucket || !body.path) {
            throw new HttpException('bucket and path are required', HttpStatus.BAD_REQUEST);
        }

        try {
            const { data, error } = await this.supabase.storage
                .from(body.bucket)
                .createSignedUploadUrl(body.path);

            if (error) throw error;

            const publicUrl = this.supabase.storage
                .from(body.bucket)
                .getPublicUrl(body.path).data.publicUrl;

            return {
                signedUrl: data.signedUrl,
                token: data.token,
                path: data.path,
                publicUrl,
            };
        } catch (e: any) {
            throw new HttpException(
                `Upload URL generation failed: ${e.message || e}`,
                HttpStatus.INTERNAL_SERVER_ERROR,
            );
        }
    }

    @Post('base64')
    @ApiOperation({ summary: 'Upload a base64 file to Supabase storage' })
    async uploadBase64(@Body() body: {
        bucket: string;
        path: string;
        base64Data: string;
        contentType: string;
    }) {
        if (!body.bucket || !body.path || !body.base64Data || !body.contentType) {
            throw new HttpException(
                'bucket, path, base64Data, and contentType are required',
                HttpStatus.BAD_REQUEST,
            );
        }

        try {
            const buffer = Buffer.from(body.base64Data, 'base64');

            const { data, error } = await this.supabase.storage
                .from(body.bucket)
                .upload(body.path, buffer, {
                    contentType: body.contentType,
                    upsert: true,
                });

            if (error) throw error;

            const publicUrl = this.supabase.storage
                .from(body.bucket)
                .getPublicUrl(body.path).data.publicUrl;

            return {
                path: data.path,
                publicUrl,
                bucket: body.bucket,
            };
        } catch (e: any) {
            throw new HttpException(
                `File upload failed: ${e.message || e}`,
                HttpStatus.INTERNAL_SERVER_ERROR,
            );
        }
    }

    @Post('ensure-buckets')
    @ApiOperation({ summary: 'Ensure all required storage buckets exist' })
    async ensureBuckets() {
        const buckets = ['vendor_assets', 'documents', 'project_files', 'profile_images'];
        const results: any[] = [];

        for (const bucket of buckets) {
            try {
                const { data: existing } = await this.supabase.storage.getBucket(bucket);
                if (existing) {
                    results.push({ bucket, status: 'exists' });
                } else {
                    const { data, error } = await this.supabase.storage.createBucket(bucket, {
                        public: true,
                        allowedMimeTypes: ['image/*', 'video/*', 'application/pdf', 'application/msword',
                            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                            'application/vnd.ms-powerpoint',
                            'application/vnd.openxmlformats-officedocument.presentationml.presentation'],
                        fileSizeLimit: 52428800, // 50MB
                    });
                    if (error) results.push({ bucket, status: 'error', error: error.message });
                    else results.push({ bucket, status: 'created' });
                }
            } catch (e: any) {
                results.push({ bucket, status: 'error', error: e.message });
            }
        }

        return { buckets: results };
    }
}
