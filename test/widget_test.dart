import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_centre/domain/repositories/auth_repository.dart';
import 'package:tea_centre/domain/entities/authentication_entity.dart';
import 'package:tea_centre/presentation/providers/dependency_providers.dart';
import 'package:tea_centre/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  test('AuthStateNotifier initial state is unauthenticated', () {
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(AuthenticationEntity.unauthenticated));

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );

    addTearDown(container.dispose);

    expect(
      container.read(authProvider),
      AuthenticationEntity.unauthenticated,
    );
  });

  test('AuthStateNotifier triggers loginAsGuest successfully', () async {
    const mockGuest = AuthenticationEntity(
      uid: 'guest123',
      isGuest: true,
      isAuthenticated: true,
    );

    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => Stream.value(AuthenticationEntity.unauthenticated));
    when(() => mockAuthRepository.loginAsGuest())
        .thenAnswer((_) async => mockGuest);

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );

    addTearDown(container.dispose);

    // Call loginAsGuest on notifier
    await container.read(authProvider.notifier).loginAsGuest();

    // Verify correct state is dispatched
    expect(container.read(authProvider), mockGuest);
  });
}
