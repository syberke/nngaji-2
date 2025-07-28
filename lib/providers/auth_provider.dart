import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      _isLoading = true;
      notifyListeners();

      final session = Supabase.instance.client.auth.currentSession;
      if (session?.user != null) {
        await _fetchUserProfile(session!.user.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Listen to auth changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session?.user != null) {
        _fetchUserProfile(session!.user.id);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile(String userId) async {
    try {
      _user = await _authService.getUserProfile(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.signIn(email, password);
      if (response.user != null) {
        await _fetchUserProfile(response.user!.id);
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
        type: type,
        organizeId: organizeId,
      );

      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}