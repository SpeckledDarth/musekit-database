-- Create site_pages table for the CMS page builder
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
-- RLS policies
ALTER TABLE site_pages ENABLE ROW LEVEL SECURITY;
-- Public can read published pages
CREATE POLICY "Public can read published pages"
  ON site_pages FOR SELECT
  USING (status = 'published');
-- Admins can do everything
CREATE POLICY "Admins can manage all pages"
  ON site_pages FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('super_admin', 'admin')
    )
  );
-- Service role can do everything (for server-side operations)
CREATE POLICY "Service role full access"
  ON site_pages FOR ALL
  USING (auth.role() = 'service_role');
