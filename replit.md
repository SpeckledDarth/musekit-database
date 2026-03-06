# @musekit/database

## Overview
TypeScript library package providing Supabase client code, schema types, and query helpers for the MuseKit SaaS platform. This module is a code layer for an existing Supabase database — it does NOT create or modify database tables.

## Project Structure
```
src/
  index.ts          — barrel export (all public API)
  client.ts         — Supabase client factories (browser, server, admin)
  schema.ts         — TypeScript interfaces for all database tables + Database type
  queries.ts        — reusable query helper functions
  migrations/
    core/           — SQL documentation of core table schemas
    extensions/     — SQL documentation of extension table schemas (PassivePost)
  seeds/
    seed-data.sql   — seed data for empty tables (settings, tickets, campaigns, site_pages, etc.)
dist/               — compiled JavaScript output (auto-generated)
```

## Tech Stack
- TypeScript (ES2022, ESNext modules)
- @supabase/supabase-js — Supabase JavaScript client
- @supabase/ssr — Supabase SSR helpers for Next.js integration
- Node.js 20

## Build & Development
- `npm run build` — compile TypeScript to dist/
- `npm run dev` — watch mode (continuous compilation)
- `npm run typecheck` — type-check only, no output
- Workflow "Start application" runs `npx tsc -w` for dev mode

## Environment Variables
- `NEXT_PUBLIC_SUPABASE_URL` — Supabase project URL (must be static process.env reference for webpack/Next.js)
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Supabase anonymous/public key (must be static process.env reference)
- `SUPABASE_SERVICE_ROLE_KEY` — Supabase service role key (admin operations)

## Seed Data
Run `src/seeds/seed-data.sql` against Supabase to populate empty tables with test data.
Includes: settings (branding/features/AI config), tickets, ticket_comments, campaigns (with ALTER TABLE for missing columns), affiliate_profiles, and site_pages (CREATE TABLE + RLS + seed pages).

## Database Tables (Real DB Names)
Core: profiles, organizations, organization_members, invitations, muse_product_subscriptions, audit_logs, notifications, settings, posts, waitlist_entries, feedback, email_templates, config_secrets, site_pages

Extensions (PassivePost): social_posts, social_accounts, brand_preferences, social_analytics, post_queue

## Standalone Migration & Seed Files
```
supabase/
  migrations/
    002_create_site_pages.sql  — CREATE TABLE + RLS policies (run manually in Supabase SQL Editor)
  seed/
    003_site_pages_seed.sql    — seed data for home, about, features pages (run manually)
```
These files are NOT executed by this library. Copy and run them in the Supabase SQL Editor.

## Table Name Mapping (old theoretical → real DB)
- brand_settings → settings (key/value pairs, no updated_at)
- team_invitations → invitations (uses organization_id)
- team_members → organization_members (uses organization_id)
- subscriptions → muse_product_subscriptions (product_slug, tier_id, etc.)
- content_posts → posts (type, excerpt, published boolean)
- waitlist → waitlist_entries
- api_keys → config_secrets (key_name, encrypted_value, updated_by)
- feature_toggles → REMOVED (does not exist; use settings table)
- webhook_configs → REMOVED (does not exist)

## Reference
- Original implementation: github.com/SpeckledDarth/master-saas-muse
- Shared types package: github.com/SpeckledDarth/musekit-shared
