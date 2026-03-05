-- MuseKit Seed Data
-- Run this against your Supabase database to populate empty tables with test data.
-- Uses ON CONFLICT where possible (settings.key, site_pages.slug) for safe re-runs.
-- Ticket/campaign inserts will create duplicates if re-run — truncate those tables first if needed.
-- Requires at least one row in the profiles table for user references.

-- ============================================================================
-- 1. SETTINGS — Global app configuration (key/value pairs)
-- ============================================================================

INSERT INTO settings (id, key, value) VALUES
  (gen_random_uuid(), 'branding.appName', 'MuseKit'),
  (gen_random_uuid(), 'branding.description', 'Build Your SaaS Faster'),
  (gen_random_uuid(), 'branding.logoUrl', ''),
  (gen_random_uuid(), 'branding.primaryColor', '#4F46E5'),
  (gen_random_uuid(), 'branding.headerBg', '#ffffff'),
  (gen_random_uuid(), 'branding.footerBg', '#1f2937'),
  (gen_random_uuid(), 'features.googleAuth', 'true'),
  (gen_random_uuid(), 'features.githubAuth', 'true'),
  (gen_random_uuid(), 'features.magicLinks', 'true'),
  (gen_random_uuid(), 'features.helpWidget', 'true'),
  (gen_random_uuid(), 'ai.provider', 'xai'),
  (gen_random_uuid(), 'ai.model', 'grok-3-mini'),
  (gen_random_uuid(), 'content.sections', '[{"type":"hero","enabled":true,"sortOrder":1},{"type":"feature-cards","enabled":true,"sortOrder":2},{"type":"testimonials","enabled":true,"sortOrder":3},{"type":"pricing","enabled":true,"sortOrder":4},{"type":"faq","enabled":true,"sortOrder":5},{"type":"cta","enabled":true,"sortOrder":6}]')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- ============================================================================
-- 2. TICKETS — Support tickets (references profiles table)
-- ============================================================================

