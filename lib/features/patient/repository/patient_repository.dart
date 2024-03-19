import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';

final patientRepositoryProvider = Provider((ref) => PatientRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class PatientRepository {
  PatientRepository({required this.firestore, required this.auth});
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  Stream<List<MedicalTestModel>> searchMedicalTests(String query) {
    if (query.isNotEmpty) {
      return firestore
          .collection('medicalTests')
          .orderBy('medicalTestName') // Order by user name
          .startAt([query.toUpperCase()])
          .endAt([query.toLowerCase() + '\uf8ff'])
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return MedicalTestModel.fromJson(doc.data());
            }).where((user) {
              return user.medicalTestName
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            }).toList();
          });
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<MedicineModel>> searchMedicines(String query) {
    if (query.isNotEmpty) {
      print(query);
      return firestore
          .collection('medicines')
          .orderBy('medicineName') // Order by user name
          .startAt([query.toUpperCase()])
          .endAt([query.toLowerCase() + '\uf8ff'])
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return MedicineModel.fromJson(doc.data());
            }).where((user) {
              return user.medicineName
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            }).toList();
          });
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<MedicalEquipmentModel>> searchMedicalEquipments(String query) {
    if (query.isNotEmpty) {
      return firestore
          .collection('medicalEquipements')
          .orderBy('equipmentName') // Order by user name
          .startAt([query.toUpperCase()])
          .endAt([query.toLowerCase() + '\uf8ff'])
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return MedicalEquipmentModel.fromJson(doc.data());
            }).where((user) {
              return user.equipmentName
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            }).toList();
          });
    } else {
      return Stream.value([]);
    }
  }

  Future<void> uploadOrderToFirestore(OrderModel order) async {
    try {
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
      for (var medicine in order.medicines) {
        await reduceMedicineQuantity(
            medicine.medicineUid, medicine.medicineQuantity);
      }
      for (var medicalEquipment in order.medicalEquipments) {
        await reduceMedicalEquipmentQuantity(
            medicalEquipment.equipmentUid, medicalEquipment.quantity);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reduceMedicineQuantity(
      String medicineId, int quantityToReduce) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('medicines').doc(medicineId).get();
      if (doc.exists) {
        Map data = doc.data() as Map;
        int currentQuantity = data['medicineQuantity'];
        int newQuantity = currentQuantity - quantityToReduce;

        await firestore
            .collection('medicines')
            .doc(medicineId)
            .update({'medicineQuantity': newQuantity});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reduceMedicalEquipmentQuantity(
      String medicineId, int quantityToReduce) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('medicalEquipements')
          .doc(medicineId)
          .get();
      if (doc.exists) {
        Map data = doc.data()! as Map;
        int currentQuantity = data['quantity'];
        int newQuantity = currentQuantity - quantityToReduce;

        // Update the quantity of the medicine in Firestore
        await firestore
            .collection('medicalEquipements')
            .doc(medicineId)
            .update({'quantity': newQuantity});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadMedicalTestRequest(MedicalTestRequestModel request) async {
    try {
      await firestore
          .collection('medicalTestRequests')
          .doc(request.requestId)
          .set(request.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> getOrderHistory() {
    return firestore
        .collection('orders')
        .where('userId',
            isEqualTo:
                FirebaseAuth.instance.currentUser!.uid) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return firestore
        .collection('orders')
        .where('userId',
            isEqualTo:
                FirebaseAuth.instance.currentUser!.uid) 
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestAppointments() {
    return firestore
        .collection('medicalTestRequests')
        .where('isAccepted', isEqualTo: true)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MedicalTestRequestModel.fromJson(doc.data());
      }).toList();
    });
  }
}
