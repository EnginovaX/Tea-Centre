class SessionEntity {
  final String sessionId;
  final String userId;
  final String deviceToken;
  final String deviceModel;
  final String platform;
  final DateTime lastActiveAt;

  const SessionEntity({
    required this.sessionId,
    required this.userId,
    required this.deviceToken,
    required this.deviceModel,
    required this.platform,
    required this.lastActiveAt,
  });

  SessionEntity copyWith({
    String? sessionId,
    String? userId,
    String? deviceToken,
    String? deviceModel,
    String? platform,
    DateTime? lastActiveAt,
  }) {
    return SessionEntity(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceModel: deviceModel ?? this.deviceModel,
      platform: platform ?? this.platform,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
