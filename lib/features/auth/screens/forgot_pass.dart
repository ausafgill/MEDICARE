import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class ForgotPasswrod extends StatefulWidget {
  const ForgotPasswrod({super.key});

  @override
  State<ForgotPasswrod> createState() => _ForgotPasswrodState();
}

class _ForgotPasswrodState extends State<ForgotPasswrod> {
  final TextEditingController _forgotpassController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _forgotpassController;
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
                    "Forgot Passwrod",
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
            HelperButton(name: 'Reset Passwrod', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
