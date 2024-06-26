import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/screens/main_screen.dart';
import 'package:medicare/features/company/screens/main_screen.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/features/pharmacy/screens/main_screen.dart';
import 'package:medicare/features/transporter/screens/main_screen.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/approval_denied.dart';
import 'package:medicare/features/user_information/screens/awaiting_response.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/onboarding/screens/onboarding.dart';
import 'package:medicare/shared/enums/accounts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        ref.read(profileControllerProvider).getProfileFromFirebase();
      } catch (e) {
        Navigator.pushNamed(context, OnboardingScreens.routeName);
      }
    }
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, OnboardingScreens.routeName);
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacementNamed(context, OnboardingScreens.routeName);
        } else {
          final userProfile =
              ref.read(profileControllerProvider).getUserProfile();
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
          } else if (userProfile.userAccountType == AccountType.transporter) {
            Navigator.pushReplacementNamed(
                context, TransporterScreen.routeName);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: EColors.primaryColor,
        image: const DecorationImage(
          image: AssetImage('assets/images/logo.png'),
        ),
      ),
    );
  }
}
