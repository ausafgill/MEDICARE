class AdminModel {
  List<String> approvals;
  List<String> feedback;

  AdminModel({
    required this.approvals,
    required this.feedback,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      approvals: List<String>.from(map['approvals'] ?? []),
      feedback: List<String>.from(map['feedbacks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approvals': approvals,
      'feedbacks': feedback,
    };
  }
}
