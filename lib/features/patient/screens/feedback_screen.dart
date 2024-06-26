import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/models/feedback_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:uuid/uuid.dart';

class AddFeedbackScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-feedback-screen';
  const AddFeedbackScreen({super.key});

  @override
  ConsumerState<AddFeedbackScreen> createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends ConsumerState<AddFeedbackScreen> {
  TextEditingController _feedbackController = TextEditingController();

  Future storeFeedback() async {
    String feedbackUid = const Uuid().v4();
    FeedbackModel feedback = FeedbackModel(
        userName:
            ref.read(profileControllerProvider).getUserProfile()!.userName,
        uid: feedbackUid,
        feedback: _feedbackController.text.trim(),
        isValid: true);
    await ref
        .read(patientControllerProvider)
        .storeFeedback(feedback, feedbackUid);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADD FEEDBACK',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: EColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "We would to hear from your side....",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _feedbackController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Add feedback',
                fillColor: EColors.white,
                filled: true,
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: storeFeedback,
              child: const Text(
                'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
