class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://your-project.supabase.co');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'your-anon-key');
  
  // Cloudinary Configuration
  static const String cloudinaryCloudName = 'dkzklcr1a';
  static const String cloudinaryUploadPreset = 'video_upload';
  static const String cloudinaryBaseUrl = 'https://api.cloudinary.com/v1_1';
  
  // App Configuration
  static const String appName = 'Ngaji App';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String equranApiBase = 'https://equran.id/api/v2';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Audio Settings
  static const int maxRecordingDuration = 300; // 5 minutes
  static const String audioFormat = 'm4a';
  
  // Points System
  static const int hafalanPoints = 20;
  static const int murojaahPoints = 15;
  static const int quizCorrectPoints = 10;
  
  // Achievement Levels
  static const Map<String, int> achievementLevels = {
    'Beginner': 0,
    'Intermediate': 100,
    'Advanced': 200,
    'Expert': 500,
    'Master': 1000,
  };
}