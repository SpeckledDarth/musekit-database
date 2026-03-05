export interface Profile {
  id: string;
  email: string;
  full_name: string | null;
  avatar_url: string | null;
  role: string;
  created_at: string;
  updated_at: string;
}

export interface Organization {
  id: string;
  name: string;
  slug: string;
  owner_id: string;
  created_at: string;
}

export interface OrganizationMember {
  id: string;
  organization_id: string;
  user_id: string;
  role: string;
  joined_at: string;
}

export interface Invitation {
  id: string;
  organization_id: string;
  email: string;
  role: string;
  token: string;
  invited_by: string;
  expires_at: string;
  created_at: string;
  accepted_at: string | null;
}

export interface ProductSubscription {
  id: string;
  user_id: string;
  product_slug: string;
  stripe_subscription_id: string | null;
  stripe_price_id: string | null;
  tier_id: string;
  status: string;
  current_period_end: string | null;
  cancel_at_period_end: boolean;
  created_at: string;
  updated_at: string;
}

export interface AuditLog {
  id: string;
  user_id: string | null;
  action: string;
  resource_type: string;
  resource_id: string | null;
  metadata: Record<string, unknown> | null;
  ip_address: string | null;
  created_at: string;
}

export interface Notification {
  id: string;
  user_id: string;
  type: string;
  title: string;
  message: string;
  read: boolean;
  created_at: string;
}

export interface Setting {
  id: string;
  key: string;
  value: string;
}

