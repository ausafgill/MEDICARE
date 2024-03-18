import 'package:flutter/material.dart';
import 'package:medicare/features/pharmacy/screens/pharmacy_drawer.dart';

class AwaitingResponse extends StatefulWidget {
  static const routeName = '/awaiting-response';
  const AwaitingResponse({super.key});

  @override
  State<AwaitingResponse> createState() => _AwaitingResponseState();
}

class _AwaitingResponseState extends State<AwaitingResponse> {
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
                      image: AssetImage('assets/images/timer.png'))),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Thank you for registering with Medicare! Your account is now pending  admin approval. We'll notify you as soon as your profile is approved and  ready for use",
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
