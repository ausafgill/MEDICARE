import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/models/feedback_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/drawer.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  static const routeName = '/feedback-screen';
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool isLoading = false;

  Future getApprovalRequests() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(adminControllerProvider).downloadFeedback();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getApprovalRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FEEDBACK',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerSetup(),
      body: Consumer(
        builder: (context, ref, child) {
          final adminController = ref.watch(adminControllerProvider);
          List<FeedbackModel>? feedbackList = adminController.getFeedback();
          if (feedbackList == null) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                FeedbackModel feedback = feedbackList[index];
                return FeedbackTile(
                  uid: feedback.uid,
                  type: feedback.userName,
                  des: feedback.feedback,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FeedbackTile extends ConsumerStatefulWidget {
  final String type;
  final String des;
  final String uid;
  const FeedbackTile(
      {super.key, required this.uid, required this.type, required this.des});

  @override
  ConsumerState<FeedbackTile> createState() => _FeedbackTileState();
}

class _FeedbackTileState extends ConsumerState<FeedbackTile> {
  Future removeUid() async {
    await ref.read(adminControllerProvider).removeFeedback(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff8F9ECA),
          border: Border.all(color: EColors.primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                leading: IconButton(
                  onPressed: removeUid,
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: EColors.white,
                  ),
                ),
                title: const Text(
                  "Feedback Report",
                  style: TextStyle(color: EColors.white, fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Feedback by: ${widget.type}",
                style: const TextStyle(color: EColors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.des,
                style: const TextStyle(color: EColors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
