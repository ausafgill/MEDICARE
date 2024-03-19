import 'package:medicare/shared/enums/medical_equipment.dart';

class MedicalEquipmentModel {
  final String equipmentUid;
  final String equipmentName;
  final EquipmentType equipmentType;
  final double price;
  final String companyUid;
  final String companyName;
  int quantity;

  MedicalEquipmentModel({
    required this.equipmentUid,
    required this.equipmentName,
    required this.equipmentType,
    required this.price,
    required this.companyUid,
    required this.companyName,
    required this.quantity,
  });

  factory MedicalEquipmentModel.fromJson(Map<String, dynamic> json) {
    return MedicalEquipmentModel(
      equipmentUid: json['equipmentUid'],
      equipmentName: json['equipmentName'],
      equipmentType: EquipmentType.fromString(json['equipmentType']),
      price: json['price'],
      companyUid: json['companyUid'],
      companyName: json['companyName'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipmentUid': equipmentUid,
      'equipmentName': equipmentName,
      'equipmentType': equipmentType.type,
      'price': price,
      'companyUid': companyUid,
      'companyName': companyName,
      'quantity': quantity,
    };
  }
}
