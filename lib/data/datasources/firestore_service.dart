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
}
