class AuthenticationEntity {
  final String? uid;
  final String? phoneNumber;
  final String? email;
  final bool isGuest;
  final bool isAuthenticated;

  const AuthenticationEntity({
    this.uid,
    this.phoneNumber,
    this.email,
    this.isGuest = false,
    this.isAuthenticated = false,
  });

  static const AuthenticationEntity unauthenticated = AuthenticationEntity();
}
