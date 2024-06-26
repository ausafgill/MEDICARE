import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicare/models/feedback_model.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:uuid/uuid.dart';

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

  Stream<List<MedicalTestModel>> getMedicalTestsOfPharmacy(String pharmacyUid) {
    return firestore
        .collection('medicalTests')
        .where('pharmacyId', isEqualTo: pharmacyUid)
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

  Stream<List<MedicineModel>> getPharmacyCatalogue(String pharmacyUid) {
    return firestore
        .collection('medicines')
        .where('pharmacyUid', isEqualTo: pharmacyUid)
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
      if (order.pharmacyId != null) {
        for (var i = 0; i < order.medicines!.length; i++) {
          await firestore
              .collection('medicines')
              .doc(order.medicines?[i].medicineUid)
              .update({
            'medicineQuantity': FieldValue.increment(
                -1 * (order.medicines?[i].medicineQuantity)!),
          });
        }
      } else {
        for (var i = 0; i < order.medicalEquipments!.length; i++) {
          await firestore
              .collection('medicalEquipements')
              .doc(order.medicalEquipments?[i].equipmentUid)
              .update({
            'medicineQuantity': FieldValue.increment(
                -1 * (order.medicalEquipments?[i].quantity)!),
          });
        }
      }
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
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

  Future<Stream<List<UserModel>>> getPharmaciesWithinRadius(
      UserModel currentUser) async {
    double currLat = currentUser.location!.latitude;
    double currLong = currentUser.location!.longitude;
    double radiusInM = 15000.0;
    double latRange = radiusInM / 110574;

    double minLat = currLat - latRange;
    double maxLat = currLat + latRange;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userAccountType', isEqualTo: 'pharmacy')
        .where('location.lat', isGreaterThan: minLat)
        .where('location.lat', isLessThan: maxLat)
        .get();

    List<UserModel> usersWithinRadius = querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .where((user) {
      print(Geolocator.distanceBetween(user.location!.latitude,
          user.location!.longitude, currLat, currLong));
      return Geolocator.distanceBetween(user.location!.latitude,
              user.location!.longitude, currLat, currLong) <=
          radiusInM;
    }).toList();

    usersWithinRadius.sort(
      (a, b) => Geolocator.distanceBetween(
              a.location!.latitude, a.location!.longitude, currLat, currLong)
          .compareTo(
        Geolocator.distanceBetween(
            b.location!.latitude, b.location!.longitude, currLat, currLong),
      ),
    );
    return Stream.value(usersWithinRadius);
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
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> storeFeedback(FeedbackModel feedback, String feedbackUid) async {
    try {
      await firestore
          .collection('feedback')
          .doc(feedbackUid)
          .set(feedback.toMap());

      await firestore.collection('admin').doc('appdata').update({
        'feedbacks': FieldValue.arrayUnion([feedbackUid]),
      });
    } catch (e) {
      rethrow;
    }
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
