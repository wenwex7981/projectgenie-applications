require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function fixCategories() {
    console.log("Checking categories in database...");

    const categories = await prisma.category.findMany();

    if (categories.length === 0) {
        console.log("Categories are empty. Inserting default categories...");

        await prisma.category.createMany({
            data: [
                { id: 'cat-1', title: 'Machine Learning', icon: '🤖', count: 124, sortOrder: 1 },
                { id: 'cat-2', title: 'Deep Learning', icon: '🧠', count: 89, sortOrder: 2 },
                { id: 'cat-3', title: 'CNN Projects', icon: '👁️', count: 56, sortOrder: 3 },
                { id: 'cat-4', title: 'Web Development', icon: '💻', count: 342, sortOrder: 4 },
                { id: 'cat-5', title: 'Mobile Apps', icon: '📱', count: 189, sortOrder: 5 },
                { id: 'cat-6', title: 'IoT Projects', icon: '🔌', count: 88, sortOrder: 6 },
                { id: 'cat-7', title: 'Data Science', icon: '📊', count: 95, sortOrder: 7 },
                { id: 'cat-8', title: 'Mini Project', icon: '🚀', count: 150, sortOrder: 8 },
                { id: 'cat-9', title: 'Resume', icon: '📄', count: 45, sortOrder: 9 },
            ],
            skipDuplicates: true,
        });

        console.log("✅ Categories successfully inserted.");
    } else {
        console.log(`Found ${categories.length} categories already via Prisma.`);
    }
}

fixCategories()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
        process.exit(0);
    });
