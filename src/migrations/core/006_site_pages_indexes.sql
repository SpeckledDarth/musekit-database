-- Add indexes to site_pages for common query patterns
-- Table already exists (created by Prompt 18)
CREATE INDEX IF NOT EXISTS idx_site_pages_slug ON site_pages(slug);
CREATE INDEX IF NOT EXISTS idx_site_pages_status ON site_pages(status);
