import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:uuid/uuid.dart';

final pharmacyRepositoryProvider = Provider(
  (ref) => PharmacyRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class PharmacyRepository {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  PharmacyRepository({required this.firestore, required this.auth});

  Future<void> addMedicineToCatalogue(
      MedicineModel medicine, File imageFile) async {
    try {
      String imageUrl = await uploadImage(imageFile);

      medicine.imageUrl = imageUrl;

      await firestore.collection('medicines').doc(medicine.medicineUid).set(
            medicine.toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMedicineQuantity(
      String medicineId, int newQuantity) async {
    try {
      await firestore
          .collection('medicines')
          .doc(medicineId) // Use the medicine ID
          .update({'medicineQuantity': newQuantity});
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MedicineModel>> getPharmacyCatalogue() {
    return firestore
        .collection('medicines')
        .where('pharmacyUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return MedicineModel.fromJson(doc.data());
          },
        ).toList();
      },
    );
  }

  Future<void> addMedicalTestToCatalogue(MedicalTestModel medicalTest) async {
    try {
      await firestore
          .collection('medicalTests')
          .doc(medicalTest.medicalTestUid) // Use the provided medical test UID
          .set(medicalTest.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MedicalTestModel>> getMedicalTestsOfPharmacy() {
    return firestore
        .collection('medicalTests')
        .where('pharmacyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => MedicalTestModel.fromJson(
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  Future<String> uploadImage(File image) async {
    try {
      String imageName =
          const Uuid().v4(); // Generate a UUID for the image file name
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('medicines/$imageName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return firestore
        .collection('orders')
        .where('pharmacyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final order = OrderModel.fromJson(doc.data());

        return order;
      }).toList();
    });
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestRequests() {
    return FirebaseFirestore.instance
        .collection('medicalTestRequests')
        .where('pharmacyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isAccepted', isEqualTo: false)
        .where('isRejected', isEqualTo: false)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => MedicalTestRequestModel.fromJson(doc.data()))
            .toList();
      },
    );
  }

  Future<void> acceptMedicalTestRequest(String requestId, DateTime date) async {
    try {
      await firestore.collection('medicalTestRequests').doc(requestId).update({
        'isAccepted': true,
        'requestDate': date.toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectMedicalTestRequest(String requestId) async {
    try {
      await firestore.collection('medicalTestRequests').doc(requestId).update({
        'isRejected': true,
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestAppointments() {
    return firestore
        .collection('medicalTestRequests')
        .where('isAccepted', isEqualTo: true)
        .where('pharmacyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MedicalTestRequestModel.fromJson(doc.data());
      }).toList();
    });
  }
}
