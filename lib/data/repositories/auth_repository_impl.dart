import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/authentication_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_service.dart';
import '../datasources/session_manager.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final SessionManager _sessionManager;

  AuthRepositoryImpl({
    required FirebaseAuthService authService,
    required SessionManager sessionManager,
  })  : _authService = authService,
        _sessionManager = sessionManager;

  @override
  Stream<AuthenticationEntity> get authStateChanges =>
      _authService.authStateChanges.map((fbUser) {
        if (fbUser == null) {
          return AuthenticationEntity.unauthenticated;
        }
        return AuthenticationEntity(
          uid: fbUser.uid,
          phoneNumber: fbUser.phoneNumber,
          email: fbUser.email,
          isGuest: fbUser.isAnonymous,
          isAuthenticated: true,
        );
      });

  @override
  Future<void> sendOtp(String phoneNumber) async {
    await _authService.sendOtp(
      phoneNumber: phoneNumber,
      verificationCompleted: (fb.PhoneAuthCredential credential) {},
      verificationFailed: (fb.FirebaseAuthException e) {
        throw Exception(e.message ?? 'Phone verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<AuthenticationEntity> verifyOtp(String verificationId, String smsCode) async {
    final credential = fb.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _authService.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw Exception('Authentication failed');
    }

    final authEntity = AuthenticationEntity(
      uid: user.uid,
      phoneNumber: user.phoneNumber,
      email: user.email,
      isGuest: user.isAnonymous,
      isAuthenticated: true,
    );

    // Cache Session
    await _sessionManager.cacheSession({
      'uid': user.uid,
      'phoneNumber': user.phoneNumber,
      'email': user.email,
      'isGuest': user.isAnonymous,
    });

    return authEntity;
  }

  @override
  Future<AuthenticationEntity> signInWithGoogle() async {
    final userCredential = await _authService.signInAnonymously();
    final user = userCredential.user;
    if (user == null) throw Exception('Google sign in failed');

    final authEntity = AuthenticationEntity(
      uid: user.uid,
      email: user.email ?? 'google-user@gmail.com',
      isGuest: false,
      isAuthenticated: true,
    );

    await _sessionManager.cacheSession({
      'uid': user.uid,
      'email': authEntity.email,
      'isGuest': false,
    });

    return authEntity;
  }

  @override
  Future<AuthenticationEntity> signInWithEmailPassword(String email, String password) async {
    final userCredential = await _authService.signInWithEmailPassword(email, password);
    final user = userCredential.user;
    if (user == null) throw Exception('Email sign in failed');

    final authEntity = AuthenticationEntity(
      uid: user.uid,
      email: user.email,
      isGuest: false,
      isAuthenticated: true,
    );

    await _sessionManager.cacheSession({
      'uid': user.uid,
      'email': user.email,
      'isGuest': false,
    });

    return authEntity;
  }

  @override
  Future<AuthenticationEntity> signUpWithEmailPassword(String email, String password) async {
    final userCredential = await _authService.signUpWithEmailPassword(email, password);
    final user = userCredential.user;
    if (user == null) throw Exception('Email registration failed');

    final authEntity = AuthenticationEntity(
      uid: user.uid,
      email: user.email,
      isGuest: false,
      isAuthenticated: true,
    );

    await _sessionManager.cacheSession({
      'uid': user.uid,
      'email': user.email,
      'isGuest': false,
    });

    return authEntity;
  }

  @override
  Future<AuthenticationEntity> loginAsGuest() async {
    final userCredential = await _authService.signInAnonymously();
    final user = userCredential.user;
    if (user == null) throw Exception('Guest login failed');

    final authEntity = AuthenticationEntity(
      uid: user.uid,
      isGuest: true,
      isAuthenticated: true,
    );

    await _sessionManager.cacheSession({
      'uid': user.uid,
      'isGuest': true,
    });

    return authEntity;
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
    await _sessionManager.clearSession();
  }

  @override
  Future<AuthenticationEntity?> checkAutoLogin() async {
    final cached = _sessionManager.getCachedSession();
    if (cached != null) {
      return AuthenticationEntity(
        uid: cached['uid'] as String?,
        phoneNumber: cached['phoneNumber'] as String?,
        email: cached['email'] as String?,
        isGuest: cached['isGuest'] as bool? ?? false,
        isAuthenticated: true,
      );
    }
    return null;
  }
}
