class FeedbackModel {
  final String userName;
  final String uid;
  final String feedback;

  FeedbackModel({
    required this.userName,
    required this.uid,
    required this.feedback,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      userName: map['userName'] ?? '',
      uid: map['uid'] ?? '',
      feedback: map['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uid': uid,
      'feedback': feedback,
    };
  }
}
