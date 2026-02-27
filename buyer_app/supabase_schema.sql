-- ═══════════════════════════════════════════════════════════════════
-- ProjectGenie Enterprise — Supabase Database Schema
-- Run this in the Supabase SQL Editor to set up all tables
-- ═══════════════════════════════════════════════════════════════════

-- ─── Drop existing tables (clean slate) ────────────────────────────
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS domains CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ─── Categories Table ──────────────────────────────────────────────
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT DEFAULT '',
  icon TEXT DEFAULT 'category',
  color TEXT DEFAULT '#1A56DB',
  bg_color TEXT DEFAULT '#EBF5FF',
  service_count INT DEFAULT 0,
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Domains Table (for project filters) ───────────────────────────
CREATE TABLE domains (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  short_name TEXT NOT NULL,
  description TEXT DEFAULT '',
  project_count INT DEFAULT 0,
  color TEXT DEFAULT '#1A56DB',
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Projects Table ───────────────────────────────────────────────
CREATE TABLE projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  domain TEXT NOT NULL,
  branch TEXT DEFAULT '',
  price TEXT NOT NULL,
  original_price TEXT DEFAULT '',
  description TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  tech_stack TEXT[] DEFAULT '{}',
  rating FLOAT DEFAULT 0.0,
  review_count INT DEFAULT 0,
  enrollees INT DEFAULT 0,
  video_url TEXT DEFAULT '',
  difficulty TEXT DEFAULT 'Intermediate',
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  vendor_id UUID DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Services Table ───────────────────────────────────────────────
CREATE TABLE services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  vendor_name TEXT DEFAULT '',
  vendor_avatar TEXT DEFAULT '',
  category TEXT NOT NULL,
  price TEXT NOT NULL,
  original_price TEXT DEFAULT '',
  rating FLOAT DEFAULT 0.0,
  review_count INT DEFAULT 0,
  delivery_days TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  features TEXT[] DEFAULT '{}',
  is_featured BOOLEAN DEFAULT false,
  is_trending BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Reviews Table ─────────────────────────────────────────────────
CREATE TABLE reviews (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_name TEXT NOT NULL,
  rating FLOAT NOT NULL,
  comment TEXT DEFAULT '',
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  service_id UUID REFERENCES services(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Orders Table ──────────────────────────────────────────────────
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID DEFAULT NULL,
  service_name TEXT NOT NULL,
  vendor_name TEXT DEFAULT '',
  total_price TEXT NOT NULL,
  status TEXT DEFAULT 'Pending',
  payment_status TEXT DEFAULT 'Pending',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ─── Cart Items Table ──────────────────────────────────────────────
CREATE TABLE cart_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID DEFAULT NULL,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  service_id UUID REFERENCES services(id) ON DELETE CASCADE,
  quantity INT DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════
-- SEED DATA
-- ═══════════════════════════════════════════════════════════════════

-- ─── Categories ────────────────────────────────────────────────────
INSERT INTO categories (title, subtitle, icon, color, bg_color, service_count, sort_order) VALUES
  ('Final Year Projects', 'B.Tech / M.Tech / MCA ready', 'school', '#F59E0B', '#FEF3C7', 120, 1),
  ('Resume Templates', 'ATS-optimized templates', 'description', '#059669', '#D1FAE5', 85, 2),
  ('Mini & Major Projects', 'Ready to deploy solutions', 'rocket_launch', '#1A56DB', '#DBEAFE', 250, 3),
  ('Resume Writing Service', 'Professional writers on demand', 'edit_document', '#7C3AED', '#EDE9FE', 45, 4),
  ('Research Paper Writing', 'IEEE / Springer / Scopus', 'science', '#DC2626', '#FEE2E2', 60, 5);

-- ─── Domains ───────────────────────────────────────────────────────
INSERT INTO domains (name, short_name, project_count, color, sort_order) VALUES
  ('AI & Machine Learning', 'AI/ML', 35, '#8B5CF6', 1),
  ('Computer Science', 'CSE', 45, '#3B82F6', 2),
  ('Internet of Things', 'IoT', 18, '#10B981', 3),
  ('Data Science', 'Data Sci', 28, '#F59E0B', 4),
  ('Electrical Engineering', 'EEE', 12, '#EF4444', 5),
  ('Electronics & Comm.', 'ECE', 15, '#06B6D4', 6),
  ('Cyber Security', 'Cyber', 10, '#DC2626', 7),
  ('Mechanical / Robotics', 'Mech', 8, '#F97316', 8),
  ('Blockchain', 'Web3', 6, '#7C3AED', 9);

-- ─── Projects (Final Year) ────────────────────────────────────────
INSERT INTO projects (title, domain, branch, price, original_price, description, image_url, tech_stack, rating, review_count, enrollees, difficulty, is_featured) VALUES
  ('AI-Powered Plant Disease Detection System', 'AI/ML', 'Computer Science', '₹4,999', '₹7,999', 'Deep learning CNN model to identify 38+ plant diseases from leaf images. Features mobile-friendly UI, real-time camera inference, and detailed treatment recommendations using transfer learning with EfficientNet.', 'https://images.unsplash.com/photo-1625246333195-09d9d8855404?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'TensorFlow', 'Flask', 'React Native'], 4.9, 324, 1250, 'Advanced', true),
  ('Real-time Traffic Violation Detection using YOLOv8', 'AI/ML', 'Artificial Intelligence', '₹5,999', '₹9,999', 'Automated traffic monitoring system detecting helmet violations, speed breaches, and signal jumps in real-time video feeds.', 'https://images.unsplash.com/photo-1565514020126-db26b2b73c4d?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'YOLOv8', 'OpenCV', 'PyTorch'], 4.8, 198, 890, 'Advanced', true),
  ('Fake News Detection System using NLP', 'AI/ML', 'Computer Science', '₹3,799', '₹5,999', 'LSTM-based deep learning model to classify news articles as real or fake with web scraping and text preprocessing.', 'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'NLTK', 'Keras', 'Streamlit'], 4.6, 156, 670, 'Intermediate', false),
  ('Emotion Recognition from Speech using Deep Learning', 'AI/ML', 'AI & Data Science', '₹4,499', '', 'CNN + LSTM hybrid model for recognizing emotions from speech audio. Uses MFCC feature extraction.', 'https://images.unsplash.com/photo-1589254065878-42c9da997008?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'Librosa', 'TensorFlow', 'Flask'], 4.7, 89, 340, 'Advanced', false),
  ('Full-Stack E-Learning Platform with AI Tutor', 'CSE', 'Computer Science', '₹4,499', '₹6,999', 'Comprehensive LMS with course management, AI-powered doubt solver, interactive quizzes, and payment gateway.', 'https://images.unsplash.com/photo-1504639725590-34d0984388bd?auto=format&fit=crop&q=80&w=800', ARRAY['MongoDB', 'Express', 'React', 'Node.js'], 4.8, 445, 2100, 'Intermediate', true),
  ('Decentralized E-Voting on Ethereum', 'CSE', 'Computer Science', '₹5,499', '', 'Secure, transparent voting system on Ethereum blockchain with smart contracts and React frontend.', 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?auto=format&fit=crop&q=80&w=800', ARRAY['Solidity', 'React', 'Node.js', 'Web3.js'], 4.9, 267, 980, 'Advanced', false),
  ('Hospital Management System', 'CSE', 'Computer Science', '₹3,999', '', 'Complete HMS with patient records, doctor scheduling, appointment booking, billing, and pharmacy management.', 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=800', ARRAY['Java', 'Spring Boot', 'MySQL', 'Angular'], 4.5, 189, 750, 'Intermediate', false),
  ('Smart Helmet for Mine Workers', 'IoT', 'Electronics & Communication', '₹5,499', '₹8,499', 'Intelligent safety system monitoring toxic gases, humidity, temperature with SOS button and GPS tracking.', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&q=80&w=800', ARRAY['Arduino', 'Raspberry Pi', 'Firebase', 'React'], 4.7, 134, 520, 'Advanced', true),
  ('Smart Agriculture Monitoring System', 'IoT', 'ECE', '₹4,999', '', 'IoT-based crop monitoring with soil moisture sensors, automated irrigation, and mobile app control.', 'https://images.unsplash.com/photo-1574943320219-553eb213f72d?auto=format&fit=crop&q=80&w=800', ARRAY['ESP32', 'MQTT', 'Node.js', 'React Native'], 4.6, 98, 380, 'Intermediate', false),
  ('Home Automation with Voice Control', 'IoT', 'EEE', '₹3,499', '', 'Smart home system with voice-controlled appliances, motion detection, and energy monitoring.', 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?auto=format&fit=crop&q=80&w=800', ARRAY['Arduino', 'ESP8266', 'Firebase', 'Flutter'], 4.4, 76, 290, 'Beginner', false),
  ('Customer Churn Prediction with Explainable AI', 'Data Science', 'AI & Data Science', '₹3,999', '', 'End-to-end ML pipeline for predicting customer churn with SHAP explanations and Streamlit dashboard.', 'https://images.unsplash.com/photo-1551288049-bbbda536339a?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'Scikit-learn', 'SHAP', 'Streamlit'], 4.7, 145, 560, 'Intermediate', false),
  ('Stock Price Prediction using LSTM', 'Data Science', 'Computer Science', '₹4,499', '', 'Deep learning time-series forecasting with LSTM for stock price prediction with technical indicators.', 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'TensorFlow', 'yfinance', 'Plotly'], 4.5, 210, 890, 'Advanced', false),
  ('Solar Power Monitoring & Management System', 'EEE', 'Electrical Engineering', '₹4,999', '', 'IoT-enabled solar panel monitoring with real-time power generation tracking and fault detection.', 'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&q=80&w=800', ARRAY['Arduino', 'LoRa', 'Python', 'Grafana'], 4.6, 67, 230, 'Advanced', false),
  ('Smart Energy Meter with Theft Detection', 'EEE', 'Electrical Engineering', '₹3,999', '', 'Digital energy meter with tamper detection and real-time consumption monitoring.', 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?auto=format&fit=crop&q=80&w=800', ARRAY['Arduino', 'GSM Module', 'Firebase', 'Android'], 4.3, 45, 180, 'Intermediate', false),
  ('FPGA-based Image Processing System', 'ECE', 'Electronics & Communication', '₹6,999', '', 'Hardware-accelerated image processing on FPGA with edge detection and noise filtering.', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=800', ARRAY['Verilog', 'VHDL', 'MATLAB', 'Xilinx Vivado'], 4.8, 56, 190, 'Advanced', false),
  ('Wireless Health Monitoring Band', 'ECE', 'Electronics & Communication', '₹5,499', '', 'Wearable health band measuring heart rate, SpO2, body temperature with BLE connectivity.', 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=800', ARRAY['ARM Cortex', 'BLE', 'Flutter', 'Firebase'], 4.7, 89, 340, 'Advanced', false),
  ('Network Intrusion Detection using ML', 'Cyber Security', 'Computer Science', '₹4,999', '', 'ML-based NIDS using Random Forest & XGBoost trained on NSL-KDD dataset.', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800', ARRAY['Python', 'Scapy', 'Scikit-learn', 'Flask'], 4.6, 123, 450, 'Advanced', false);

-- ─── Services ──────────────────────────────────────────────────────
-- Resume Templates
INSERT INTO services (title, description, vendor_name, category, price, rating, review_count, delivery_days, is_trending) VALUES
  ('ATS-Optimized Tech Resume', 'Professionally designed LaTeX resume template optimized for ATS systems. Used by 10,000+ engineers.', 'CareerPro Templates', 'Resume', '499', 4.9, 2340, 'Instant', true),
  ('Creative Designer Resume Pack', '5 stunning resume + cover letter templates for UI/UX designers.', 'DesignStudio Pro', 'Resume', '699', 4.8, 1560, 'Instant', false),
  ('MBA & Management Resume Bundle', 'Executive-level resume templates tailored for MBA graduates.', 'ExecutiveEdge', 'Resume', '599', 4.7, 890, 'Instant', false),
  ('Fresher Resume Starter Kit', 'Perfect for college students. Includes 3 templates, cover letter, and guide.', 'FirstStep Careers', 'Resume', '299', 4.6, 3200, 'Instant', true);

-- Resume Writing Services
INSERT INTO services (title, description, vendor_name, category, price, rating, review_count, delivery_days, features, is_trending) VALUES
  ('Professional Resume Writing', 'Expert writers craft your ATS-friendly resume with keyword optimization. Includes 2 revisions.', 'ResumeGenie Pro', 'Resume Writing', '1,999', 4.9, 1890, '3', ARRAY['ATS Optimized', '2 Revisions', 'Cover Letter', 'LinkedIn Summary'], true),
  ('Executive Resume Overhaul', 'Complete resume transformation by senior HR consultants. Unlimited revisions for 30 days.', 'LeadCraft Resumes', 'Resume Writing', '3,999', 4.8, 670, '5', ARRAY['Expert Writer', 'Unlimited Revisions', 'LinkedIn Optimization', 'Interview Tips'], false),
  ('Fresher Resume + LinkedIn Package', 'Tailored for fresh graduates. Resume and LinkedIn profile from scratch.', 'FirstJob Academy', 'Resume Writing', '999', 4.7, 2340, '2', ARRAY['ATS Friendly', '1 Revision', 'LinkedIn Profile', 'Job Portal Setup'], false),
  ('Tech Resume for FAANG', 'Specialized resume writing for FAANG. Written by ex-Google recruiters.', 'TechCareer Lab', 'Resume Writing', '2,999', 4.9, 560, '4', ARRAY['FAANG Optimized', 'ATS Score 95+', '3 Revisions', 'Mock Interview Prep'], true);

-- Research Paper Services
INSERT INTO services (title, description, vendor_name, category, price, rating, review_count, delivery_days, features, is_trending) VALUES
  ('IEEE Paper Writing & Publication', 'End-to-end IEEE conference paper writing with topic selection and journal submission.', 'AcademiaPro Research', 'Research Paper', '7,999', 4.8, 780, '15', ARRAY['Topic Selection', 'Plagiarism Free', 'Journal Submission', 'Revision Support'], true),
  ('Springer / Scopus Paper Writing', 'Q1/Q2 ranked journal paper writing with complete research methodology.', 'ResearchHub Elite', 'Research Paper', '12,999', 4.9, 340, '21', ARRAY['Q1/Q2 Journals', 'Statistical Analysis', 'Peer Review Ready', 'Publication Guarantee'], false),
  ('Literature Review & Survey Paper', 'Comprehensive systematic literature review with 50+ paper analysis.', 'ScholarWrite', 'Research Paper', '4,999', 4.7, 560, '10', ARRAY['50+ Papers Analyzed', 'Gap Analysis', 'Citation Management', 'Turnitin Report'], false),
  ('Conference Paper Express', 'Quick turnaround conference paper for upcoming deadlines.', 'QuickPublish', 'Research Paper', '5,999', 4.6, 890, '7', ARRAY['Fast Delivery', 'Camera Ready', 'Plagiarism Check', 'Presentation PPT'], false);

-- General Projects
INSERT INTO services (title, description, vendor_name, category, price, rating, review_count, delivery_days, is_trending) VALUES
  ('Python Automation Scripts Bundle', '20+ production-ready automation scripts for web scraping and APIs.', 'CodeCraft Studio', 'Projects', '499', 4.5, 1200, 'Instant', false),
  ('React Admin Dashboard Template', 'Premium admin panel with 50+ components, dark mode, charts.', 'UIStack Pro', 'Projects', '1,499', 4.8, 890, 'Instant', true),
  ('Flutter E-Commerce Full App', 'Complete e-commerce app with product catalog, cart, checkout.', 'AppForge Labs', 'Projects', '2,999', 4.7, 650, '2', false),
  ('MERN Stack Social Media App', 'Full-featured social media platform with posts, likes, real-time chat.', 'FullStack Hub', 'Projects', '3,499', 4.6, 430, '3', false);

-- Trending Services
INSERT INTO services (title, description, vendor_name, category, price, rating, review_count, delivery_days, image_url, is_trending) VALUES
  ('Custom Deep Learning Model', 'We build custom AI models tailored to your dataset and requirements.', 'Data Wizards', 'AI/ML', '5,999', 4.8, 320, '14', 'https://images.unsplash.com/photo-1555942807-7393d6da61b0?auto=format&fit=crop&q=80&w=800', true),
  ('Project Report + PPT + Viva Guide', 'Complete final year documentation bundle with IEEE format.', 'DocuPro', 'Documentation', '1,999', 4.9, 2100, '5', 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=800', true),
  ('1-on-1 Project Mentorship', 'Get personal guidance from industry experts.', 'MentorConnect', 'Mentorship', '2,499', 4.9, 450, 'Flexible', 'https://images.unsplash.com/photo-1522071823991-b1ae5e6a3048?auto=format&fit=crop&q=80&w=800', true);

-- ─── Row Level Security (RLS) ──────────────────────────────────────
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- Public read access policies
CREATE POLICY "Public read access" ON projects FOR SELECT USING (true);
CREATE POLICY "Public read access" ON services FOR SELECT USING (true);
CREATE POLICY "Public read access" ON categories FOR SELECT USING (true);
CREATE POLICY "Public read access" ON domains FOR SELECT USING (true);
CREATE POLICY "Public read access" ON reviews FOR SELECT USING (true);

-- Authenticated user policies for orders and cart
CREATE POLICY "Public read orders" ON orders FOR SELECT USING (true);
CREATE POLICY "Public insert orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Public read cart" ON cart_items FOR SELECT USING (true);
CREATE POLICY "Public insert cart" ON cart_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Public delete cart" ON cart_items FOR DELETE USING (true);

-- ─── Indexes ───────────────────────────────────────────────────────
CREATE INDEX idx_projects_domain ON projects(domain);
CREATE INDEX idx_projects_featured ON projects(is_featured);
CREATE INDEX idx_projects_rating ON projects(rating DESC);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_trending ON services(is_trending);
CREATE INDEX idx_services_rating ON services(rating DESC);
