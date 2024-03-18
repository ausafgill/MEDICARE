class MedicineModel {
  String? imageUrl;
  final String medicineUid;
  final String pharmacyUid;
  final String pharmacyName;
  int price;
  final String medicineName;
  int medicineQuantity;
  final String description;
  final String advantages;
  final String disadvantages;
  final String usageDetail;

  MedicineModel({
    this.imageUrl,
    required this.pharmacyUid,
    required this.pharmacyName,
    required this.price,
    required this.medicineUid,
    required this.medicineName,
    required this.medicineQuantity,
    required this.description,
    required this.advantages,
    required this.disadvantages,
    required this.usageDetail,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      imageUrl: json['imageUrl'] ?? '',
      pharmacyUid: json['pharmacyUid'] ?? '',
      pharmacyName: json['pharmacyName'] ?? '',
      price: json['price'] ?? 0,
      medicineUid: json['uid'] ?? '',
      medicineName: json['medicineName'] ?? '',
      medicineQuantity: json['medicineQuantity'] ?? 0,
      description: json['description'] ?? '',
      advantages: json['advantages'] ?? '',
      disadvantages: json['disadvantages'] ?? '',
      usageDetail: json['usageDetail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': medicineUid,
      'imageUrl': imageUrl,
      'pharmacyUid': pharmacyUid,
      'pharmacyName': pharmacyName,
      'price': price,
      'medicineName': medicineName,
      'medicineQuantity': medicineQuantity,
      'description': description,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'usageDetail': usageDetail,
    };
  }
}
