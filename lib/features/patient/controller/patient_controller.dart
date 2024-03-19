import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/repository/patient_repository.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';

final patientControllerProvider = Provider((ref) {
  final patientRepository = ref.read(patientRepositoryProvider);
  return PatientController(patientRepository: patientRepository);
});

class PatientController {
  PatientController({
    required this.patientRepository,
  });
  final PatientRepository patientRepository;

  Stream<List<MedicineModel>> searchMedicines(String query) {
    return patientRepository.searchMedicines(query);
  }

  Stream<List<MedicalEquipmentModel>> searchMedicalEquipments(String query) {
    return patientRepository.searchMedicalEquipments(query);
  }

  Stream<List<MedicalTestModel>> searchMedicalTests(String query) {
    return patientRepository.searchMedicalTests(query);
  }

  Future<void> uploadOrderToFirebase(OrderModel order) async {
    await patientRepository.uploadOrderToFirestore(order);
  }

  Future<void> requestMedical(MedicalTestRequestModel medicalRequest) async {
    await patientRepository.uploadMedicalTestRequest(medicalRequest);
  }

  Stream<List<OrderModel>> getOrderHistory() {
    return patientRepository.getOrderHistory();
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return patientRepository.getActiveOrders();
  }

  Stream<List<MedicalTestRequestModel>> getMedicalTestAppointments() {
    return patientRepository.getMedicalTestAppointments();
  }
}
