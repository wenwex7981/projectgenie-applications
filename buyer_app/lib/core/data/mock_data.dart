import 'package:flutter/material.dart';
import '../models/models.dart';

// ─── Domain Filters (for Final Year Projects) ──────────────────────

class AppDomains {
  static const List<DomainFilter> all = [
    DomainFilter(id: 'all', name: 'All Domains', shortName: 'All', projectCount: 120),
    DomainFilter(id: 'aiml', name: 'AI & Machine Learning', shortName: 'AI/ML', projectCount: 35),
    DomainFilter(id: 'cse', name: 'Computer Science', shortName: 'CSE', projectCount: 45),
    DomainFilter(id: 'iot', name: 'Internet of Things', shortName: 'IoT', projectCount: 18),
    DomainFilter(id: 'ds', name: 'Data Science', shortName: 'Data Sci', projectCount: 28),
    DomainFilter(id: 'eee', name: 'Electrical Engineering', shortName: 'EEE', projectCount: 12),
    DomainFilter(id: 'ece', name: 'Electronics & Comm.', shortName: 'ECE', projectCount: 15),
    DomainFilter(id: 'cyber', name: 'Cyber Security', shortName: 'Cyber', projectCount: 10),
    DomainFilter(id: 'mech', name: 'Mechanical / Robotics', shortName: 'Mech', projectCount: 8),
    DomainFilter(id: 'blockchain', name: 'Blockchain', shortName: 'Web3', projectCount: 6),
  ];
}

// ─── Main Category Items ───────────────────────────────────────────

class AppCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final int count;

  const AppCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.count,
  });
}

class AppCategories {
  static const List<AppCategory> main = [
    AppCategory(
      id: 'final_year',
      title: 'Final Year Projects',
      subtitle: 'B.Tech / M.Tech / MCA ready',
      icon: Icons.school_rounded,
      color: Color(0xFFF59E0B),
      bgColor: Color(0xFFFEF3C7),
      count: 120,
    ),
    AppCategory(
      id: 'resume',
      title: 'Resume Templates',
      subtitle: 'ATS-optimized templates',
      icon: Icons.description_rounded,
      color: Color(0xFF059669),
      bgColor: Color(0xFFD1FAE5),
      count: 85,
    ),
    AppCategory(
      id: 'projects',
      title: 'Mini & Major Projects',
      subtitle: 'Ready to deploy solutions',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF1A56DB),
      bgColor: Color(0xFFDBEAFE),
      count: 250,
    ),
    AppCategory(
      id: 'resume_writing',
      title: 'Resume Writing Service',
      subtitle: 'Professional writers on demand',
      icon: Icons.edit_document,
      color: Color(0xFF7C3AED),
      bgColor: Color(0xFFEDE9FE),
      count: 45,
    ),
    AppCategory(
      id: 'research_paper',
      title: 'Research Paper Writing',
      subtitle: 'IEEE / Springer / Scopus',
      icon: Icons.science_rounded,
      color: Color(0xFFDC2626),
      bgColor: Color(0xFFFEE2E2),
      count: 60,
    ),
  ];
}

// ─── Mock Data Class ───────────────────────────────────────────────

class MockData {
  // ─── Hero Banners ────────────────────────────────────────────────
  static final List<Map<String, String>> banners = [
    {
      'title': 'Final Year Project Sale',
      'subtitle': 'Flat 40% OFF on all BTech Major Projects',
      'tag': '🔥 LIMITED',
      'gradient_start': '0xFF1A56DB',
      'gradient_end': '0xFF7C3AED',
    },
    {
      'title': 'Professional Resumes',
      'subtitle': 'Get your ATS-ready resume in 24 hours',
      'tag': '✨ NEW',
      'gradient_start': '0xFF059669',
      'gradient_end': '0xFF0284C7',
    },
    {
      'title': 'Research Publication',
      'subtitle': 'Get published in IEEE / Springer / Scopus',
      'tag': '📚 TRENDING',
      'gradient_start': '0xFFDC2626',
      'gradient_end': '0xFFF59E0B',
    },
    {
      'title': 'Expert Mentorship',
      'subtitle': '1-on-1 guidance from industry professionals',
      'tag': '⭐ PREMIUM',
      'gradient_start': '0xFF7C3AED',
      'gradient_end': '0xFFEC4899',
    },
  ];