export interface Post {
  id: string;
  type: string;
  title: string;
  slug: string;
  excerpt: string | null;
  content: string;
  author_id: string;
  published: boolean;
  published_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface WaitlistEntry {
  id: string;
  email: string;
  created_at: string;
}

export interface Feedback {
  id: string;
  user_id: string | null;
  message: string;
  nps_score: number | null;
  created_at: string;
}

export interface EmailTemplate {
  id: string;
  name: string;
  subject: string;
  body: string;
  variables: string[] | null;
  updated_at: string;
}

export interface ConfigSecret {
  id: string;
  key_name: string;
  encrypted_value: string;
  updated_at: string;
  updated_by: string | null;
}

export interface SocialPost {
  id: string;
  user_id: string;
  content: string;
  platform: string;
  media_urls: string[] | null;
  status: string;
  scheduled_at: string | null;
  posted_at: string | null;
  platform_post_id: string | null;
  engagement_data: Record<string, unknown>;
  error_message: string | null;
  ai_generated: boolean;
  brand_voice: string | null;
  trend_source: string | null;
  niche_triggered: string | null;
  created_at: string;
  updated_at: string;
}

export interface SocialAccount {
  id: string;
  user_id: string;
  platform: string;
  platform_user_id: string | null;
  platform_username: string | null;
  display_name: string | null;
  access_token_encrypted: string | null;
  refresh_token_encrypted: string | null;
  token_expires_at: string | null;
  scopes: string[] | null;
  is_valid: boolean;
  last_validated_at: string | null;
  last_error: string | null;
  connected_at: string;
  updated_at: string;
}

export interface BrandPreference {
  id: string;
  user_id: string;
  org_id: string | null;
  tone: string;
  niche: string;
  location: string | null;
  sample_urls: string[];
  target_audience: string | null;
  posting_goals: string | null;
  preferred_platforms: string[];
  post_frequency: string;
  created_at: string;
  updated_at: string;
}

export interface SocialAnalytics {
  id: string;
  post_id: string;
  platform: string;
  likes: number;
  shares: number;
  comments: number;
  reach: number;
  impressions: number;
  recorded_at: string;
}

export interface PostQueue {
  id: string;
  user_id: string;
  post_id: string;
  position: number;
  scheduled_at: string | null;
}

export interface ProfileInsert {
  id: string;
  email: string;
  full_name?: string | null;
  avatar_url?: string | null;
  role?: string;
  created_at?: string;
  updated_at?: string;
}

export interface OrganizationInsert {
  name: string;
  slug: string;
  owner_id: string;
  id?: string;
  created_at?: string;
}

export interface OrganizationMemberInsert {
  organization_id: string;
  user_id: string;
  id?: string;
  role?: string;
  joined_at?: string;
}

export interface InvitationInsert {
  organization_id: string;
  email: string;
  invited_by: string;
  token: string;
  expires_at: string;
  id?: string;
  role?: string;
  created_at?: string;
  accepted_at?: string | null;
}

export interface ProductSubscriptionInsert {
  user_id: string;
  product_slug: string;
  tier_id: string;
  id?: string;
  stripe_subscription_id?: string | null;
  stripe_price_id?: string | null;
  status?: string;
  current_period_end?: string | null;
  cancel_at_period_end?: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface AuditLogInsert {
  action: string;
  resource_type: string;
  id?: string;
  user_id?: string | null;
  resource_id?: string | null;
  metadata?: Record<string, unknown> | null;
  ip_address?: string | null;
  created_at?: string;
}

export interface NotificationInsert {
  user_id: string;
  type: string;
  title: string;
  message: string;
  id?: string;
  read?: boolean;
  created_at?: string;
}

export interface SettingInsert {
  key: string;
  value: string;
  id?: string;
}

export interface PostInsert {
  title: string;
  slug: string;
  content: string;
  author_id: string;
  type?: string;
  id?: string;
  excerpt?: string | null;
  published?: boolean;
  published_at?: string | null;
  created_at?: string;
  updated_at?: string;
}

export interface WaitlistEntryInsert {
  email: string;
  id?: string;
  created_at?: string;
}

export interface FeedbackInsert {
  message: string;
  id?: string;
  user_id?: string | null;
  nps_score?: number | null;
  created_at?: string;
}

export interface EmailTemplateInsert {
  name: string;
  subject: string;
  body: string;
  id?: string;
  variables?: string[] | null;
  updated_at?: string;
}

export interface ConfigSecretInsert {
  key_name: string;
  encrypted_value: string;
  id?: string;
  updated_at?: string;
  updated_by?: string | null;
}

export interface SocialPostInsert {
  user_id: string;
  platform: string;
  content: string;
  id?: string;
  media_urls?: string[] | null;
  status?: string;
  scheduled_at?: string | null;
  posted_at?: string | null;
  platform_post_id?: string | null;
  engagement_data?: Record<string, unknown>;
  error_message?: string | null;
  ai_generated?: boolean;
  brand_voice?: string | null;
  trend_source?: string | null;
  niche_triggered?: string | null;
  created_at?: string;
  updated_at?: string;
}

export interface SocialAccountInsert {
  user_id: string;
  platform: string;
  id?: string;
  platform_user_id?: string | null;
  platform_username?: string | null;
  display_name?: string | null;
  access_token_encrypted?: string | null;
  refresh_token_encrypted?: string | null;
  token_expires_at?: string | null;
  scopes?: string[] | null;
  is_valid?: boolean;
  last_validated_at?: string | null;
  last_error?: string | null;
  connected_at?: string;
  updated_at?: string;
}

export interface BrandPreferenceInsert {
  user_id: string;
  id?: string;
  org_id?: string | null;
  tone?: string;
  niche?: string;
  location?: string | null;
  sample_urls?: string[];
  target_audience?: string | null;
  posting_goals?: string | null;
  preferred_platforms?: string[];
  post_frequency?: string;
  created_at?: string;
  updated_at?: string;
}

export interface SocialAnalyticsInsert {
  post_id: string;
  platform: string;
  id?: string;
  likes?: number;
  shares?: number;
  comments?: number;
  reach?: number;
  impressions?: number;
  recorded_at?: string;
}

export interface PostQueueInsert {
  user_id: string;
  post_id: string;
  id?: string;
  position?: number;
  scheduled_at?: string | null;
}

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile;
        Insert: ProfileInsert;
        Update: Partial<ProfileInsert>;
        Relationships: [];
      };
      organizations: {
        Row: Organization;
        Insert: OrganizationInsert;
        Update: Partial<OrganizationInsert>;
        Relationships: [];
      };
      organization_members: {
        Row: OrganizationMember;
        Insert: OrganizationMemberInsert;
        Update: Partial<OrganizationMemberInsert>;
        Relationships: [
          { foreignKeyName: "organization_members_organization_id_fkey"; columns: ["organization_id"]; isOneToOne: false; referencedRelation: "organizations"; referencedColumns: ["id"] }
        ];
      };
      invitations: {
        Row: Invitation;
        Insert: InvitationInsert;
        Update: Partial<InvitationInsert>;
        Relationships: [
          { foreignKeyName: "invitations_organization_id_fkey"; columns: ["organization_id"]; isOneToOne: false; referencedRelation: "organizations"; referencedColumns: ["id"] }
        ];
      };
      muse_product_subscriptions: {
        Row: ProductSubscription;
        Insert: ProductSubscriptionInsert;
        Update: Partial<ProductSubscriptionInsert>;
        Relationships: [];
      };
      audit_logs: {
        Row: AuditLog;
        Insert: AuditLogInsert;
        Update: Partial<AuditLogInsert>;
        Relationships: [];
      };
      notifications: {
        Row: Notification;
        Insert: NotificationInsert;
        Update: Partial<NotificationInsert>;
        Relationships: [];
      };
      settings: {
        Row: Setting;
        Insert: SettingInsert;
        Update: Partial<SettingInsert>;
        Relationships: [];
      };
      posts: {
        Row: Post;
        Insert: PostInsert;
        Update: Partial<PostInsert>;
        Relationships: [];
      };
      waitlist_entries: {
        Row: WaitlistEntry;
        Insert: WaitlistEntryInsert;
        Update: Partial<WaitlistEntryInsert>;
        Relationships: [];
      };
      feedback: {
        Row: Feedback;
        Insert: FeedbackInsert;
        Update: Partial<FeedbackInsert>;
        Relationships: [];
      };
      email_templates: {
        Row: EmailTemplate;
        Insert: EmailTemplateInsert;
        Update: Partial<EmailTemplateInsert>;
        Relationships: [];
      };
      config_secrets: {
        Row: ConfigSecret;
        Insert: ConfigSecretInsert;
        Update: Partial<ConfigSecretInsert>;
        Relationships: [];
      };
      social_posts: {
        Row: SocialPost;
        Insert: SocialPostInsert;
        Update: Partial<SocialPostInsert>;
        Relationships: [];
      };
      social_accounts: {
        Row: SocialAccount;
        Insert: SocialAccountInsert;
        Update: Partial<SocialAccountInsert>;
        Relationships: [];
      };
      brand_preferences: {
        Row: BrandPreference;
        Insert: BrandPreferenceInsert;
        Update: Partial<BrandPreferenceInsert>;
        Relationships: [];
      };
      social_analytics: {
        Row: SocialAnalytics;
        Insert: SocialAnalyticsInsert;
        Update: Partial<SocialAnalyticsInsert>;
        Relationships: [
          { foreignKeyName: "social_analytics_post_id_fkey"; columns: ["post_id"]; isOneToOne: false; referencedRelation: "social_posts"; referencedColumns: ["id"] }
        ];
      };
      post_queue: {
        Row: PostQueue;
        Insert: PostQueueInsert;
        Update: Partial<PostQueueInsert>;
        Relationships: [
          { foreignKeyName: "post_queue_post_id_fkey"; columns: ["post_id"]; isOneToOne: false; referencedRelation: "social_posts"; referencedColumns: ["id"] }
        ];
      };
    };
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
  };
}
