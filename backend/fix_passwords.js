const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function fix() {
    console.log("Fixing passwords...");
    const hash = await bcrypt.hash('password123', 12);

    await prisma.user.updateMany({ data: { password: hash } });
    await prisma.vendor.updateMany({ data: { password: hash } });

    console.log("✅ All User and Vendor passwords have been successfully fixed to 'password123'");
}

fix().finally(() => prisma.$disconnect());
