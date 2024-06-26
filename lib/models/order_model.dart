import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medicine_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String? pharmacyId;
  final String? companyId;
  final String? transporterId;
  final List<MedicineModel>? medicines;
  final List<MedicalEquipmentModel>? medicalEquipments;
  final double price;
  final DateTime orderDate;
  final bool isCompleted;

  OrderModel({
    required this.orderId,
    required this.userId,
    this.pharmacyId,
    this.companyId,
    this.transporterId,
    required this.medicines,
    required this.medicalEquipments,
    required this.orderDate,
    required this.isCompleted,
    required this.price,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<MedicineModel>? medicines;
    if (json['medicines'] != null) {
      medicines = List<MedicineModel>.from(
          json['medicines'].map((model) => MedicineModel.fromJson(model)));
    }
    List<MedicalEquipmentModel>? medicalEquipments;
    if (json['medicalEquipments'] != null) {
      medicalEquipments = List<MedicalEquipmentModel>.from(
          json['medicalEquipments']
              .map((model) => MedicalEquipmentModel.fromJson(model)));
    }
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      pharmacyId: json['pharmacyId'],
      companyId: json['companyId'],
      transporterId: json['transporterId'],
      medicines: medicines,
      medicalEquipments: medicalEquipments,
      orderDate: DateTime.parse(json['orderDate']),
      isCompleted: json['isCompleted'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'pharmacyId': pharmacyId,
      'companyId': companyId,
      'transporterId': transporterId,
      'medicines': medicines?.map((model) => model.toJson()).toList(),
      'medicalEquipments':
          medicalEquipments?.map((model) => model.toJson()).toList(),
      'price': price,
      'orderDate': orderDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