INSERT INTO tickets (id, user_id, subject, description, status, priority, category, ticket_number, created_at, updated_at) VALUES
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1), 'Cannot connect social account', 'I keep getting an error when trying to connect my Twitter account. The OAuth popup opens but then closes immediately without connecting.', 'open', 'high', 'bug', 'TK-001', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1), 'How do I upgrade my plan?', 'I want to upgrade from Starter to Premium but cannot find the upgrade button in my dashboard.', 'open', 'medium', 'billing', 'TK-002', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
  (gen_random_uuid(), (SELECT id FROM profiles OFFSET 1 LIMIT 1), 'Feature request: bulk scheduling', 'It would be great to be able to schedule multiple posts at once via CSV upload.', 'open', 'low', 'feature_request', 'TK-003', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
  (gen_random_uuid(), (SELECT id FROM profiles OFFSET 2 LIMIT 1), 'Post failed to publish', 'My scheduled post for yesterday at 3pm never went out. Still shows as "scheduled" in my dashboard.', 'in_progress', 'high', 'bug', 'TK-004', NOW() - INTERVAL '1 day', NOW() - INTERVAL '12 hours'),
  (gen_random_uuid(), (SELECT id FROM profiles OFFSET 1 LIMIT 1), 'Wrong timezone on scheduler', 'All my posts are scheduling 3 hours ahead of my local time. I have set my timezone to EST but it seems to be using UTC.', 'resolved', 'medium', 'bug', 'TK-005', NOW() - INTERVAL '7 days', NOW() - INTERVAL '4 days'),
  (gen_random_uuid(), (SELECT id FROM profiles LIMIT 1), 'Account deletion request', 'I would like to delete my account and all associated data. Please process this GDPR request.', 'open', 'high', 'account', 'TK-006', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
  (gen_random_uuid(), (SELECT id FROM profiles OFFSET 2 LIMIT 1), 'API rate limiting question', 'What are the rate limits for the API? I am building an integration and want to make sure I stay within limits.', 'closed', 'low', 'question', 'TK-007', NOW() - INTERVAL '10 days', NOW() - INTERVAL '8 days');

-- ============================================================================
-- 3. TICKET COMMENTS — Comments on support tickets (run after tickets insert)
-- ============================================================================

INSERT INTO ticket_comments (id, ticket_id, user_id, body, is_internal, created_at) VALUES
  (gen_random_uuid(), (SELECT id FROM tickets WHERE ticket_number = 'TK-001'), (SELECT id FROM profiles LIMIT 1), 'I have tried clearing my browser cache and using incognito mode but still getting the same error.', false, NOW() - INTERVAL '2 days'),
  (gen_random_uuid(), (SELECT id FROM tickets WHERE ticket_number = 'TK-001'), (SELECT id FROM profiles WHERE role = 'super_admin' LIMIT 1), 'This is a known issue with the Twitter OAuth v2 callback. We are working on a fix. As a workaround, try using Chrome.', false, NOW() - INTERVAL '1 day'),
  (gen_random_uuid(), (SELECT id FROM tickets WHERE ticket_number = 'TK-004'), (SELECT id FROM profiles WHERE role = 'super_admin' LIMIT 1), 'INTERNAL: Checked the job queue — the BullMQ worker crashed at 2:45pm. Restarted and the backlog is processing now.', true, NOW() - INTERVAL '10 hours'),
  (gen_random_uuid(), (SELECT id FROM tickets WHERE ticket_number = 'TK-005'), (SELECT id FROM profiles WHERE role = 'super_admin' LIMIT 1), 'Fixed in v2.4.1 — timezone was being stored as UTC offset instead of IANA zone name. Deployed the fix.', false, NOW() - INTERVAL '5 days'),
  (gen_random_uuid(), (SELECT id FROM tickets WHERE ticket_number = 'TK-005'), (SELECT id FROM profiles OFFSET 2 LIMIT 1), 'Confirmed, this is working correctly now. Thank you!', false, NOW() - INTERVAL '4 days');

-- ============================================================================
-- 4. CAMPAIGNS — Email campaigns (add columns if missing, then seed)
-- ============================================================================

ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS subject text;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS body text;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS from_name text;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS reply_to text;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS status text DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed'));
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS audience jsonb;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS scheduled_at timestamptz;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS sent_at timestamptz;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS sent_count integer DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS open_rate numeric DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS click_rate numeric DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS bounce_count integer DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS unsubscribe_count integer DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS updated_at timestamptz DEFAULT NOW();

INSERT INTO campaigns (id, name, subject, body, status, sent_at, sent_count, open_rate, click_rate, created_at) VALUES
  (gen_random_uuid(), 'Welcome Series Launch', 'Welcome to MuseKit!', '<h1>Welcome!</h1><p>Thanks for joining.</p>', 'sent', NOW() - INTERVAL '14 days', 245, 68.5, 12.3, NOW() - INTERVAL '14 days'),
  (gen_random_uuid(), 'Feature Announcement', 'New: Page Builder is here', '<h1>Build Pages</h1><p>Create custom pages.</p>', 'sent', NOW() - INTERVAL '7 days', 198, 52.1, 8.7, NOW() - INTERVAL '7 days'),
  (gen_random_uuid(), 'March Newsletter', 'Your March update', '<h1>March News</h1><p>Here is what happened.</p>', 'draft', NULL, 0, 0, 0, NOW() - INTERVAL '1 day');

-- ============================================================================
-- 5. AFFILIATE PROFILES — Add more for realistic testing
-- ============================================================================

INSERT INTO affiliate_profiles (id, user_id, display_name, payout_method, payout_email, onboarded_at, tour_completed, show_in_directory, created_at, updated_at)
SELECT gen_random_uuid(), p.id, p.full_name, 'paypal', p.email, NOW() - INTERVAL '30 days', true, true, NOW() - INTERVAL '30 days', NOW()
FROM profiles p
WHERE p.id NOT IN (SELECT user_id FROM affiliate_profiles)
LIMIT 4;

-- ============================================================================
-- 6. SITE PAGES — Create table, RLS policies, and seed data
-- ============================================================================

CREATE TABLE IF NOT EXISTS site_pages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  title text NOT NULL,
  description text,
  sections jsonb NOT NULL DEFAULT '[]'::jsonb,
  status text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published')),
  show_in_nav boolean DEFAULT true,
  sort_order integer DEFAULT 0,
  seo_title text,
  seo_description text,
  og_image text,
  focus_keyword text,
  canonical_url text,
  no_index boolean DEFAULT false,
  updated_by uuid REFERENCES profiles(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE site_pages ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'site_pages' AND policyname = 'Public can read published pages') THEN
    CREATE POLICY "Public can read published pages"
      ON site_pages FOR SELECT
      USING (status = 'published');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'site_pages' AND policyname = 'Admins can manage all pages') THEN
    CREATE POLICY "Admins can manage all pages"
      ON site_pages FOR ALL
      USING (
        EXISTS (
          SELECT 1 FROM profiles
          WHERE profiles.id = auth.uid()
          AND profiles.role IN ('super_admin', 'admin')
        )
      );
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'site_pages' AND policyname = 'Service role full access') THEN
    CREATE POLICY "Service role full access"
      ON site_pages FOR ALL
      USING (auth.role() = 'service_role');
  END IF;
END $$;

