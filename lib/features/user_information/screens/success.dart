import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/screens/main_screen.dart';
import 'package:medicare/features/company/screens/main_screen.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/features/pharmacy/screens/main_screen.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/approval_denied.dart';
import 'package:medicare/features/user_information/screens/awaiting_response.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class SuccesScreen extends ConsumerStatefulWidget {
  static const routeName = '/success-profile';
  const SuccesScreen({super.key});

  @override
  ConsumerState<SuccesScreen> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends ConsumerState<SuccesScreen> {
  navigateToScreen() {
    final userProfile = ref.read(profileControllerProvider).getUserProfile();
    if (userProfile!.userAccountType == AccountType.admin) {
      Navigator.pushReplacementNamed(context, AdminScreen.routeName);
    } else if ((userProfile.isDenied == null ||
            userProfile.isDenied == false) &&
        userProfile.isAdminApproved == false) {
      Navigator.pushReplacementNamed(context, AwaitingResponse.routeName);
    } else if (userProfile.isDenied == true) {
      Navigator.pushReplacementNamed(context, ApprovalDenied.routeName);
    } else if (userProfile.userAccountType == AccountType.pharmacy) {
      Navigator.pushReplacementNamed(context, PharmacyScreen.routeName);
    } else if (userProfile.userAccountType == AccountType.company) {
      Navigator.pushReplacementNamed(context, CompanyScreen.routeName);
    } else if (userProfile.userAccountType == AccountType.patient) {
      Navigator.pushReplacementNamed(context, PatientScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Success! Your profile has been created. Welcome to the Medicare  community. Let's work together to make managing your health easier than  ever before",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            HelperButton(
              name: "Continue",
              onTap: () => navigateToScreen(),
            )
          ],
        ),
      ),
    );
  }
}
