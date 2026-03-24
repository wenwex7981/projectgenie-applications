-- ═══════════════════════════════════════════════════════════════════
-- ProjectGenie — Additional Schema for Full End-to-End Functionality
-- Run this in Supabase SQL Editor
-- ═══════════════════════════════════════════════════════════════════

-- ─── Editable Banners (Home Carousel) ──────────────────────────────
CREATE TABLE IF NOT EXISTS "Banner" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "tag" TEXT,
    "imageUrl" TEXT,
    "gradientStart" TEXT DEFAULT '0xFF1A56DB',
    "gradientEnd" TEXT DEFAULT '0xFF7C3AED',
    "linkType" TEXT, -- 'category', 'project', 'service', 'url'
    "linkTarget" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Banner_pkey" PRIMARY KEY ("id")
);

-- ─── Advertisements ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "Advertisement" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "imageUrl" TEXT,
    "videoUrl" TEXT,
    "linkUrl" TEXT,
    "placement" TEXT NOT NULL DEFAULT 'home', -- 'home', 'explore', 'category', 'detail'
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "vendorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Advertisement_pkey" PRIMARY KEY ("id")
);

-- ─── Hackathon Table (if not exists) ───────────────────────────────
CREATE TABLE IF NOT EXISTS "Hackathon" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "organizer" TEXT,
    "imageUrl" TEXT,
    "prizePool" TEXT,
    "registrationUrl" TEXT,
    "startDate" TIMESTAMP(3),
    "endDate" TIMESTAMP(3),
    "location" TEXT,
    "mode" TEXT DEFAULT 'Online', -- 'Online', 'Offline', 'Hybrid'
    "maxTeamSize" INTEGER DEFAULT 4,
    "domains" TEXT, -- comma-separated
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "vendorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Hackathon_pkey" PRIMARY KEY ("id")
);

-- ─── Internship Listings ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "Internship" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "title" TEXT NOT NULL,
    "company" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "location" TEXT,
    "mode" TEXT DEFAULT 'Remote', -- 'Remote', 'On-site', 'Hybrid'
    "duration" TEXT,
    "stipend" TEXT,
    "domain" TEXT,
    "skills" TEXT, -- comma-separated
    "applyUrl" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "vendorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Internship_pkey" PRIMARY KEY ("id")
);

-- ─── Cart Items ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "CartItem" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "userId" TEXT NOT NULL,
    "serviceId" TEXT,
    "projectId" TEXT,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CartItem_pkey" PRIMARY KEY ("id")
);

-- ─── FCM Push Notification Tokens ──────────────────────────────────
CREATE TABLE IF NOT EXISTS "FcmToken" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid()::TEXT,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "platform" TEXT NOT NULL DEFAULT 'android', -- 'android', 'ios'
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FcmToken_pkey" PRIMARY KEY ("id")
);

-- ─── Project Requirements (Form Filling) ───────────────────────────
-- Uses existing CustomOrder table with additional fields
ALTER TABLE "CustomOrder" ADD COLUMN IF NOT EXISTS "projectType" TEXT;
ALTER TABLE "CustomOrder" ADD COLUMN IF NOT EXISTS "preferredTechStack" TEXT;
ALTER TABLE "CustomOrder" ADD COLUMN IF NOT EXISTS "referenceFiles" TEXT;
ALTER TABLE "CustomOrder" ADD COLUMN IF NOT EXISTS "urgency" TEXT DEFAULT 'Normal';

-- ─── Add role column to Vendor for Admin RBAC ──────────────────────
ALTER TABLE "Vendor" ADD COLUMN IF NOT EXISTS "role" TEXT DEFAULT 'vendor';
ALTER TABLE "Vendor" ADD COLUMN IF NOT EXISTS "fcmToken" TEXT;
ALTER TABLE "User" ADD COLUMN IF NOT EXISTS "fcmToken" TEXT;

-- ─── Foreign Keys for new tables ───────────────────────────────────
ALTER TABLE "Advertisement" ADD CONSTRAINT "Advertisement_vendorId_fkey" 
    FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "Hackathon" ADD CONSTRAINT "Hackathon_vendorId_fkey" 
    FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "Internship" ADD CONSTRAINT "Internship_vendorId_fkey" 
    FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_userId_fkey" 
    FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ─── Enable Realtime on new tables ─────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE "Banner";
ALTER PUBLICATION supabase_realtime ADD TABLE "Advertisement";
ALTER PUBLICATION supabase_realtime ADD TABLE "Hackathon";
ALTER PUBLICATION supabase_realtime ADD TABLE "Internship";
ALTER PUBLICATION supabase_realtime ADD TABLE "CartItem";

-- ─── RLS Policies (basic, can be tightened) ────────────────────────
ALTER TABLE "Banner" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access on Banner" ON "Banner" FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on Banner" ON "Banner" FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated update on Banner" ON "Banner" FOR UPDATE USING (true);
CREATE POLICY "Allow authenticated delete on Banner" ON "Banner" FOR DELETE USING (true);

ALTER TABLE "Advertisement" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access on Advertisement" ON "Advertisement" FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on Advertisement" ON "Advertisement" FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated update on Advertisement" ON "Advertisement" FOR UPDATE USING (true);
CREATE POLICY "Allow authenticated delete on Advertisement" ON "Advertisement" FOR DELETE USING (true);

ALTER TABLE "Hackathon" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access on Hackathon" ON "Hackathon" FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on Hackathon" ON "Hackathon" FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated update on Hackathon" ON "Hackathon" FOR UPDATE USING (true);
CREATE POLICY "Allow authenticated delete on Hackathon" ON "Hackathon" FOR DELETE USING (true);

ALTER TABLE "Internship" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read access on Internship" ON "Internship" FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on Internship" ON "Internship" FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated update on Internship" ON "Internship" FOR UPDATE USING (true);
CREATE POLICY "Allow authenticated delete on Internship" ON "Internship" FOR DELETE USING (true);

ALTER TABLE "CartItem" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow users to manage own cart" ON "CartItem" FOR ALL USING (true);

-- ─── Seed Initial Banners ──────────────────────────────────────────
INSERT INTO "Banner" ("id", "title", "subtitle", "tag", "gradientStart", "gradientEnd", "sortOrder", "updatedAt")
VALUES
  ('banner-1', 'Final Year Project Sale', 'Flat 40% OFF on all BTech Major Projects', '🔥 LIMITED', '0xFF1A56DB', '0xFF7C3AED', 1, NOW()),
  ('banner-2', 'Professional Resumes', 'Get your ATS-ready resume in 24 hours', '✨ NEW', '0xFF059669', '0xFF0284C7', 2, NOW()),
  ('banner-3', 'Research Publication', 'Get published in IEEE / Springer / Scopus', '📚 TRENDING', '0xFFDC2626', '0xFFF59E0B', 3, NOW()),
  ('banner-4', 'Expert Mentorship', '1-on-1 guidance from industry professionals', '⭐ PREMIUM', '0xFF7C3AED', '0xFFEC4899', 4, NOW())
ON CONFLICT ("id") DO NOTHING;

-- ─── Create Storage Buckets (run via Supabase Dashboard or API) ────
-- Bucket: project-images
-- Bucket: service-images  
-- Bucket: profile-images
-- Bucket: banner-images
-- Bucket: advertisement-media
-- Bucket: hackathon-images
-- Bucket: documents