  // ─── Platform Stats ──────────────────────────────────────────────
  static const Map<String, String> stats = {
    'students': '25K+',
    'projects': '500+',
    'mentors': '120+',
    'rating': '4.9',
  };

  // ─── Final Year Projects ─────────────────────────────────────────
  static final List<ProjectModel> finalYearProjects = [
    // AI/ML
    ProjectModel(
      id: 'fyp-1', title: 'AI-Powered Plant Disease Detection System',
      domain: 'AI/ML', branch: 'Computer Science',
      price: '₹4,999', originalPrice: '₹7,999',
      description: 'Deep learning CNN model to identify 38+ plant diseases from leaf images. Features mobile-friendly UI, real-time camera inference, and detailed treatment recommendations using transfer learning with EfficientNet.',
      imageUrl: 'https://images.unsplash.com/photo-1625246333195-09d9d8855404?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'TensorFlow', 'Flask', 'React Native'],
      rating: 4.9, reviewCount: 324, enrollees: 1250,
      difficulty: 'Advanced', isFeatured: true,
    ),
    ProjectModel(
      id: 'fyp-2', title: 'Real-time Traffic Violation Detection using YOLOv8',
      domain: 'AI/ML', branch: 'Artificial Intelligence',
      price: '₹5,999', originalPrice: '₹9,999',
      description: 'Automated traffic monitoring system detecting helmet violations, speed breaches, and signal jumps in real-time video feeds using state-of-the-art YOLOv8 object detection.',
      imageUrl: 'https://images.unsplash.com/photo-1565514020126-db26b2b73c4d?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'YOLOv8', 'OpenCV', 'PyTorch'],
      rating: 4.8, reviewCount: 198, enrollees: 890,
      difficulty: 'Advanced', isFeatured: true,
    ),
    ProjectModel(
      id: 'fyp-3', title: 'Fake News Detection System using NLP',
      domain: 'AI/ML', branch: 'Computer Science',
      price: '₹3,799', originalPrice: '₹5,999',
      description: 'LSTM-based deep learning model to classify news articles as real or fake. Includes web scraping, text preprocessing, and a sleek dashboard for real-time analysis.',
      imageUrl: 'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'NLTK', 'Keras', 'Streamlit'],
      rating: 4.6, reviewCount: 156, enrollees: 670,
      difficulty: 'Intermediate',
    ),
    ProjectModel(
      id: 'fyp-4', title: 'Emotion Recognition from Speech using Deep Learning',
      domain: 'AI/ML', branch: 'AI & Data Science',
      price: '₹4,499',
      description: 'CNN + LSTM hybrid model for recognizing emotions from speech audio. Uses MFCC feature extraction and trained on RAVDESS dataset with 92% accuracy.',
      imageUrl: 'https://images.unsplash.com/photo-1589254065878-42c9da997008?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'Librosa', 'TensorFlow', 'Flask'],
      rating: 4.7, reviewCount: 89, enrollees: 340,
      difficulty: 'Advanced',
    ),

    // CSE
    ProjectModel(
      id: 'fyp-5', title: 'Full-Stack E-Learning Platform with AI Tutor',
      domain: 'CSE', branch: 'Computer Science',
      price: '₹4,499', originalPrice: '₹6,999',
      description: 'Comprehensive LMS with course management, progress tracking, AI-powered doubt solver, interactive quizzes, payment gateway, and video streaming built with MERN stack.',
      imageUrl: 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?auto=format&fit=crop&q=80&w=800',
      techStack: ['MongoDB', 'Express', 'React', 'Node.js'],
      rating: 4.8, reviewCount: 445, enrollees: 2100,
      difficulty: 'Intermediate', isFeatured: true,
    ),
    ProjectModel(
      id: 'fyp-6', title: 'Decentralized E-Voting on Ethereum',
      domain: 'CSE', branch: 'Computer Science',
      price: '₹5,499',
      description: 'Secure, transparent, immutable voting system on Ethereum blockchain. Features smart contracts, voter verification, and React frontend with MetaMask integration.',
      imageUrl: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&q=80&w=800',
      techStack: ['Solidity', 'React', 'Node.js', 'Web3.js'],
      rating: 4.9, reviewCount: 267, enrollees: 980,
      difficulty: 'Advanced',
    ),
    ProjectModel(
      id: 'fyp-7', title: 'Hospital Management System with Appointment Booking',
      domain: 'CSE', branch: 'Computer Science',
      price: '₹3,999',
      description: 'Complete HMS with patient records, doctor scheduling, appointment booking, billing, pharmacy management, and role-based access control.',
      imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=800',
      techStack: ['Java', 'Spring Boot', 'MySQL', 'Angular'],
      rating: 4.5, reviewCount: 189, enrollees: 750,
      difficulty: 'Intermediate',
    ),

    // IoT
    ProjectModel(
      id: 'fyp-8', title: 'Smart Helmet for Mine Workers',
      domain: 'IoT', branch: 'Electronics & Communication',
      price: '₹5,499', originalPrice: '₹8,499',
      description: 'Intelligent safety system monitoring toxic gases, humidity, temperature with SOS button, fall detection using accelerometer, and GPS tracking with cloud dashboard.',
      imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&q=80&w=800',
      techStack: ['Arduino', 'Raspberry Pi', 'Firebase', 'React'],
      rating: 4.7, reviewCount: 134, enrollees: 520,
      difficulty: 'Advanced', isFeatured: true,
    ),
    ProjectModel(
      id: 'fyp-9', title: 'Smart Agriculture Monitoring System',
      domain: 'IoT', branch: 'ECE',
      price: '₹4,999',
      description: 'IoT-based crop monitoring with soil moisture, temperature, humidity sensors. Automated irrigation with mobile app control and weather prediction integration.',
      imageUrl: 'https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&q=80&w=800',
      techStack: ['ESP32', 'MQTT', 'Node.js', 'React Native'],
      rating: 4.6, reviewCount: 98, enrollees: 380,
      difficulty: 'Intermediate',
    ),
    ProjectModel(
      id: 'fyp-10', title: 'Home Automation with Voice Control',
      domain: 'IoT', branch: 'EEE',
      price: '₹3,499',
      description: 'Smart home system with voice-controlled appliances, motion detection, energy monitoring dashboard, and integration with Google Assistant & Alexa.',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?auto=format&fit=crop&q=80&w=800',
      techStack: ['Arduino', 'ESP8266', 'Firebase', 'Flutter'],
      rating: 4.4, reviewCount: 76, enrollees: 290,
      difficulty: 'Beginner',
    ),

    // Data Science
    ProjectModel(
      id: 'fyp-11', title: 'Customer Churn Prediction with Explainable AI',
      domain: 'Data Science', branch: 'AI & Data Science',
      price: '₹3,999',
      description: 'End-to-end ML pipeline for predicting customer churn with SHAP explanations, feature importance visualization, and interactive Streamlit dashboard.',
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bbbda536339a?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'Scikit-learn', 'SHAP', 'Streamlit'],
      rating: 4.7, reviewCount: 145, enrollees: 560,
      difficulty: 'Intermediate',
    ),
    ProjectModel(
      id: 'fyp-12', title: 'Stock Price Prediction using LSTM',
      domain: 'Data Science', branch: 'Computer Science',
      price: '₹4,499',
      description: 'Deep learning time-series forecasting with LSTM for stock price prediction. Features technical indicator analysis, backtesting, and real-time market data integration.',
      imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'TensorFlow', 'yfinance', 'Plotly'],
      rating: 4.5, reviewCount: 210, enrollees: 890,
      difficulty: 'Advanced',
    ),

    // EEE
    ProjectModel(
      id: 'fyp-13', title: 'Solar Power Monitoring & Management System',
      domain: 'EEE', branch: 'Electrical Engineering',
      price: '₹4,999',
      description: 'IoT-enabled solar panel monitoring with real-time power generation tracking, fault detection, MPPT optimization, and cloud-based analytics dashboard.',
      imageUrl: 'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&q=80&w=800',
      techStack: ['Arduino', 'LoRa', 'Python', 'Grafana'],
      rating: 4.6, reviewCount: 67, enrollees: 230,
      difficulty: 'Advanced',
    ),
    ProjectModel(
      id: 'fyp-14', title: 'Smart Energy Meter with Theft Detection',
      domain: 'EEE', branch: 'Electrical Engineering',
      price: '₹3,999',
      description: 'Digital energy meter with tamper detection, real-time consumption monitoring, billing automation, and SMS/app alerts for abnormal usage patterns.',
      imageUrl: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&q=80&w=800',
      techStack: ['Arduino', 'GSM Module', 'Firebase', 'Android'],
      rating: 4.3, reviewCount: 45, enrollees: 180,
      difficulty: 'Intermediate',
    ),

    // ECE
    ProjectModel(
      id: 'fyp-15', title: 'FPGA-based Image Processing System',
      domain: 'ECE', branch: 'Electronics & Communication',
      price: '₹6,999',
      description: 'Hardware-accelerated image processing on FPGA with edge detection, noise filtering, and histogram equalization. Includes Verilog/VHDL source and testbenches.',
      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=800',
      techStack: ['Verilog', 'VHDL', 'MATLAB', 'Xilinx Vivado'],
      rating: 4.8, reviewCount: 56, enrollees: 190,
      difficulty: 'Advanced',
    ),
    ProjectModel(
      id: 'fyp-16', title: 'Wireless Health Monitoring Band',
      domain: 'ECE', branch: 'Electronics & Communication',
      price: '₹5,499',
      description: 'Wearable health band measuring heart rate, SpO2, body temperature with BLE connectivity, mobile app integration, and emergency alert system.',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=800',
      techStack: ['ARM Cortex', 'BLE', 'Flutter', 'Firebase'],
      rating: 4.7, reviewCount: 89, enrollees: 340,
      difficulty: 'Advanced',
    ),

    // Cyber Security
    ProjectModel(
      id: 'fyp-17', title: 'Network Intrusion Detection using ML',
      domain: 'Cyber Security', branch: 'Computer Science',
      price: '₹4,999',
      description: 'Machine learning-based NIDS using Random Forest & XGBoost trained on NSL-KDD dataset. Features real-time packet analysis and threat visualization dashboard.',
      imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800',
      techStack: ['Python', 'Scapy', 'Scikit-learn', 'Flask'],
      rating: 4.6, reviewCount: 123, enrollees: 450,
      difficulty: 'Advanced',
    ),
  ];

  // ─── Resume Templates ────────────────────────────────────────────
  static final List<ServiceModel> resumeTemplates = [
    ServiceModel(
      id: 'rt-1', title: 'ATS-Optimized Tech Resume',
      description: 'Professionally designed LaTeX resume template optimized for ATS systems. Used by 10,000+ engineers at FAANG companies.',
      vendorName: 'CareerPro Templates', category: 'Resume',
      price: '499', rating: 4.9, reviewCount: 2340, deliveryDays: 'Instant',
      imageUrl: 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=800',
    ),
    ServiceModel(
      id: 'rt-2', title: 'Creative Designer Resume Pack',
      description: '5 stunning resume + cover letter templates for UI/UX designers. Figma & PDF versions included.',
      vendorName: 'DesignStudio Pro', category: 'Resume',
      price: '699', rating: 4.8, reviewCount: 1560, deliveryDays: 'Instant',
    ),
    ServiceModel(
      id: 'rt-3', title: 'MBA & Management Resume Bundle',
      description: 'Executive-level resume templates tailored for MBA graduates and management roles. Word & PDF formats.',
      vendorName: 'ExecutiveEdge', category: 'Resume',
      price: '599', rating: 4.7, reviewCount: 890, deliveryDays: 'Instant',
    ),
    ServiceModel(
      id: 'rt-4', title: 'Fresher\'s Resume Starter Kit',
      description: 'Perfect for college students and fresh graduates. Includes 3 templates, cover letter, and filling guide.',
      vendorName: 'FirstStep Careers', category: 'Resume',
      price: '299', rating: 4.6, reviewCount: 3200, deliveryDays: 'Instant',
    ),
  ];

  // ─── Resume Writing Services ─────────────────────────────────────
  static final List<ServiceModel> resumeWritingServices = [
    ServiceModel(
      id: 'rw-1', title: 'Professional Resume Writing',
      description: 'Expert writers craft your ATS-friendly resume with keyword optimization for your target role. Includes 2 revisions.',
      vendorName: 'ResumeGenie Pro', category: 'Resume Writing',
      price: '1,999', rating: 4.9, reviewCount: 1890, deliveryDays: '3',
      features: ['ATS Optimized', '2 Revisions', 'Cover Letter', 'LinkedIn Summary'],
    ),
    ServiceModel(
      id: 'rw-2', title: 'Executive Resume Overhaul',
      description: 'Complete resume transformation by senior HR consultants from Fortune 500 companies. Unlimited revisions for 30 days.',
      vendorName: 'LeadCraft Resumes', category: 'Resume Writing',
      price: '3,999', rating: 4.8, reviewCount: 670, deliveryDays: '5',
      features: ['Expert Writer', 'Unlimited Revisions', 'LinkedIn Optimization', 'Interview Tips'],
    ),
    ServiceModel(
      id: 'rw-3', title: 'Fresher Resume + LinkedIn Package',
      description: 'Tailored for fresh graduates. We build your resume and optimize LinkedIn from scratch. Stand out from 10,000+ applicants.',
      vendorName: 'FirstJob Academy', category: 'Resume Writing',
      price: '999', rating: 4.7, reviewCount: 2340, deliveryDays: '2',
      features: ['ATS Friendly', '1 Revision', 'LinkedIn Profile', 'Job Portal Setup'],
    ),
    ServiceModel(
      id: 'rw-4', title: 'Tech Resume for FAANG',
      description: 'Specialized resume writing for software engineers targeting FAANG. Written by ex-Google recruiters.',
      vendorName: 'TechCareer Lab', category: 'Resume Writing',
      price: '2,999', rating: 4.9, reviewCount: 560, deliveryDays: '4',
      features: ['FAANG Optimized', 'ATS Score 95+', '3 Revisions', 'Mock Interview Prep'],
    ),
  ];

  // ─── Research Paper Writing Services ─────────────────────────────
  static final List<ServiceModel> researchPaperServices = [
    ServiceModel(
      id: 'rp-1', title: 'IEEE Paper Writing & Publication',
      description: 'End-to-end IEEE conference paper writing with topic selection, literature survey, methodology, and journal submission assistance.',
      vendorName: 'AcademiaPro Research', category: 'Research Paper',
      price: '7,999', rating: 4.8, reviewCount: 780, deliveryDays: '15',
      features: ['Topic Selection', 'Plagiarism Free', 'Journal Submission', 'Revision Support'],
    ),
    ServiceModel(
      id: 'rp-2', title: 'Springer / Scopus Paper Writing',
      description: 'Q1/Q2 ranked journal paper writing with complete research methodology, data analysis, and peer review preparation.',
      vendorName: 'ResearchHub Elite', category: 'Research Paper',
      price: '12,999', rating: 4.9, reviewCount: 340, deliveryDays: '21',
      features: ['Q1/Q2 Journals', 'Statistical Analysis', 'Peer Review Ready', 'Publication Guarantee'],
    ),
    ServiceModel(
      id: 'rp-3', title: 'Literature Review & Survey Paper',
      description: 'Comprehensive systematic literature review with 50+ paper analysis, gap identification, and future scope documentation.',
      vendorName: 'ScholarWrite', category: 'Research Paper',
      price: '4,999', rating: 4.7, reviewCount: 560, deliveryDays: '10',
      features: ['50+ Papers Analyzed', 'Gap Analysis', 'Citation Management', 'Turnitin Report'],
    ),
    ServiceModel(
      id: 'rp-4', title: 'Conference Paper Express',
      description: 'Quick turnaround conference paper for upcoming deadlines. Includes abstract, methodology, results, and camera-ready format.',
      vendorName: 'QuickPublish', category: 'Research Paper',
      price: '5,999', rating: 4.6, reviewCount: 890, deliveryDays: '7',
      features: ['Fast Delivery', 'Camera Ready', 'Plagiarism Check', 'Presentation PPT'],
    ),
  ];

  // ─── General Projects (Mini & Major) ─────────────────────────────
  static final List<ServiceModel> generalProjects = [
    ServiceModel(
      id: 'gp-1', title: 'Python Automation Scripts Bundle',
      description: '20+ production-ready automation scripts for web scraping, email, file management, and API integration.',
      vendorName: 'CodeCraft Studio', category: 'Projects',
      price: '499', rating: 4.5, reviewCount: 1200, deliveryDays: 'Instant',
    ),
    ServiceModel(
      id: 'gp-2', title: 'React Admin Dashboard Template',
      description: 'Premium admin panel with 50+ components, dark mode, charts, tables, and authentication. TypeScript ready.',
      vendorName: 'UIStack Pro', category: 'Projects',
      price: '1,499', rating: 4.8, reviewCount: 890, deliveryDays: 'Instant',
    ),
    ServiceModel(
      id: 'gp-3', title: 'Flutter E-Commerce Full App',
      description: 'Complete e-commerce app with product catalog, cart, checkout, payment gateway, admin panel, and push notifications.',
      vendorName: 'AppForge Labs', category: 'Projects',
      price: '2,999', rating: 4.7, reviewCount: 650, deliveryDays: '2',
    ),
    ServiceModel(
      id: 'gp-4', title: 'MERN Stack Social Media App',
      description: 'Full-featured social media platform with posts, likes, comments, real-time chat, stories, and notifications.',
      vendorName: 'FullStack Hub', category: 'Projects',
      price: '3,499', rating: 4.6, reviewCount: 430, deliveryDays: '3',
    ),
  ];

  // ─── Trending Services (for Home) ────────────────────────────────
  static final List<ServiceModel> trendingServices = [
    ServiceModel(
      id: 'ts-1', title: 'Custom Deep Learning Model',
      description: 'We build custom AI models tailored to your dataset and research requirements.',
      vendorName: 'Data Wizards', category: 'AI/ML',
      price: '5,999', rating: 4.8, reviewCount: 320, deliveryDays: '14',
      imageUrl: 'https://images.unsplash.com/photo-1555942807-7393d6da61b0?auto=format&fit=crop&q=80&w=800',
    ),
    ServiceModel(
      id: 'ts-2', title: 'Project Report + PPT + Viva Guide',
      description: 'Complete final year documentation bundle with IEEE format report, presentation, and viva preparation.',
      vendorName: 'DocuPro', category: 'Documentation',
      price: '1,999', rating: 4.9, reviewCount: 2100, deliveryDays: '5',
      imageUrl: 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=800',
    ),
    ServiceModel(
      id: 'ts-3', title: '1-on-1 Project Mentorship',
      description: 'Get personal guidance from industry experts for your project development journey.',
      vendorName: 'MentorConnect', category: 'Mentorship',
      price: '2,499', rating: 4.9, reviewCount: 450, deliveryDays: 'Flexible',
      imageUrl: 'https://images.unsplash.com/photo-1522071823991-b1ae5e6a3048?auto=format&fit=crop&q=80&w=800',
    ),
  ];

  // ─── Orders ──────────────────────────────────────────────────────
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ORD-12345',
      serviceName: 'AI Plant Disease Detection',
      vendorName: 'Genie Experts',
      price: '4999',
      status: 'Active',
      date: '12 Feb 2026',
    ),
    OrderModel(
      id: 'ORD-12346',
      serviceName: 'Resume Transformation',
      vendorName: 'CareerPro',
      price: '1999',
      status: 'Completed',
      date: '05 Feb 2026',
    ),
  ];

  // ─── Chat Threads ────────────────────────────────────────────────
  static final List<ChatThread> chatThreads = [
    ChatThread(id: 'c1', vendorName: 'Genie Experts', lastMessage: 'Your project files are ready!', time: '10:30 AM', unreadCount: 2, isOnline: true),
    ChatThread(id: 'c2', vendorName: 'Data Wizards', lastMessage: 'Model training completed.', time: 'Yesterday', isOnline: false),
    ChatThread(id: 'c3', vendorName: 'ResumeGenie Pro', lastMessage: 'Please check the updated draft', time: '2 days ago', unreadCount: 1, isOnline: true),
  ];

  static final List<ChatMessage> chatMessages = [
    ChatMessage(id: 'm1', text: 'Hi, I need help with my project.', time: '10:00 AM', isSender: true),
    ChatMessage(id: 'm2', text: 'Sure, I can help with that! What domain are you working on?', time: '10:05 AM', isSender: false),
    ChatMessage(id: 'm3', text: 'AI/ML — Plant disease detection', time: '10:06 AM', isSender: true),
  ];

  // ─── Transactions ────────────────────────────────────────────────
  static final List<Map<String, dynamic>> transactions = [
    {'title': 'Order #12345', 'date': 'Today, 2:45 PM', 'amount': '-₹4,999', 'type': 'Paid', 'icon': Icons.shopping_bag_outlined, 'statusColor': const Color(0xFF64748B)},
    {'title': 'Wallet Top-up', 'date': 'Today, 10:15 AM', 'amount': '+₹10,000', 'type': 'Credit', 'icon': Icons.account_balance_wallet_outlined, 'isCredit': true, 'statusColor': const Color(0xFF10B981)},
    {'title': 'Resume Writing', 'date': 'Yesterday', 'amount': '-₹1,999', 'type': 'Paid', 'icon': Icons.edit_document, 'statusColor': const Color(0xFF64748B)},
  ];
}
