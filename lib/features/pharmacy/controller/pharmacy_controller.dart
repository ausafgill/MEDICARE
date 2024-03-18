import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/pharmacy/repository/pharmacy_repository.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';

final pharmacyControllerProvider = Provider(
  (ref) {
    final PharmacyRepository pharmacyRepository =
        ref.read(pharmacyRepositoryProvider);
    return PharmacyController(pharmacyRepository: pharmacyRepository);
  },
);

class PharmacyController {
  PharmacyController({required this.pharmacyRepository});
  PharmacyRepository pharmacyRepository;

  Future<void> addMedicineToCatalogue(
      MedicineModel medicine, File imageFile) async {
    await pharmacyRepository.addMedicineToCatalogue(medicine, imageFile);
  }

  Future<void> addMedicalTestToCatalogue(MedicalTestModel medicalTest) async {
    await pharmacyRepository.addMedicalTestToCatalogue(medicalTest);
  }

  Stream<List<MedicineModel>> getPharmacyCatalogue() {
    return pharmacyRepository.getPharmacyCatalogue();
  }

  Stream<List<MedicalTestModel>> getMedicalTestCatalogue() {
    return pharmacyRepository.getMedicalTestsOfPharmacy();
  }

  Future<void> updateMedicineQuantity(
      String medicineId, int newQuantity) async {
    await pharmacyRepository.updateMedicineQuantity(medicineId, newQuantity);
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return pharmacyRepository.getActiveOrders();
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestRequests() {
    return pharmacyRepository.getMedicalTestRequests();
  }

  Future acceptMedicalTestRequest(String requestId, DateTime date) async {
    pharmacyRepository.acceptMedicalTestRequest(requestId, date);
  }

  Future rejectMedicalTestRequest(String requestId) async {
    pharmacyRepository.rejectMedicalTestRequest(requestId);
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestAppointments() {
    return pharmacyRepository.getMedicalTestAppointments();
  }
}
