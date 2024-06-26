import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/auth/repository/auth_repository.dart';
import 'package:medicare/features/auth/screens/succesfully_sent.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class ForgotPasswrod extends ConsumerStatefulWidget {
  const ForgotPasswrod({super.key});

  @override
  ConsumerState<ForgotPasswrod> createState() => _ForgotPasswrodState();
}

class _ForgotPasswrodState extends ConsumerState<ForgotPasswrod> {
  final TextEditingController _forgotpassController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _forgotpassController.dispose();
  }

  Future resetPassword() async {
    await ref
        .read(authRepositoryProvider)
        .resetPassword(email: _forgotpassController.text);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccesfullySent(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      'Enter your email, we will send you a confirmation code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: EColors.darkGrey,
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _forgotpassController,
                decoration: const InputDecoration(
                    hintText: 'Enter Your Email',
                    fillColor: EColors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
            ),
            HelperButton(
              name: 'Reset Password',
              onTap: () => resetPassword(),
            ),
          ],
        ),
      ),
    );
  }
}
