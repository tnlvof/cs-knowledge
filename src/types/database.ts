export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          nickname: string;
          level: number;
          exp: number;
          hp: number;
          max_hp: number;
          job_class: string;
          job_tier: number;
          top_category: string | null;
          avatar_type: string;
          gem_balance: number;
          total_donated: number;
          supporter_tier: string;
          combo_count: number;
          consecutive_wrong_count: number;
          total_correct: number;
          total_questions: number;
          estimated_salary: number;
          best_combo: number;
          weekly_exp: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          nickname: string;
          avatar_type: string;
          level?: number;
          exp?: number;
          hp?: number;
          max_hp?: number;
          job_class?: string;
          job_tier?: number;
          top_category?: string | null;
          gem_balance?: number;
          total_donated?: number;
          supporter_tier?: string;
          combo_count?: number;
          consecutive_wrong_count?: number;
          total_correct?: number;
          total_questions?: number;
          estimated_salary?: number;
          best_combo?: number;
          weekly_exp?: number;
        };
        Update: Partial<Database["public"]["Tables"]["profiles"]["Insert"]>;
      };
      questions: {
        Row: {
          id: string;
          category: string;
          subcategory: string | null;
          difficulty: number;
          level_min: number;
          level_max: number;
          question_text: string;
          correct_answer: string;
          keywords: string[];
          explanation: string;
          source_doc: string | null;
          total_attempts: number;
          correct_count: number;
          accuracy_rate: number;
          created_at: string;
        };
        Insert: {
          category: string;
          difficulty: number;
          level_min: number;
          level_max: number;
          question_text: string;
          correct_answer: string;
          keywords: string[];
          explanation: string;
          subcategory?: string | null;
          source_doc?: string | null;
          total_attempts?: number;
          correct_count?: number;
        };
        Update: Partial<Database["public"]["Tables"]["questions"]["Insert"]>;
      };
      monsters: {
        Row: {
          id: string;
          name: string;
          level_min: number;
          level_max: number;
          hp: number;
          image_url: string | null;
          description: string | null;
          category: string | null;
        };
        Insert: {
          name: string;
          level_min: number;
          level_max: number;
          hp: number;
          image_url?: string | null;
          description?: string | null;
          category?: string | null;
        };
        Update: Partial<Database["public"]["Tables"]["monsters"]["Insert"]>;
      };
      quiz_history: {
        Row: {
          id: string;
          user_id: string;
          question_id: string;
          user_answer: string;
          ai_score: number;
          ai_feedback: string;
          ai_correct_answer: string;
          is_correct: string;
          exp_earned: number;
          time_spent_sec: number | null;
          combo_count: number;
          monster_id: string | null;
          created_at: string;
        };
        Insert: {
          user_id: string;
          question_id: string;
          user_answer: string;
          ai_score: number;
          ai_feedback: string;
          ai_correct_answer: string;
          is_correct: string;
          exp_earned: number;
          time_spent_sec?: number | null;
          combo_count?: number;
          monster_id?: string | null;
        };
        Update: Partial<
          Database["public"]["Tables"]["quiz_history"]["Insert"]
        >;
      };
      battle_sessions: {
        Row: {
          id: string;
          user_id: string;
          monster_id: string;
          monster_hp: number;
          user_hp: number;
          status: string;
          questions_answered: number;
          created_at: string;
          completed_at: string | null;
        };
        Insert: {
          user_id: string;
          monster_id: string;
          monster_hp: number;
          user_hp: number;
          status?: string;
          questions_answered?: number;
          completed_at?: string | null;
        };
        Update: Partial<
          Database["public"]["Tables"]["battle_sessions"]["Insert"]
        >;
      };
      shop_items: {
        Row: {
          id: string;
          name: string;
          category: string;
          description: string | null;
          price_gem: number;
          image_url: string | null;
          rarity: string;
          created_at: string;
        };
        Insert: {
          name: string;
          category: string;
          price_gem: number;
          rarity?: string;
          description?: string | null;
          image_url?: string | null;
        };
        Update: Partial<Database["public"]["Tables"]["shop_items"]["Insert"]>;
      };
      user_items: {
        Row: {
          id: string;
          user_id: string;
          item_id: string;
          equipped: boolean;
          purchased_at: string;
        };
        Insert: {
          user_id: string;
          item_id: string;
          equipped?: boolean;
        };
        Update: Partial<Database["public"]["Tables"]["user_items"]["Insert"]>;
      };
      donations: {
        Row: {
          id: string;
          user_id: string;
          amount: number;
          gem_amount: number;
          payment_key: string | null;
          order_id: string;
          status: string;
          created_at: string;
        };
        Insert: {
          user_id: string;
          amount: number;
          gem_amount: number;
          order_id: string;
          payment_key?: string | null;
          status?: string;
        };
        Update: Partial<Database["public"]["Tables"]["donations"]["Insert"]>;
      };
      seasons: {
        Row: {
          id: string;
          season_number: number;
          starts_at: string;
          ends_at: string;
          status: string;
        };
        Insert: {
          season_number: number;
          starts_at: string;
          ends_at: string;
          status?: string;
        };
        Update: Partial<Database["public"]["Tables"]["seasons"]["Insert"]>;
      };
      hall_of_fame: {
        Row: {
          id: string;
          season_id: string;
          user_id: string;
          rank: number;
          final_level: number;
          final_exp: number;
          title_awarded: string;
        };
        Insert: {
          season_id: string;
          user_id: string;
          rank: number;
          final_level: number;
          final_exp: number;
          title_awarded: string;
        };
        Update: Partial<Database["public"]["Tables"]["hall_of_fame"]["Insert"]>;
      };
      category_stats: {
        Row: {
          id: string;
          user_id: string;
          category: string;
          correct_count: number;
          total_count: number;
          accuracy: number;
          updated_at: string;
        };
        Insert: {
          user_id: string;
          category: string;
          correct_count?: number;
          total_count?: number;
        };
        Update: Partial<Database["public"]["Tables"]["category_stats"]["Insert"]>;
      };
    };
  };
}
