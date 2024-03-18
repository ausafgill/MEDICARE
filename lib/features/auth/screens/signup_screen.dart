import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/auth/controller/auth_controller.dart';
import 'package:medicare/features/user_information/screens/info_wrapper.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = '/sign-up-screen';
  const SignUpScreen({super.key, required this.accountType});
  final AccountType accountType;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future registeruser() async {
    try {
      await ref.read(authControllerProvider).creatingUserWithEmailPassword(
          email: _emailController.text, password: _passwordController.text);
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          InfoWrapper.routeName,
          (route) => false,
          arguments: [widget.accountType],
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "SignUp",
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.30,
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
                keyboardType: TextInputType.text,
                iconData: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return "Password must contain at least 6 characters";
                  }
                  return null;
                },
              ),
              HelperTextField(
                obscure: true,
                controller: _confirmPasswordController,
                keyboardType: TextInputType.text,
                htxt: 'Enter Your Password',
                iconData: Icons.lock_outline,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Password and Confirm Password are not same";
                  }
                  if (value == null || value.trim().length < 6) {
                    return "Password must contain at least 6 characters";
                  }
                  return null;
                },
              ),
              HelperButton(
                  name: "Sign Up",
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      await registeruser();
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: EColors.darkGrey),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Log In",
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
      ),
    );
  }
}
