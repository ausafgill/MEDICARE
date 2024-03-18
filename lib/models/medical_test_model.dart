class MedicalTestModel {
  final String medicalTestUid;
  final String medicalTestName;
  final double price;
  final String description;
  final String duration;
  final String pharmacyId;
  final String pharmacyName;

  MedicalTestModel({
    required this.medicalTestUid,
    required this.medicalTestName,
    required this.price,
    required this.description,
    required this.duration,
    required this.pharmacyId,
    required this.pharmacyName,
  });

  factory MedicalTestModel.fromJson(Map<String, dynamic> json) {
    return MedicalTestModel(
      medicalTestUid: json['medicalTestUid'],
      medicalTestName: json['medicalTestName'],
      price: json['price'] ?? 0.0,
      description: json['description'] ?? '',
      duration: json['duration'],
      pharmacyId: json['pharmacyId'],
      pharmacyName: json['pharmacyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalTestUid': medicalTestUid,
      'medicalTestName': medicalTestName,
      'price': price,
      'description': description,
      'duration': duration,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
    };
  }
}
