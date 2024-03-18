import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/company/repository/company_repository.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/order_model.dart';

final companyControllerProvider = Provider((ref) {
  final companyRepository = ref.read(companyRepositoryProvider);
  return CompanyController(companyRepository: companyRepository);
});

class CompanyController {
  CompanyController({required this.companyRepository});
  final CompanyRepository companyRepository;

  Future<void> addMedicalEquipment(
      MedicalEquipmentModel medicalEquipment) async {
    await companyRepository.addMedicalEquipmentToCatalogue(medicalEquipment);
  }

  Stream<List<MedicalEquipmentModel>> getMedicalEquipmentCatalogue() {
    return companyRepository.getMedicalEquipmentCatalogue();
  }

  Future<void> updateEquipmentQuantity(
      String equipmentId, int newQuantity) async {
    await companyRepository.updateEquipmentQuantity(equipmentId, newQuantity);
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return companyRepository.getActiveOrders();
  }
}
