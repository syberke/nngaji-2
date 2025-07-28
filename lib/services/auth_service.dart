import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    UserType? type,
    String? organizeId,
  }) async {
    try {
      // Sign up user
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        // Create user profile
        await _supabase.from('users').insert({
          'id': authResponse.user!.id,
          'email': email,
          'name': name,
          'role': role.name,
          'type': type?.name,
          'organize_id': organizeId,
        });
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getOrganizes() async {
    try {
      final response = await _supabase
          .from('organizes')
          .select()
          .order('name');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch organizes: ${e.toString()}');
    }
  }
}