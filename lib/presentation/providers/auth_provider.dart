import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/authentication_entity.dart';
import 'dependency_providers.dart';

class AuthStateNotifier extends StateNotifier<AuthenticationEntity> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(AuthenticationEntity.unauthenticated) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _ref.read(authRepositoryProvider).authStateChanges.listen((auth) {
      state = auth;
    });
  }

  Future<void> sendOtp(String phoneNumber) async {
    await _ref.read(authRepositoryProvider).sendOtp(phoneNumber);
  }

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    final auth = await _ref.read(authRepositoryProvider).verifyOtp(verificationId, smsCode);
    state = auth;
  }

  Future<void> loginAsGuest() async {
    final auth = await _ref.read(authRepositoryProvider).loginAsGuest();
    state = auth;
  }

  Future<void> signInWithGoogle() async {
    final auth = await _ref.read(authRepositoryProvider).signInWithGoogle();
    state = auth;
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    final auth = await _ref.read(authRepositoryProvider).signInWithEmailPassword(email, password);
    state = auth;
  }

  Future<void> signUpWithEmailPassword(String email, String password) async {
    final auth = await _ref.read(authRepositoryProvider).signUpWithEmailPassword(email, password);
    state = auth;
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = AuthenticationEntity.unauthenticated;
  }

  Future<void> checkAutoLogin() async {
    final auth = await _ref.read(authRepositoryProvider).checkAutoLogin();
    if (auth != null) {
      state = auth;
    }
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthenticationEntity>((ref) {
  return AuthStateNotifier(ref);
});
