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
        prisma.category.create({ data: { id: 'cat-research', title: 'Research Paper', icon: 'science', count: 180, sortOrder: 13 } }),
    ]);

    // ─── 3. SERVICES ────────────────────────────────────────────────
    console.log('🛒 Creating services...');
    const servicesData = [
        {
            title: 'Enterprise AI Cancer Diagnostics Core',
            description: 'A production-grade computer vision pipeline designed for histopathological analysis. Built on highly scalable microservices running PyTorch models in Kubernetes pods. Complete IEEE documentation included.',
            vendorName: 'AI Research Lab', price: 4999, originalPrice: 8000,
            rating: 4.9, reviewCount: 128, deliveryDays: 'Instant',
            isFeatured: true, isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800', // Cyberspace AI abstract
            categoryId: 'cat-cnn', vendorId: 'vendor-001',
            features: JSON.stringify(['98.5% Accuracy Threshold', 'Dockerized Core', 'IEEE IEEE-754 Precision', 'K8s Config Maps', 'Deployment Ready']),
        },
        {
            title: 'Scalable B2B Commerce Architecture',
            description: 'Fully architected hyper-scalable e-commerce backend built with NestJS, PostgreSQL, React (Next.js) for SSR, and Stripe Webhooks. Perfect for SaaS multitenancy setups.',
            vendorName: 'CodeMasters', price: 5500, originalPrice: 12000,
            rating: 4.8, reviewCount: 340, deliveryDays: '2 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800', // Dashboard graph code
            categoryId: 'cat-web', vendorId: 'vendor-002',
            features: JSON.stringify(['Multitenant DB', 'Next.js Frontend', 'Stripe Billing Logic', 'Redis Caching', 'End-to-end Cypress']),
        },
        {
            title: 'NLP Enterprise Semantic Bot',
            description: 'Advanced Natural Language semantic search and support agent utilizing transformer architectures and vector databases for zero-shot RAG retrieval.',
            vendorName: 'PyWizards', price: 2999, originalPrice: 4500,
            rating: 4.7, reviewCount: 215, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800', // Tech matrix glowing
            categoryId: 'cat-ml', vendorId: 'vendor-003',
            features: JSON.stringify(['Pinecone Vector DB', 'LangChain Integration', 'Contextual Memory', 'OpenAPI Specs']),
        },
        {
            title: 'Fleet Drowsiness Telemetry System',
            description: 'Industrial-grade Python edge CV solution optimized for Jetson Nano arrays deployed in logistics fleets. Computes Eye Aspect Ratios locally with cloud analytics pushing.',
            vendorName: 'Visionary Tech', price: 3200, originalPrice: 5000,
            rating: 4.6, reviewCount: 189, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1620712948343-0008cc890662?w=800', // Futuristic network
            categoryId: 'cat-cnn', vendorId: 'vendor-004',
            features: JSON.stringify(['Edge Inference', 'Telemetry Dashboard', 'Real-time WebSocket alerts', 'GCP IOT Core']),
        },
        {
            title: 'Algorithmic Trading LSTM Suite',
            description: 'Deep Learning quantitative trading suite predicting time series momentum utilizing bidirectional GRU and LSTM neural networks. Real-time Bloomberg/Yahoo Finance data ingestion scripts.',
            vendorName: 'AI Research Lab', price: 3500, originalPrice: 6000,
            rating: 4.6, reviewCount: 112, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800', // Stock crypto charts
            categoryId: 'cat-dl', vendorId: 'vendor-001',
            features: JSON.stringify(['TensorFlow 2.x', 'Alpaca API hooks', 'Backtesting Suite', 'Metrics Viz']),
        },
        {
            title: 'White-Label Logistics App Ecosystem',
            description: 'Cross-platform SaaS logistics fleet product. Rider App, Driver App, and Admin React dashboard. Includes highly optimized Maps SDK routing architectures.',
            vendorName: 'Mobile Experts', price: 8000, originalPrice: 15000,
            rating: 4.7, reviewCount: 95, deliveryDays: '5 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1614332287897-cdc485fa562d?w=800', // Modern Abstract dark mode
            categoryId: 'cat-app', vendorId: 'vendor-005',
            features: JSON.stringify(['Flutter Clean Arch', 'Socket.io Maps Sync', 'JWT Auth + Roles', 'Admin Control Panel']),
        },
        {
            title: 'NextGen Campus ERP System',
            description: 'Monolithic Spring Boot & PostgreSQL academic ERP with module segregation for billing, student management, faculty, and real-time attendance tracking.',
            vendorName: 'CodeMasters', price: 499, rating: 4.2, reviewCount: 56,
            deliveryDays: 'Instant',
            imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800', // Modern workstation
            categoryId: 'cat-mini', vendorId: 'vendor-002',
            features: JSON.stringify(['Spring Boot 3', 'Swagger Docs', 'JWT Spring Security']),
        },
        {
            title: 'Hybrid Weather Forecasting Architecture',
            description: 'Showcasing React Native modern cross-platform patterns combined with Redux Toolkit and advanced REST API caching for zero-latency weather UI.',
            vendorName: 'Mobile Experts', price: 699, rating: 4.5, reviewCount: 88,
            deliveryDays: 'Instant',
            imageUrl: 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800', // Dark moody nature/stars
            categoryId: 'cat-mini', vendorId: 'vendor-005',
            features: JSON.stringify(['Redux RTK Query', 'Beautiful UI/UX', 'Geolocation Service']),
        },
        {
            title: 'Omni-Channel IoT Automation',
            description: 'Enterprise REST APIs connected via MQTT brokers back to ESP32 node clusters. Remote telemetry commands executed in sub-10ms via cloud AWS IoT infra.',
            vendorName: 'Visionary Tech', price: 4500, originalPrice: 7000,
            rating: 4.5, reviewCount: 67, deliveryDays: '3 Days',
            isFeatured: true,
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800', // Digital circuits/server room
            categoryId: 'cat-iot', vendorId: 'vendor-004',
            features: JSON.stringify(['AWS IoT Configs', 'C++ Edge firmware', 'Webhooks integration', 'React Dashboard']),
        },
        {
            title: 'Silicon Valley Executive ATS Resume Kit',
            description: 'A data-driven typography engineered pack of LaTeX and highly customized Word documents designed specifically to bypass modern tech ATS algorithms.',
            vendorName: 'CodeMasters', price: 299, originalPrice: 999,
            rating: 4.8, reviewCount: 520, deliveryDays: 'Instant',
            isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=800', // Professional document layout
            categoryId: 'cat-resume', vendorId: 'vendor-002',
            features: JSON.stringify(['LaTeX Scripts', 'ATS-Scored', 'Figma Files', 'Cover Letter templates']),
        },
        {
            title: 'IEEE Premium Research Paper Writing & Publishing',
            description: 'Get your IEEE/Springer paper written and published by our PhD experts. We handle the entire lifecycle from topic selection to literature review, drafting, formatting, and submission negotiations.',
            vendorName: 'AI Research Lab', price: 14999, originalPrice: 25000,
            rating: 4.9, reviewCount: 42, deliveryDays: '14 Days',
            isFeatured: true, isTrending: true,
            imageUrl: 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=800',
            categoryId: 'cat-research', vendorId: 'vendor-001',
            features: JSON.stringify(['IEEE Format', 'Zero Plagiarism', 'Guaranteed Publication', 'Dataset Included']),
        },
        {
            title: 'Professional Resume Writing & LinkedIn Optimization',
            description: 'Get a professional, ATS-friendly resume tailored to the exact role you are applying to. Our Fortune 500 recruiters will also revitalize your LinkedIn profile for inbound leads.',
            vendorName: 'CodeMasters', price: 999, originalPrice: 2500,
            rating: 4.8, reviewCount: 305, deliveryDays: '3 Days',
            isFeatured: true, isTrending: false,
            imageUrl: 'https://images.unsplash.com/photo-1586281380117-5a60ae2050cc?w=800',
            categoryId: 'cat-resume', vendorId: 'vendor-002',
            features: JSON.stringify(['ATS Optimization', 'LinkedIn Guide', '1-on-1 Strategy session', 'Unlimited Revisions']),
        },
    ];

    for (const s of servicesData) {
        await prisma.service.create({ data: s });
    }

    // ─── 4. PROJECTS ────────────────────────────────────────────────
    console.log('📂 Creating projects...');
    const projectsData = [
        {
            title: 'SaaS Vision Disease Classification Net',
            domain: 'AI/ML', branch: 'Computer Science',
            price: '₹4,999', originalPrice: '₹7,999',
            description: 'Production-ready Deep Learning API serving an EfficientNet B4 model for advanced crop disease heuristics. Complete with stateless REST architecture.',
            imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800', // Server LED lights
            techStack: JSON.stringify(['Python', 'PyTorch', 'FastAPI', 'React Native Core']),
            rating: 4.9, reviewCount: 324, enrollees: 1250,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-001', categoryId: 'cat-ml',
        },
        {
            title: 'Cloud-Native Distributed Traffic Optimizer',
            domain: 'IoT', branch: 'Electronics & Communication',
            price: '₹5,499', originalPrice: '₹8,999',
            description: 'Microservice-based traffic telemetry pipeline using Redis PubSub. Pushes real-time signal calculations driven by distributed edge nodes.',
            imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800', // Earth data networks globe
            techStack: JSON.stringify(['Python', 'Docker Swarm', 'Redis PubSub', 'TensorFlow Lite']),
            rating: 4.7, reviewCount: 198, enrollees: 890,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-004', categoryId: 'cat-iot',
        },
        {
            title: 'Web3 DAO Voting Smart Contract',
            domain: 'Blockchain', branch: 'Computer Science',
            price: '₹6,999', originalPrice: '₹11,999',
            description: 'An immutable organizational voting vault coded in Solidity with Gas optimizations. Next.js dApp frontend leveraging Ethers.js and Metamask signature verification.',
            imageUrl: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800', // Blockchain glowing network
            techStack: JSON.stringify(['Solidity 0.8', 'Ethers.js v6', 'Next.js App Router', 'Hardhat']),
            rating: 4.8, reviewCount: 156, enrollees: 720,
            difficulty: 'Advanced', isFeatured: true,
            vendorId: 'vendor-002', categoryId: 'cat-blockchain',
        },
        {
            title: 'Biometric Access Control Gateway',
            domain: 'Computer Science', branch: 'Computer Science',
            price: '₹3,999', originalPrice: '₹5,999',
            description: 'Zero-latency face identification access terminal using highly accurate SVM classifiers and embeddings computed by Dlib. Features websocket active monitoring.',
            imageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=800', // Futuristic network pattern
            techStack: JSON.stringify(['Python', 'WSS', 'OpenCV', 'FastAPI']),
            rating: 4.6, reviewCount: 245, enrollees: 1500,
            difficulty: 'Intermediate', isFeatured: true,
            vendorId: 'vendor-004', categoryId: 'cat-cnn',
        },
        {
            title: 'Healthcare EHR Architecture (SaaS)',
            domain: 'Web Development', branch: 'Computer Science',
            price: '₹4,499', originalPrice: '₹7,499',
            description: 'Fully featured monolithic Next.js backend for Electronic Health Records handling highly sensitive JSON blobs, secure authentication layers, and React dashboards.',
            imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800', // Data dashboard
            techStack: JSON.stringify(['Prisma ORM', 'Next.js API', 'Tailwind', 'PostgreSQL']),
            rating: 4.5, reviewCount: 178, enrollees: 960,
            difficulty: 'Intermediate',
            vendorId: 'vendor-002', categoryId: 'cat-web',
        },
        {
            title: 'Social Analytics Data Pipeline (Hadoop)',
            domain: 'Data Science', branch: 'Computer Science',
            price: '₹2,999', originalPrice: '₹4,999',
            description: 'A data engineering masterpiece collecting streaming raw text data from APIs, performing ELT workflows into Pandas, and doing BERT sentiment analysis.',
            imageUrl: 'https://images.unsplash.com/photo-1504868584819-f8e8b4bffa41?w=800', // Dark server analytics graph
            techStack: JSON.stringify(['Python', 'HuggingFace', 'Pandas', 'Streamlit Apps']),
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
