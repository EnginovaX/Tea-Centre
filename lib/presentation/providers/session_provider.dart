import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/session_entity.dart';
import 'dependency_providers.dart';

class SessionNotifier extends StateNotifier<SessionEntity?> {
  final Ref _ref;

  SessionNotifier(this._ref) : super(null);

  Future<void> registerSession({
    required String userId,
    required String deviceToken,
    required String deviceModel,
    required String platform,
  }) async {
    final session = SessionEntity(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      deviceToken: deviceToken,
      deviceModel: deviceModel,
      platform: platform,
      lastActiveAt: DateTime.now(),
    );

    // Save session to firestore & cache token
    await _ref.read(firestoreServiceProvider).saveSession(session.sessionId, {
      'sessionId': session.sessionId,
      'userId': session.userId,
      'deviceToken': session.deviceToken,
      'deviceModel': session.deviceModel,
      'platform': session.platform,
      'lastActiveAt': session.lastActiveAt.toIso8601String(),
    });

    await _ref.read(firestoreServiceProvider).saveDeviceToken(userId, deviceToken, {
      'deviceModel': deviceModel,
      'platform': platform,
    });

    state = session;
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionEntity?>((ref) {
  return SessionNotifier(ref);
});