-- Homepage
INSERT INTO site_pages (id, slug, title, description, sections, status, show_in_nav, sort_order) VALUES
(gen_random_uuid(), 'home', 'Home', 'Build Your SaaS Faster with MuseKit', '[
  {"type":"hero","enabled":true,"sortOrder":1},
  {"type":"feature-cards","enabled":true,"sortOrder":2},
  {"type":"testimonials","enabled":true,"sortOrder":3},
  {"type":"pricing","enabled":true,"sortOrder":4},
  {"type":"faq","enabled":true,"sortOrder":5},
  {"type":"cta","enabled":true,"sortOrder":6}
]'::jsonb, 'published', false, 0)
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, sections = EXCLUDED.sections, status = EXCLUDED.status, show_in_nav = EXCLUDED.show_in_nav, sort_order = EXCLUDED.sort_order;

-- About page
INSERT INTO site_pages (id, slug, title, description, sections, status, show_in_nav, sort_order) VALUES
(gen_random_uuid(), 'about', 'About Us', 'Learn about the team behind MuseKit', '[
  {"type":"hero","enabled":true,"sortOrder":1,"props":{"style":"gradient","headline":"About MuseKit","subheadline":"We build tools that help developers ship faster.","ctaText":"Join Us","ctaLink":"/signup"}},
  {"type":"founder-letter","enabled":true,"sortOrder":2,"props":{"name":"Alex Morgan","title":"Founder & CEO","letter":"We started MuseKit because we were tired of rebuilding the same SaaS infrastructure for every project. Authentication, billing, admin dashboards, email systems — they are table stakes, not differentiators. We built MuseKit so you can focus on what makes your product unique."}},
  {"type":"image-text-blocks","enabled":true,"sortOrder":3,"props":{"blocks":[{"image":"","headline":"Our Mission","description":"Make SaaS development accessible to everyone by providing a production-grade foundation.","layout":"image-left"},{"image":"","headline":"Our Values","description":"Open source, developer-first, and built for scale. Every decision we make starts with the developer experience.","layout":"image-right"}]}},
  {"type":"bottom-hero-cta","enabled":true,"sortOrder":4,"props":{"headline":"Join the Community","subheadline":"Thousands of developers build with MuseKit.","ctaText":"Get Started","ctaLink":"/signup"}}
]'::jsonb, 'published', true, 1)
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, sections = EXCLUDED.sections, status = EXCLUDED.status, show_in_nav = EXCLUDED.show_in_nav, sort_order = EXCLUDED.sort_order;

-- Features page
INSERT INTO site_pages (id, slug, title, description, sections, status, show_in_nav, sort_order) VALUES
(gen_random_uuid(), 'features', 'Features', 'Everything included in MuseKit', '[
  {"type":"hero","enabled":true,"sortOrder":1,"props":{"style":"pattern","headline":"Everything You Need","subheadline":"A complete SaaS foundation with every feature built in.","ctaText":"Start Free","ctaLink":"/signup"}},
  {"type":"feature-cards","enabled":true,"sortOrder":2,"props":{"title":"Core Features","subtitle":"Production-ready modules you can adopt incrementally.","columns":3,"features":[{"icon":"Shield","title":"Authentication","description":"Email, social login, magic links, and role-based access control."},{"icon":"CreditCard","title":"Billing","description":"Stripe subscriptions, usage billing, invoices, and customer portal."},{"icon":"LayoutDashboard","title":"Admin Panel","description":"User management, analytics, content editing, and system settings."},{"icon":"Mail","title":"Email","description":"Transactional templates, campaigns, and delivery tracking."},{"icon":"Globe","title":"CMS","description":"Blog, landing pages, changelog, and media library."},{"icon":"Users","title":"Affiliate Program","description":"Full affiliate management with tiers, payouts, and tracking."}]}},
  {"type":"screenshot-showcase","enabled":true,"sortOrder":3,"props":{"title":"See It in Action","subtitle":"Built with modern design principles.","screenshots":[]}},
  {"type":"comparison-bars","enabled":true,"sortOrder":4,"props":{"title":"Build Faster","subtitle":"Compare development time with and without MuseKit.","beforeLabel":"Without MuseKit","afterLabel":"With MuseKit","comparisons":[{"label":"Auth System","before":80,"after":5,"unit":"hours"},{"label":"Billing Integration","before":120,"after":8,"unit":"hours"},{"label":"Admin Dashboard","before":200,"after":10,"unit":"hours"},{"label":"Email System","before":60,"after":4,"unit":"hours"}]}},
  {"type":"bottom-hero-cta","enabled":true,"sortOrder":5,"props":{"headline":"Ready to Build?","subheadline":"Get started in minutes, not months.","ctaText":"Start Free","ctaLink":"/signup"}}
]'::jsonb, 'published', true, 2)
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, sections = EXCLUDED.sections, status = EXCLUDED.status, show_in_nav = EXCLUDED.show_in_nav, sort_order = EXCLUDED.sort_order;
