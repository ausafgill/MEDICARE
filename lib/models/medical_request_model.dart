import 'package:medicare/models/medical_test_model.dart';

class MedicalTestRequestModel {
  final String requestId;
  final String userId;
  final String pharmacyId;
  final MedicalTestModel medicalTest;
  final bool isAccepted;
  final bool isRejected;

  // Nullable DateTime field
  final DateTime? requestDate;

  MedicalTestRequestModel({
    required this.requestId,
    required this.userId,
    required this.pharmacyId,
    required this.medicalTest,
    required this.isAccepted,
    required this.isRejected,
    this.requestDate, // Nullable DateTime field
  });

  // Factory method to create MedicalTestRequestModel from JSON data
  factory MedicalTestRequestModel.fromJson(Map<String, dynamic> json) {
    return MedicalTestRequestModel(
      requestId: json['requestId'],
      userId: json['userId'],
      pharmacyId: json['pharmacyId'],
      medicalTest: MedicalTestModel.fromJson(json['medicalTest']),
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : null,
      isAccepted: json['isAccepted'],
      isRejected: json['isRejected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'userId': userId,
      'pharmacyId': pharmacyId,
      'medicalTest': medicalTest.toJson(), // Convert MedicalTestModel to JSON
      'requestDate':
          requestDate?.toIso8601String(), // Convert nullable DateTime to string
      'isAccepted': isAccepted,
      'isRejected': isRejected,
    };
  }
}
