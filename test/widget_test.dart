import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_centre/domain/repositories/auth_repository.dart';
import 'package:tea_centre/domain/entities/authentication_entity.dart';
import 'package:tea_centre/domain/entities/product_entity.dart';
import 'package:tea_centre/domain/entities/cart_item_entity.dart';
import 'package:tea_centre/domain/entities/offer_entity.dart';
import 'package:tea_centre/presentation/providers/dependency_providers.dart';
import 'package:tea_centre/presentation/providers/auth_provider.dart';
import 'package:tea_centre/presentation/providers/cart_provider.dart';

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

  test('CartState calculates correct totals and applied discount percentage', () {
    const product = ProductEntity(
      id: 'p1',
      name: 'Ginger Chai',
      description: 'Warm ginger chai',
      category: 'Chai',
      price: 30.0,
      imageUrl: '',
      rating: 4.8,
      preparationTimeMinutes: 5,
      isAvailable: true,
      isVeg: true,
      isBestseller: true,
    );

    const cartItem = CartItemEntity(product: product, quantity: 2);
    const offer = OfferEntity(
      code: 'CHAI50',
      description: '50% off',
      discountPercent: 50.0,
      maxDiscountAmount: 50.0,
    );

    final cartState = const CartState(items: [cartItem]).copyWith(appliedOffer: offer);

    // Subtotal: 30 * 2 = 60
    expect(cartState.subtotal, 60.0);
    // Discount: 50% of 60 = 30
    expect(cartState.discountAmount, 30.0);
    // Tax: 5% of 60 = 3
    expect(cartState.tax, 3.0);
    // Total: 60 - 30 + 3 (delivery is 20 for orders < 150) = 53
    expect(cartState.totalAmount, 53.0);
  });
}
