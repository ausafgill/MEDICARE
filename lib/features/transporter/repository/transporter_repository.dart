import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/order_model.dart';

final transporterRepositoryProvider =
    Provider((ref) => TransporterRepository());

class TransporterRepository {
  Stream<List<OrderModel>> streamOrdersWithoutTransporter() {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('transporterId', isNull: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              return OrderModel.fromJson(data);
            }).toList(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> streamOrdersForTransporter() {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection('orders')
          .where('transporterId', isEqualTo: currentUserId)
          .where('isCompleted', isEqualTo: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.map((doc) {
                Map<String, dynamic> data = doc.data();
                return OrderModel.fromJson(data);
              }).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> orderCompleted(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {
          'isCompleted': true,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'transporterId': currentUserId,
      });
    } catch (e) {
      rethrow;
    }
  }
}
