import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  try {
    console.log('Disabling RLS on storage.buckets and storage.objects...');
    await prisma.$executeRawUnsafe(`ALTER TABLE storage.buckets DISABLE ROW LEVEL SECURITY;`);
    await prisma.$executeRawUnsafe(`ALTER TABLE storage.objects DISABLE ROW LEVEL SECURITY;`);
    console.log('✅ RLS successfully disabled for Storage! Images will now upload without keys.');
  } catch (e) {
    console.error('❌ Error disabling RLS:', e);
  } finally {
    await prisma.$disconnect();
  }
}

main();
