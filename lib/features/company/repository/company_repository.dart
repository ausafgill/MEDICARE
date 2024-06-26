import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/order_model.dart';

final companyRepositoryProvider = Provider(
  (ref) => CompanyRepository(firestore: FirebaseFirestore.instance),
);

class CompanyRepository {
  CompanyRepository({required this.firestore});
  FirebaseFirestore firestore;

  Future<void> addMedicalEquipmentToCatalogue(
      MedicalEquipmentModel medicalEquipment) async {
    try {
      await firestore
          .collection('medicalEquipements')
          .doc(medicalEquipment.equipmentUid)
          .set(
            medicalEquipment.toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MedicalEquipmentModel>> getMedicalEquipmentCatalogue() {
    return FirebaseFirestore.instance
        .collection('medicalEquipements')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return MedicalEquipmentModel.fromJson(doc.data());
          }).toList(),
        );
  }

  Future<void> updateEquipmentQuantity(
      String equipmentId, int newQuantity) async {
    try {
      await firestore
          .collection('medicalEquipements')
          .doc(equipmentId) // Use the equipment ID
          .update({'quantity': newQuantity});
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> getActiveOrders() {
    print(FirebaseAuth.instance.currentUser!.uid);
    return firestore
        .collection('orders')
        .where('companyId',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final order = OrderModel.fromJson(doc.data());

        return order;
      }).toList();
    });
  }
}
