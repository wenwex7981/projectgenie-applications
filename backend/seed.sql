
-- 🗑️ Clear existing data
DELETE FROM "OtpToken";
DELETE FROM "Notification";
DELETE FROM "Transaction";
DELETE FROM "ChatMessage";
DELETE FROM "CustomOrder";
DELETE FROM "Review";
DELETE FROM "Order";
DELETE FROM "Project";
DELETE FROM "Service";
DELETE FROM "Category";
DELETE FROM "Bundle";
DELETE FROM "User";
DELETE FROM "Vendor";

-- 🏪 Seed Vendors
INSERT INTO "Vendor" ("id", "email", "password", "name", "businessName", "phone", "profileImage", "bio", "rating", "totalEarnings", "totalOrders", "isVerified", "emailVerified", "status", "updatedAt") VALUES
('vendor-1', 'ailab@projectgenie.com', '$2b$12$0DxkPhCdrBlRbuaib1wdgOVElYUfGVkxkwAclnU4oCRdjv4JmOvbO', 'Dr. Alan Turing', 'AI Research Lab', '+91 98765 00001', 'https://ui-avatars.com/api/?name=Dr+Alan&background=0D8ABC&color=fff', 'Expert in Machine Learning and Computer Vision algorithms.', 4.9, 8500, 42, true, true, 'active', CURRENT_TIMESTAMP),
('vendor-2', 'codemasters@projectgenie.com', '$2b$12$0DxkPhCdrBlRbuaib1wdgOVElYUfGVkxkwAclnU4oCRdjv4JmOvbO', 'Sarah Connor', 'Code Masters Pro', '+91 98765 00002', 'https://ui-avatars.com/api/?name=Sarah+C&background=E53935&color=fff', 'Full-stack web development and scalable architectures.', 4.8, 6200, 31, true, true, 'active', CURRENT_TIMESTAMP),
('vendor-3', 'pywizards@projectgenie.com', '$2b$12$0DxkPhCdrBlRbuaib1wdgOVElYUfGVkxkwAclnU4oCRdjv4JmOvbO', 'Guido van Rossum', 'Python Wizards', '+91 98765 00003', 'https://ui-avatars.com/api/?name=Python+W&background=FFB300&color=fff', 'Python automation, data science, and backend APIs.', 4.7, 4100, 18, true, true, 'active', CURRENT_TIMESTAMP),
('vendor-4', 'visionary@projectgenie.com', '$2b$12$0DxkPhCdrBlRbuaib1wdgOVElYUfGVkxkwAclnU4oCRdjv4JmOvbO', 'Elon M.', 'Visionary Tech UI', '+91 98765 00004', 'https://ui-avatars.com/api/?name=Vision+UI&background=43A047&color=fff', 'UI/UX design, Figma prototypes, and frontend aesthetics.', 4.9, 9300, 56, true, true, 'active', CURRENT_TIMESTAMP),
('vendor-5', 'mobileexperts@projectgenie.com', '$2b$12$0DxkPhCdrBlRbuaib1wdgOVElYUfGVkxkwAclnU4oCRdjv4JmOvbO', 'Steve J.', 'App Crafters', '+91 98765 00005', 'https://ui-avatars.com/api/?name=App+C&background=8E24AA&color=fff', 'Flutter and React Native mobile application development.', 4.6, 3800, 14, true, true, 'active', CURRENT_TIMESTAMP);

-- 📁 Seed Categories
INSERT INTO "Category" ("id", "title", "icon", "count", "sortOrder") VALUES
('cat-1', 'AI & Machine Learning', '🤖', 124, 1),
('cat-2', 'Web Development', '💻', 342, 2),
('cat-3', 'Mobile Apps', '📱', 189, 3),
('cat-4', 'Data Science', '📊', 95, 4),
('cat-5', 'Cybersecurity', '🛡️', 67, 5),
('cat-6', 'Blockchain', '⛓️', 43, 6),
('cat-7', 'IoT & Hardware', '🔌', 88, 7),
('cat-8', 'UI/UX Design', '🎨', 210, 8),
('cat-9', 'Cloud Computing', '☁️', 112, 9),
('cat-10', 'Game Development', '🎮', 76, 10),
('cat-11', 'DevOps', '⚙️', 54, 11),
('cat-12', 'Mini Projects', '🚀', 150, 12);

