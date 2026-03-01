import { Module } from '@nestjs/common';
import { HackathonsController } from './hackathons.controller';

@Module({
    controllers: [HackathonsController],
})
export class HackathonsModule { }
