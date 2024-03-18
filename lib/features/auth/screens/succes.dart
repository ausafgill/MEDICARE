import 'package:flutter/material.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class SuccesScreen extends StatefulWidget {
  const SuccesScreen({super.key});

  @override
  State<SuccesScreen> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends State<SuccesScreen> {
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
            "Success! Your profile has been created. Welcome to the Medicare  community. Let's work together to make managing your health easier than  ever before",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          HelperButton(name: "Continue", onTap: () {})
        ],
      )),
    );
  }
}