-- 🛒 Seed Services
INSERT INTO "Service" ("id", "title", "description", "vendorName", "price", "originalPrice", "rating", "reviewCount", "deliveryDays", "isFeatured", "isTrending", "isActive", "imageUrl", "categoryId", "vendorId", "features", "updatedAt") VALUES
('srv-1', 'Thyroid Nodule Segmentation (TRFE-Net)', 'Complete implementation of TRFE-Net for medical imagery.', 'AI Research Lab', 2999, 4999, 4.9, 128, '3-5 Days', true, true, true, 'https://images.unsplash.com/photo-1576086202367-b1e114145d14?auto=format&fit=crop&q=80', 'cat-1', 'vendor-1', '["Python Code", "Model Weights", "Report", "Installation Setup"]', CURRENT_TIMESTAMP),
('srv-2', 'E-commerce MERN Stack App', 'Fully functional e-commerce platform with React and Node.js.', 'Code Masters Pro', 4500, 6000, 4.8, 85, '5-7 Days', true, false, true, 'https://images.unsplash.com/photo-1557821552-17105176677c?auto=format&fit=crop&q=80', 'cat-2', 'vendor-2', '["Frontend", "Backend", "MongoDB", "Auth"]', CURRENT_TIMESTAMP),
('srv-3', 'Face Recognition Attendance', 'Python based attendance system using OpenCV and face-recognition.', 'Python Wizards', 1500, 2500, 4.6, 42, '2-4 Days', false, true, true, 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&q=80', 'cat-1', 'vendor-3', '["OpenCV Code", "GUI", "Database"]', CURRENT_TIMESTAMP),
('srv-4', 'Flutter Grocery App UI', 'Stunning mobile app UI kit for grocery delivery.', 'Visionary Tech UI', 1200, 1800, 4.9, 210, '1-2 Days', false, true, true, 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80', 'cat-3', 'vendor-4', '["Figma File", "Flutter UI Code", "Animations"]', CURRENT_TIMESTAMP),
('srv-5', 'Blockchain Voting System', 'Decentralized voting app using Ethereum smart contracts.', 'App Crafters', 5500, 8000, 4.7, 36, '7-10 Days', true, false, true, 'https://images.unsplash.com/photo-1639322537228-f710d846310a?auto=format&fit=crop&q=80', 'cat-6', 'vendor-5', '["Solidity Smart Contract", "Web3.js Frontend", "Documentation"]', CURRENT_TIMESTAMP),
('srv-6', 'Sentiment Analysis Web App', 'NLP project to analyze tweets using Flask.', 'Python Wizards', 1800, 3000, 4.5, 50, '3-5 Days', false, false, true, 'https://images.unsplash.com/photo-1518186285589-2f7649de83e0?auto=format&fit=crop&q=80', 'cat-1', 'vendor-3', '["Flask App", "Jupyter Notebook", "Dataset"]', CURRENT_TIMESTAMP),
('srv-7', 'Portfolio Website Template', 'Responsive React portfolio template for developers.', 'Code Masters Pro', 500, 1000, 4.8, 150, '1 Day', false, true, true, 'https://images.unsplash.com/photo-1507238692062-110ce3aee815?auto=format&fit=crop&q=80', 'cat-2', 'vendor-2', '["React Code", "Tailwind CSS", "Customizable"]', CURRENT_TIMESTAMP),
('srv-8', 'IoT Home Automation Dashboard', 'Dashboard to control IoT devices using React and MQTT.', 'Visionary Tech UI', 3200, 4500, 4.6, 28, '4-6 Days', false, false, true, 'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?auto=format&fit=crop&q=80', 'cat-7', 'vendor-4', '["React Dashboard", "MQTT Backend", "UI Design"]', CURRENT_TIMESTAMP),
('srv-9', 'Netflix Clone (Flutter)', 'Complete UI clone of Netflix app in Flutter.', 'App Crafters', 2000, 3500, 4.7, 75, '2-3 Days', true, true, true, 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?auto=format&fit=crop&q=80', 'cat-3', 'vendor-5', '["Flutter Code", "Responsive UI", "Animations"]', CURRENT_TIMESTAMP),
('srv-10', 'Data Analysis with Pandas', 'Jupyter notebook for comprehensive EDA on any dataset.', 'AI Research Lab', 1000, 1500, 4.9, 90, '1-2 Days', false, true, true, 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80', 'cat-4', 'vendor-1', '["Jupyter Notebook", "Graphs", "Insights Report"]', CURRENT_TIMESTAMP);

-- 🎒 Seed Projects
INSERT INTO "Project" ("id", "title", "domain", "branch", "price", "originalPrice", "description", "imageUrl", "techStack", "rating", "reviewCount", "enrollees", "videoUrl", "difficulty", "isFeatured", "isActive", "vendorId", "categoryId", "updatedAt") VALUES
('prj-1', 'AI-Powered Resume Screener', 'Machine Learning', 'CSE', '1,499', '2,999', 'An NLP-based tool to automatically parse and rank resumes against job descriptions using TF-IDF and cosine similarity.', 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80', '["Python", "NLP", "Flask", "Scikit-Learn"]', 4.8, 45, 120, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'Intermediate', true, true, 'vendor-1', 'cat-1', CURRENT_TIMESTAMP),
('prj-2', 'Plant Disease Detection', 'Deep Learning', 'CSE/ECE', '1,999', '3,499', 'Uses Convolutional Neural Networks (CNN) to identify diseases in plant leaves from images.', 'https://images.unsplash.com/photo-1530836369250-ef71a36166f7?auto=format&fit=crop&q=80', '["TensorFlow", "Keras", "Python", "OpenCV"]', 4.9, 65, 215, NULL, 'Advanced', true, true, 'vendor-1', 'cat-1', CURRENT_TIMESTAMP),
('prj-3', 'Smart Parking System', 'IoT', 'ECE', '2,499', '4,000', 'IoT based parking management using IR sensors and NodeMCU to show available slots on a web dashboard.', 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&q=80', '["Arduino", "NodeMCU", "Firebase", "HTML/CSS"]', 4.7, 30, 85, NULL, 'Intermediate', false, true, 'vendor-3', 'cat-7', CURRENT_TIMESTAMP),
('prj-4', 'Hospital Management System', 'Web Dev', 'IT', '1,299', '2,500', 'A complete CRUD application for managing doctors, patients, and appointments.', 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80', '["PHP", "MySQL", "Bootstrap", "JS"]', 4.5, 22, 150, NULL, 'Beginner', false, true, 'vendor-2', 'cat-2', CURRENT_TIMESTAMP),
('prj-5', 'Expense Tracker App', 'Mobile Dev', 'CSE/IT', '1,799', '3,000', 'A cross-platform mobile app to track daily expenses with charts and cloud sync.', 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80', '["Flutter", "Dart", "Firebase"]', 4.8, 55, 190, NULL, 'Intermediate', true, true, 'vendor-5', 'cat-3', CURRENT_TIMESTAMP),
('prj-6', 'Credit Card Fraud Detection', 'Data Science', 'CSE', '1,599', '2,800', 'Predictive model using Random Forest and SMOTE to handle imbalanced dataset for fraud detection.', 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&q=80', '["Python", "Pandas", "Scikit", "Seaborn"]', 4.6, 40, 110, NULL, 'Advanced', false, true, 'vendor-1', 'cat-4', CURRENT_TIMESTAMP);

-- 👤 Seed Users
INSERT INTO "User" ("id", "email", "password", "name", "phone", "college", "branch", "walletBalance", "emailVerified", "updatedAt") VALUES
('user-1', 'vardhan@university.edu', '$2b$12$NkDK0Iebg7bTXxN3MtTg6.VrbCYBafSOsRcUm3fFFXZjEO/cKFzfu', 'Vardhan Kumar', '+91 98765 43210', 'JNTU Hyderabad', 'CSE', 2450, true, CURRENT_TIMESTAMP),
('user-2', 'student@college.edu', '$2b$12$NkDK0Iebg7bTXxN3MtTg6.VrbCYBafSOsRcUm3fFFXZjEO/cKFzfu', 'Student User', '+91 87654 32109', 'VIT University', 'ECE', 500, true, CURRENT_TIMESTAMP);

-- 📦 Seed Bundles
INSERT INTO "Bundle" ("id", "title", "subtitle", "tag", "price", "originalPrice", "color") VALUES
('bnd-1', 'Final Year Complete Bundle', 'Project + Report + PPT + Video', 'Best Value', 4999, 9999, 4282686866),
('bnd-2', 'Mini Project Pack', 'Code + Report', 'Popular', 1499, 2999, 4280391411),
('bnd-3', 'Research Paper Bundle', 'IEEE Base Paper + Implementation', 'Premium', 7999, 14999, 4293467747);
