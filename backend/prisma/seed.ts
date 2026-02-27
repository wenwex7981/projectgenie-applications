import { PrismaClient } from '@prisma/client';
import * as dotenv from 'dotenv';
import * as bcrypt from 'bcryptjs';

dotenv.config();

const prisma = new PrismaClient();

async function main() {
    console.log('🗑️  Clearing existing data...');
    await prisma.otpToken.deleteMany();
    await prisma.notification.deleteMany();
    await prisma.transaction.deleteMany();
    await prisma.chatMessage.deleteMany();
    await prisma.customOrder.deleteMany();
    await prisma.review.deleteMany();
    await prisma.order.deleteMany();
    await prisma.project.deleteMany();
    await prisma.service.deleteMany();
    await prisma.category.deleteMany();
    await prisma.bundle.deleteMany();
    await prisma.user.deleteMany();
    await prisma.vendor.deleteMany();

    // ─── 1. VENDORS ─────────────────────────────────────────────────
    console.log('👨‍💼 Creating vendors...');
    const vendors = await Promise.all([
        prisma.vendor.create({
            data: {
                id: 'vendor-001', email: 'ailab@projectgenie.com', password: await bcrypt.hash('password123', 12),
                name: 'Dr. Priya Sharma', businessName: 'AI Research Lab',
                phone: '+91 98765 43210', bio: 'PhD in ML from IIT Delhi. 8+ years building AI/ML projects for students.',
                rating: 4.9, totalEarnings: 450000, totalOrders: 328, isVerified: true, emailVerified: true,
            },
        }),
        prisma.vendor.create({
            data: {
                id: 'vendor-002', email: 'codemasters@projectgenie.com', password: await bcrypt.hash('password123', 12),
                name: 'Rajesh Kumar', businessName: 'CodeMasters',
                phone: '+91 87654 32109', bio: 'Full-stack developer with expertise in MERN, Flutter, and cloud architecture.',
                rating: 4.8, totalEarnings: 620000, totalOrders: 540, isVerified: true, emailVerified: true,
            },
        }),
        prisma.vendor.create({
            data: {
                id: 'vendor-003', email: 'pywizards@projectgenie.com', password: await bcrypt.hash('password123', 12),
                name: 'Ankit Verma', businessName: 'PyWizards',
                phone: '+91 76543 21098', bio: 'Python automation & NLP specialist. Helped 500+ students ace their projects.',
                rating: 4.7, totalEarnings: 280000, totalOrders: 215, isVerified: true, emailVerified: true,
            },
        }),
        prisma.vendor.create({
            data: {
                id: 'vendor-004', email: 'visionary@projectgenie.com', password: await bcrypt.hash('password123', 12),
                name: 'Sneha Reddy', businessName: 'Visionary Tech',
                phone: '+91 65432 10987', bio: 'Computer vision expert specializing in OpenCV and deep learning applications.',
                rating: 4.6, totalEarnings: 190000, totalOrders: 189, isVerified: true, emailVerified: true,
            },
        }),
        prisma.vendor.create({
            data: {
                id: 'vendor-005', email: 'mobileexperts@projectgenie.com', password: await bcrypt.hash('password123', 12),
                name: 'Vikram Singh', businessName: 'Mobile Experts',
                phone: '+91 54321 09876', bio: 'Mobile app development — Flutter, React Native, and native iOS/Android.',
                rating: 4.7, totalEarnings: 340000, totalOrders: 195, isVerified: true, emailVerified: true,
            },
        }),
    ]);

    // ─── 2. CATEGORIES ──────────────────────────────────────────────
    console.log('📁 Creating categories...');
    const cats = await Promise.all([
        prisma.category.create({ data: { id: 'cat-ml', title: 'Machine Learning', icon: 'smart_toy', count: 245, sortOrder: 1 } }),
        prisma.category.create({ data: { id: 'cat-dl', title: 'Deep Learning', icon: 'psychology', count: 198, sortOrder: 2 } }),
        prisma.category.create({ data: { id: 'cat-cnn', title: 'CNN Projects', icon: 'visibility', count: 167, sortOrder: 3 } }),
        prisma.category.create({ data: { id: 'cat-web', title: 'Web Development', icon: 'web', count: 320, sortOrder: 4 } }),
        prisma.category.create({ data: { id: 'cat-app', title: 'Mobile Apps', icon: 'phone_iphone', count: 210, sortOrder: 5 } }),
        prisma.category.create({ data: { id: 'cat-iot', title: 'IoT Projects', icon: 'sensors', count: 96, sortOrder: 6 } }),
        prisma.category.create({ data: { id: 'cat-ds', title: 'Data Science', icon: 'analytics', count: 156, sortOrder: 7 } }),
        prisma.category.create({ data: { id: 'cat-intern', title: 'Internships', icon: 'work', count: 45, sortOrder: 8 } }),
        prisma.category.create({ data: { id: 'cat-mini', title: 'Mini Project', icon: 'code', count: 1200, sortOrder: 9 } }),
        prisma.category.create({ data: { id: 'cat-blockchain', title: 'Blockchain', icon: 'link', count: 67, sortOrder: 10 } }),
        prisma.category.create({ data: { id: 'cat-cyber', title: 'Cyber Security', icon: 'security', count: 89, sortOrder: 11 } }),
        prisma.category.create({ data: { id: 'cat-resume', title: 'Resume', icon: 'description', count: 350, sortOrder: 12 } }),
    ]);

    // ─── 3. SERVICES ────────────────────────────────────────────────
    console.log('🛒 Creating services...');
    const servicesData = [
        {
            title: 'Advanced Breast Cancer Detection using CNN',
            description: 'State-of-the-art CNN model for early breast cancer detection from histopathological images. Includes complete dataset, Python scripts, training pipeline, evaluation metrics, and a detailed IEEE-format research report.',
            vendorName: 'AI Research Lab', price: 4999, originalPrice: 8000,
            rating: 4.9, reviewCount: 128, deliveryDays: 'Instant',
            isFeatured: true, isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800',
            categoryId: 'cat-cnn', vendorId: 'vendor-001',
            features: JSON.stringify(['98.5% Accuracy', 'Full Source Code', 'IEEE Research Paper', 'PPT Presentation', 'Installation Guide']),
        },
        {
            title: 'E-Commerce Full Stack MERN Application',
            description: 'Complete production-ready MERN stack e-commerce platform with admin dashboard, Stripe payment integration, order tracking, user auth, product search with filters, and responsive UI.',
            vendorName: 'CodeMasters', price: 5500, originalPrice: 12000,
            rating: 4.8, reviewCount: 340, deliveryDays: '2 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f7a07d?w=800',
            categoryId: 'cat-web', vendorId: 'vendor-002',
            features: JSON.stringify(['Responsive Design', 'Admin Panel', 'Stripe Payment', 'JWT Auth', 'Docker Ready']),
        },
        {
            title: 'Intelligent Chatbot with NLP & Python',
            description: 'Context-aware chatbot using NLTK, TensorFlow and transformer architecture for customer support automation.',
            vendorName: 'PyWizards', price: 2999, originalPrice: 4500,
            rating: 4.7, reviewCount: 215, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1531746790731-6c087fecd65a?w=800',
            categoryId: 'cat-ml', vendorId: 'vendor-003',
            features: JSON.stringify(['NLP Integrated', 'Easy Customization', 'Documentation', 'Flask API']),
        },
        {
            title: 'Real-Time Driver Drowsiness Detection',
            description: 'OpenCV + Dlib based drowsiness detection with eye aspect ratio calculation and audible alerts.',
            vendorName: 'Visionary Tech', price: 3200, originalPrice: 5000,
            rating: 4.6, reviewCount: 189, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800',
            categoryId: 'cat-cnn', vendorId: 'vendor-004',
            features: JSON.stringify(['Real-time Detection', 'Face Landmark', 'Alert System', 'Report']),
        },
        {
            title: 'Stock Market Prediction with LSTM',
            description: 'Deep learning LSTM model for stock price prediction with visualization dashboard.',
            vendorName: 'AI Research Lab', price: 3500, originalPrice: 6000,
            rating: 4.6, reviewCount: 112, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800',
            categoryId: 'cat-dl', vendorId: 'vendor-001',
            features: JSON.stringify(['LSTM Architecture', 'Data Pipeline', 'Visualization', 'Report']),
        },
        {
            title: 'Uber Clone App (Flutter)',
            description: 'Full-featured ride booking app with real-time tracking, maps integration, driver/rider apps.',
            vendorName: 'Mobile Experts', price: 8000, originalPrice: 15000,
            rating: 4.7, reviewCount: 95, deliveryDays: '5 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800',
            categoryId: 'cat-app', vendorId: 'vendor-005',
            features: JSON.stringify(['Google Maps', 'Real-time Tracking', 'Payment Gateway', 'Admin Panel']),
        },
        {
            title: 'Library Management System (Java)',
            description: 'Java & MySQL based library management with admin panel, search, and reporting.',
            vendorName: 'CodeMasters', price: 499, rating: 4.2, reviewCount: 56,
            deliveryDays: 'Instant',
            imageUrl: 'https://images.unsplash.com/photo-1507842217121-9e93a5893a2e?w=800',
            categoryId: 'cat-mini', vendorId: 'vendor-002',
            features: JSON.stringify(['CRUD Operations', 'Login System', 'Search']),
        },
        {
            title: 'Weather Forecast App (React Native)',
            description: 'Cross-platform weather app with OpenWeatherMap API, location-based forecasts, and clean UI.',
            vendorName: 'Mobile Experts', price: 699, rating: 4.5, reviewCount: 88,
            deliveryDays: 'Instant',
            imageUrl: 'https://images.unsplash.com/photo-1592210454359-9043f53b056c?w=800',
            categoryId: 'cat-mini', vendorId: 'vendor-005',
        },
        {
            title: 'IoT Smart Home Automation System',
            description: 'Arduino + ESP32 based smart home system with mobile app, voice control, and cloud dashboard.',
            vendorName: 'Visionary Tech', price: 4500, originalPrice: 7000,
            rating: 4.5, reviewCount: 67, deliveryDays: '3 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800',
            categoryId: 'cat-iot', vendorId: 'vendor-004',
            features: JSON.stringify(['Arduino Code', 'Mobile App', 'Cloud Dashboard', 'Voice Control']),
        },
        {
            title: 'Professional Resume Template Pack',
            description: '15 premium ATS-friendly resume templates in Word and PDF formats.',
            vendorName: 'CodeMasters', price: 299, originalPrice: 999,
            rating: 4.8, reviewCount: 520, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=800',
            categoryId: 'cat-resume', vendorId: 'vendor-002',
            features: JSON.stringify(['15 Templates', 'ATS-Friendly', 'Editable', 'Cover Letter']),
        },
    ];

    for (const s of servicesData) {
        await prisma.service.create({ data: s });
    }

    // ─── 4. PROJECTS ────────────────────────────────────────────────
    console.log('📂 Creating projects...');
    const projectsData = [
        {
            title: 'AI-Powered Plant Disease Detection System',
            domain: 'AI/ML', branch: 'Computer Science',
            price: '₹4,999', originalPrice: '₹7,999',
            description: 'Deep learning CNN model to identify 38+ plant diseases from leaf images. Features mobile-friendly UI, real-time camera inference, and detailed treatment recommendations.',
            imageUrl: 'https://images.unsplash.com/photo-1625246333195-09d9d8855404?w=800',
            techStack: JSON.stringify(['Python', 'TensorFlow', 'Flask', 'React Native']),
            rating: 4.9, reviewCount: 324, enrollees: 1250,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-001', categoryId: 'cat-ml',
        },
        {
            title: 'Smart Traffic Management using IoT & ML',
            domain: 'IoT', branch: 'Electronics & Communication',
            price: '₹5,499', originalPrice: '₹8,999',
            description: 'IoT-based traffic management that uses ML to predict congestion and optimize signal timings. Includes hardware schematics and simulation.',
            imageUrl: 'https://images.unsplash.com/photo-1505663912202-ac22d4cb3707?w=800',
            techStack: JSON.stringify(['Python', 'Arduino', 'TensorFlow Lite', 'MQTT']),
            rating: 4.7, reviewCount: 198, enrollees: 890,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-004', categoryId: 'cat-iot',
        },
        {
            title: 'Blockchain-Based Voting System',
            domain: 'Blockchain', branch: 'Computer Science',
            price: '₹6,999', originalPrice: '₹11,999',
            description: 'Secure, transparent e-voting platform built on Ethereum. Smart contracts for vote integrity, React frontend, and comprehensive audit trail.',
            imageUrl: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800',
            techStack: JSON.stringify(['Solidity', 'Web3.js', 'React', 'Node.js', 'Ganache']),
            rating: 4.8, reviewCount: 156, enrollees: 720,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-002', categoryId: 'cat-blockchain',
        },
        {
            title: 'Face Recognition Attendance System',
            domain: 'Computer Science', branch: 'Computer Science',
            price: '₹3,999', originalPrice: '₹5,999',
            description: 'Real-time face recognition attendance system using dlib and OpenCV. Web dashboard for teachers.',
            imageUrl: 'https://images.unsplash.com/photo-1526628953301-3e589a6a8b74?w=800',
            techStack: JSON.stringify(['Python', 'OpenCV', 'dlib', 'Flask', 'SQLite']),
            rating: 4.6, reviewCount: 245, enrollees: 1500,
            difficulty: 'Intermediate', isFeatured: true,
            vendorId: 'vendor-004', categoryId: 'cat-cnn',
        },
        {
            title: 'Hospital Management System (MERN)',
            domain: 'Web Development', branch: 'Computer Science',
            price: '₹4,499', originalPrice: '₹7,499',
            description: 'Full featured HMS with patient records, appointments, billing, pharmacy, and lab management.',
            imageUrl: 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=800',
            techStack: JSON.stringify(['MongoDB', 'Express.js', 'React', 'Node.js']),
            rating: 4.5, reviewCount: 178, enrollees: 960,
            difficulty: 'Intermediate',
            vendorId: 'vendor-002', categoryId: 'cat-web',
        },
        {
            title: 'Sentiment Analysis on Twitter Data',
            domain: 'Data Science', branch: 'Computer Science',
            price: '₹2,999', originalPrice: '₹4,999',
            description: 'NLP-based sentiment analysis pipeline using BERT. Includes data collection, preprocessing, model training.',
            imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
            techStack: JSON.stringify(['Python', 'BERT', 'Pandas', 'Streamlit']),
            rating: 4.4, reviewCount: 134, enrollees: 680,
            difficulty: 'Intermediate',
            vendorId: 'vendor-001', categoryId: 'cat-ds',
        },
    ];

    for (const p of projectsData) {
        await prisma.project.create({ data: p });
    }

    // ─── 5. USERS ───────────────────────────────────────────────────
    console.log('👤 Creating users...');
    const user = await prisma.user.create({
        data: {
            id: 'user-001', email: 'vardhan@university.edu', password: await bcrypt.hash('password123', 12),
            name: 'Vardhan Kumar', phone: '+91 98765 43210',
            college: 'JNTU Hyderabad', branch: 'CSE', walletBalance: 2450, emailVerified: true,
        },
    });

    const user2 = await prisma.user.create({
        data: {
            id: 'user-002', email: 'student@college.edu', password: await bcrypt.hash('password123', 12),
            name: 'Student User', phone: '+91 87654 32109',
            college: 'VIT University', branch: 'ECE', walletBalance: 500, emailVerified: true,
        },
    });

    // ─── 6. ORDERS ──────────────────────────────────────────────────
    console.log('📦 Creating orders...');
    const allServices = await prisma.service.findMany();
    if (allServices.length >= 3) {
        await prisma.order.create({
            data: {
                orderNumber: 'PG-2026-0001', status: 'Completed', totalPrice: 4999,
                userId: 'user-001', serviceId: allServices[0].id, vendorId: 'vendor-001',
                notes: 'Excellent project delivered on time',
            },
        });
        await prisma.order.create({
            data: {
                orderNumber: 'PG-2026-0002', status: 'Active', totalPrice: 5500,
                userId: 'user-001', serviceId: allServices[1].id, vendorId: 'vendor-002',
            },
        });
        await prisma.order.create({
            data: {
                orderNumber: 'PG-2026-0003', status: 'Pending', totalPrice: 2999,
                userId: 'user-002', serviceId: allServices[2].id, vendorId: 'vendor-003',
            },
        });
    }

    // ─── 7. CUSTOM ORDERS ───────────────────────────────────────────
    console.log('🚀 Creating custom orders...');
    await prisma.customOrder.create({
        data: {
            title: 'Crop Disease Detection Using Transfer Learning',
            studentName: 'Vardhan Kumar', collegeName: 'JNTU Hyderabad',
            branch: 'CSE', semester: '7th', domain: 'AI/ML',
            abstractText: 'This project aims to detect crop diseases using transfer learning with EfficientNet B3 on a curated dataset of 10,000+ images across 25 crop types.',
            requirements: 'Need Flask backend, React frontend, and mobile app with camera integration',
            budget: '8000', deadline: '15 Mar 2026',
            contactEmail: 'vardhan@university.edu', contactPhone: '+91 98765 43210',
            status: 'In Progress', userId: 'user-001', vendorId: 'vendor-001',
            quotedPrice: 7500,
        },
    });

    // ─── 8. BUNDLES ─────────────────────────────────────────────────
    console.log('📦 Creating bundles...');
    await prisma.bundle.createMany({
        data: [
            { title: 'Final Year Combo', subtitle: 'Major Project + Report + PPT', tag: 'BESTSELLER', price: 5999, originalPrice: 12000, color: 0x7C3AED },
            { title: 'Developer Pack', subtitle: '5 Mini Projects + Resume Guide', tag: 'POPULAR', price: 1999, originalPrice: 4500, color: 0x2563EB },
            { title: 'Internship Ready', subtitle: 'Python + DSA Course + 2 Projects', tag: 'NEW', price: 2499, originalPrice: 6000, color: 0xEC4899 },
        ],
    });

    // ─── 9. TRANSACTIONS ────────────────────────────────────────────
    console.log('💰 Creating transactions...');
    await prisma.transaction.createMany({
        data: [
            { type: 'credit', amount: 4999, description: 'Order PG-2026-0001 completed', status: 'completed', vendorId: 'vendor-001' },
            { type: 'credit', amount: 5500, description: 'Order PG-2026-0002 payment', status: 'completed', vendorId: 'vendor-002' },
            { type: 'withdrawal', amount: 3000, description: 'Bank withdrawal', status: 'completed', vendorId: 'vendor-001' },
            { type: 'credit', amount: 2999, description: 'Order PG-2026-0003 payment', status: 'pending', vendorId: 'vendor-003' },
        ],
    });

    // ─── 10. REVIEWS ────────────────────────────────────────────────
    console.log('⭐ Creating reviews...');
    if (allServices.length >= 2) {
        await prisma.review.createMany({
            data: [
                { userName: 'Rahul Mehta', rating: 5, comment: 'Excellent project! Got full marks in my viva.', date: '2026-02-15', serviceId: allServices[0].id },
                { userName: 'Priyanka Sharma', rating: 5, comment: 'Amazing quality and instant delivery. Highly recommended.', date: '2026-02-10', serviceId: allServices[0].id },
                { userName: 'Arjun Patel', rating: 4, comment: 'Good project but needed some customization.', date: '2026-01-28', serviceId: allServices[1].id },
                { userName: 'Sneha Gupta', rating: 5, comment: 'Best e-commerce project on the platform!', date: '2026-02-01', serviceId: allServices[1].id },
            ],
        });
    }

    console.log('✅ Seed data created successfully!');
    console.log(`   📊 ${vendors.length} vendors`);
    console.log(`   📁 ${cats.length} categories`);
    console.log(`   🛒 ${servicesData.length} services`);
    console.log(`   📂 ${projectsData.length} projects`);
    console.log(`   👤 2 users`);
}

main()
    .catch((e) => {
        console.error('❌ Seed error:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
