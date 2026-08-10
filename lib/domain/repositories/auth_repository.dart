import '../entities/authentication_entity.dart';

abstract class AuthRepository {
  Stream<AuthenticationEntity> get authStateChanges;

  Future<void> sendOtp(String phoneNumber);

  Future<AuthenticationEntity> verifyOtp(String verificationId, String smsCode);

  Future<AuthenticationEntity> signInWithGoogle();

  Future<AuthenticationEntity> signInWithEmailPassword(String email, String password);

  Future<AuthenticationEntity> signUpWithEmailPassword(String email, String password);

  Future<AuthenticationEntity> loginAsGuest();

  Future<void> logout();

  Future<AuthenticationEntity?> checkAutoLogin();
}
