import { createBrowserClient as createSSRBrowserClient } from "@supabase/ssr";
import { createServerClient as createSSRServerClient } from "@supabase/ssr";
import { createClient } from "@supabase/supabase-js";
import type { Database } from "./schema";

export type CookieStore = {
  getAll: () => { name: string; value: string }[];
  set: (name: string, value: string, options?: Record<string, unknown>) => void;
};

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "";

/**
 * Creates a Supabase client for use in browser/client components.
 * Uses @supabase/ssr for cookie-based session management.
 * Throws if NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY are missing.
 *
 * Use this in "use client" components and client-side hooks.
 */
export function createBrowserClient() {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    throw new Error("Missing Supabase environment variables");
  }
  return createSSRBrowserClient<Database>(SUPABASE_URL, SUPABASE_ANON_KEY);
}

/**
 * Creates a Supabase client for use in Next.js server contexts (Server Components, Route Handlers, Server Actions).
 * Requires a cookieStore for session persistence across SSR boundaries.
 * Throws if NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY are missing.
 *
 * Use this in server components and API route handlers.
 */
export function createServerClient(cookieStore: CookieStore) {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    throw new Error("Missing Supabase environment variables");
  }
  return createSSRServerClient<Database>(SUPABASE_URL, SUPABASE_ANON_KEY, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet: { name: string; value: string; options?: Record<string, unknown> }[]) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
        }
      },
    },
  });
}

/**
 * Creates a Supabase admin client that bypasses Row Level Security (RLS).
 * Uses SUPABASE_SERVICE_ROLE_KEY — NEVER expose this client to the browser.
 * Throws if NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY are missing.
 *
 * Use this for server-side admin operations (user management, settings writes, etc.).
 */
export function createAdminClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY || "";
  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error("Missing Supabase admin environment variables");
  }
  return createClient<Database>(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
