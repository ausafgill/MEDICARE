import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medicine_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<String> pharmaciesId;
  final List<String> companyId;
  final List<MedicineModel> medicines;
  final List<MedicalEquipmentModel> medicalEquipments;
  final double price;
  final DateTime orderDate;
  final bool isCompleted;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.pharmaciesId,
    required this.companyId,
    required this.medicines,
    required this.medicalEquipments,
    required this.orderDate,
    required this.isCompleted,
    required this.price,
  });

  // Factory method to create OrderModel from JSON data
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<MedicineModel> medicines = (json['medicines'] as List)
        .map((medicineJson) => MedicineModel.fromJson(medicineJson))
        .toList();
    List<MedicalEquipmentModel> medicalEquipments = (json['medicalEquipments']
            as List)
        .map((equipmentJson) => MedicalEquipmentModel.fromJson(equipmentJson))
        .toList();
    List<String> pharmaciesId = List<String>.from(json['pharmaciesId']);
    List<String> companyId = List<String>.from(json['companyId']);

    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      pharmaciesId: pharmaciesId,
      companyId: companyId,
      medicines: medicines,
      medicalEquipments: medicalEquipments,
      orderDate: DateTime.parse(json['orderDate']),
      isCompleted: json['isCompleted'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> medicineJson =
        medicines.map((medicine) => medicine.toJson()).toList();
    List<Map<String, dynamic>> medicalEquipmentsJson =
        medicalEquipments.map((equipment) => equipment.toJson()).toList();

    return {
      'orderId': orderId,
      'userId': userId,
      'pharmaciesId': pharmaciesId,
      'companyId': companyId,
      'medicines': medicineJson,
      'medicalEquipments': medicalEquipmentsJson,
      'price': price,
      'orderDate': orderDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
