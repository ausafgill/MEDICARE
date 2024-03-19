import 'package:flutter/material.dart';
import 'package:medicare/features/pharmacy/screens/pharmacy_drawer.dart';

class ApprovalDenied extends StatefulWidget {
  static const routeName = '/approval-denied';
  const ApprovalDenied({super.key});

  @override
  State<ApprovalDenied> createState() => _ApprovalDeniedState();
}

class _ApprovalDeniedState extends State<ApprovalDenied> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      drawer: const PharmacyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/cross.png'))),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Your Profile has been rejected for not complying with our terms and services. Please review our guidelines and make the necessary adjustments to resubmit your profile for approval.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
