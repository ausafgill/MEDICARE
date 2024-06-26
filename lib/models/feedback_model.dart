class FeedbackModel {
  final String userName;
  final String uid;
  final String feedback;
  final bool isValid;

  FeedbackModel({
    required this.userName,
    required this.uid,
    required this.feedback,
    required this.isValid,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      userName: map['userName'] ?? '',
      uid: map['uid'] ?? '',
      feedback: map['feedback'] ?? '',
      isValid: map['isValid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uid': uid,
      'feedback': feedback,
      'isValid': isValid,
    };
  }
}

