import 'package:flutter/material.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class SuccesfullySent extends StatefulWidget {
  const SuccesfullySent({super.key});

  @override
  State<SuccesfullySent> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends State<SuccesfullySent> {
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
                    image: AssetImage('assets/images/logo.png'))),
          ),
          const Spacer(),
          Text(
            "Success! A reset email has been sent to your email address",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          HelperButton(
              name: "Continue",
              onTap: () {
                Navigator.pop(context);
              })
        ],
      )),
    );
  }
}
