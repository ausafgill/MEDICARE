import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/chats/screens/message_screen.dart';
import 'package:medicare/models/admin_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/admin/screens/approval_requests.dart';
import 'package:medicare/features/admin/screens/feedback.dart';
import 'package:medicare/features/admin/screens/users_list.dart';
import 'package:medicare/shared/loading.dart';

class AdminScreen extends ConsumerStatefulWidget {
  static const routeName = '/admin-screen';
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  List pages = [
    const ApprovalRequest(),
    const UsersListScreen(),
    const MessageScreen(),
    const FeedbackScreen(),
  ];
  int currIndex = 0;
  AdminModel? adminInfo;
  bool loading = true;

  Future getAdminInfo() async {
    setState(() {
      loading = true;
    });
    await ref.read(adminControllerProvider).downloadAdminInfo();
    adminInfo = ref.read(adminControllerProvider).getAdminInfo();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getAdminInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FluidNavBar(
        onChange: (int index) {
          setState(
            () {
              currIndex = index;
            },
          );
        },
        icons: [
          FluidNavBarIcon(icon: Icons.timer),
          FluidNavBarIcon(icon: Icons.person_3),
          FluidNavBarIcon(icon: Icons.chat),
          FluidNavBarIcon(icon: Icons.feedback)
        ],
        style: FluidNavBarStyle(
          barBackgroundColor: EColors.primaryColor,
          iconBackgroundColor: EColors.white,
          iconSelectedForegroundColor: const Color.fromARGB(255, 244, 19, 3),
        ),
      ),
      body: loading ? const LoadingScreen() : pages[currIndex],
    );
  }
}
