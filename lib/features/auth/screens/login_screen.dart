import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/screens/main_screen.dart';
import 'package:medicare/features/auth/controller/auth_controller.dart';
import 'package:medicare/features/company/screens/main_screen.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/features/pharmacy/screens/main_screen.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/awaiting_response.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/auth/screens/forgot_pass.dart';
import 'package:medicare/features/auth/screens/user_type.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future loginUser() async {
    try {
      await ref.read(authControllerProvider).signingInUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (context.mounted) {
        AccountType accountType =
            ref.read(profileControllerProvider).getUserType();
        final profile = ref.read(profileControllerProvider).getUserProfile();
        if (accountType == AccountType.admin) {
          Navigator.pushReplacementNamed(context, AdminScreen.routeName);
        } else if (accountType == AccountType.patient) {
          Navigator.pushReplacementNamed(context, PatientScreen.routeName);
        } else if (accountType == AccountType.pharmacy) {
          if (profile!.isAdminApproved == false) {
            Navigator.pushReplacementNamed(context, AwaitingResponse.routeName);
          } else {
            Navigator.pushReplacementNamed(context, PharmacyScreen.routeName);
          }
        } else if (accountType == AccountType.company) {
          if (profile!.isAdminApproved == false) {
            Navigator.pushReplacementNamed(context, AwaitingResponse.routeName);
          } else {
            Navigator.pushReplacementNamed(context, CompanyScreen.routeName);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Login",
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
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
            HelperTextField(
              controller: _emailController,
              htxt: 'Enter Your Email',
              iconData: Icons.email_outlined,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@') ||
                    !value.contains('.')) {
                  return "Please enter a valid Email address";
                }
                return null;
              },
            ),
            HelperTextField(
              controller: _passwordController,
              obscure: true,
              htxt: 'Enter Your Password',
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return "Password must contain at least 6 characters";
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswrod(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(color: EColors.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            HelperButton(
              name: "Login",
              onTap: () {
                if (_key.currentState!.validate()) {
                  loginUser();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dont have an account?",
                  style: TextStyle(color: EColors.darkGrey),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, UserType.routeName);
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: EColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
