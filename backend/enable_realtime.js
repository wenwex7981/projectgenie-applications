const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function enableRealtime() {
    try {
        // Attempting to enable realtime for Notification model on Supabase's realtime publication
        await prisma.$executeRawUnsafe('ALTER PUBLICATION supabase_realtime ADD TABLE "Notification";');
        console.log('Successfully enabled realtime on Notification table!');
    } catch (e) {
        if (e.message && e.message.includes('already exists')) {
            console.log('Table is already in the publication');
        } else {
            console.error('Error (might be expected if publication not set up strictly this way):', e.message);
        }
    } finally {
        await prisma.$disconnect();
    }
}

enableRealtime();
