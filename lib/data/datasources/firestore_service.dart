import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // users collection
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> saveUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // addresses collection
  Future<List<Map<String, dynamic>>> getAddresses(String userId) async {
    final snap = await _firestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  Future<void> saveAddress(String addressId, Map<String, dynamic> data) async {
    await _firestore.collection('addresses').doc(addressId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteAddress(String addressId) async {
    await _firestore.collection('addresses').doc(addressId).delete();
  }

  // sessions collection
  Future<void> saveSession(String sessionId, Map<String, dynamic> data) async {
    await _firestore.collection('sessions').doc(sessionId).set(data, SetOptions(merge: true));
  }

  // devices collection
  Future<void> saveDeviceToken(String userId, String token, Map<String, dynamic> deviceDetails) async {
    await _firestore
        .collection('devices')
        .doc(userId)
        .set({'token': token, ...deviceDetails}, SetOptions(merge: true));
  }

  // notifications collection
  Future<void> logNotification(String userId, Map<String, dynamic> notificationData) async {
    await _firestore.collection('notifications').add({
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      ...notificationData,
    });
  }

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final snap = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  // products collection
  Future<List<Map<String, dynamic>>> getProducts() async {
    final snap = await _firestore.collection('products').get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    final snap = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  // categories collection
  Future<List<Map<String, dynamic>>> getCategories() async {
    final snap = await _firestore.collection('categories').get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  // offers collection
  Future<List<Map<String, dynamic>>> getOffers() async {
    final snap = await _firestore.collection('offers').get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  // cart collection
  Future<Map<String, dynamic>?> getCart(String userId) async {
    final doc = await _firestore.collection('cart').doc(userId).get();
    return doc.data();
  }

  Future<void> saveCart(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('cart').doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> clearCart(String userId) async {
    await _firestore.collection('cart').doc(userId).delete();
  }

  // favorites collection
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final snap = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addFavorite(String userId, String productId, Map<String, dynamic> productData) async {
    await _firestore
        .collection('favorites')
        .doc('${userId}_$productId')
        .set({'userId': userId, 'productId': productId, ...productData});
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await _firestore.collection('favorites').doc('${userId}_$productId').delete();
  }

  Future<bool> isFavorite(String userId, String productId) async {
    final doc = await _firestore.collection('favorites').doc('${userId}_$productId').get();
    return doc.exists;
  }

  // orders collection
  Future<void> placeOrder(String orderId, Map<String, dynamic> orderData) async {
    await _firestore.collection('orders').doc(orderId).set(orderData);
  }

  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final snap = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    return doc.data();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamOrderTracking(String orderId) {
    return _firestore.collection('orders').doc(orderId).snapshots();
  }
}
