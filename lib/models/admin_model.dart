class AdminModel {
  int patient;
  int pharmacy;
  int transporter;
  int company;
  List<String> approvals;
  List<String> feedback;

  AdminModel({
    required this.patient,
    required this.pharmacy,
    required this.transporter,
    required this.company,
    required this.approvals,
    required this.feedback,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      patient: map['patient'] ?? 0,
      pharmacy: map['pharmacy'] ?? 0,
      transporter: map['transporter'] ?? 0,
      company: map['company'] ?? 0,
      approvals: List<String>.from(map['approvals'] ?? []),
      feedback: List<String>.from(map['feedbacks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient': patient,
      'pharmacy': pharmacy,
      'transporter': transporter,
      'company': company,
      'approvals': approvals,
      'feedbacks': feedback,
    };
  }
}
