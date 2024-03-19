import 'package:flutter/material.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/shared/constants/colors.dart';

class MedicalTestDetail extends StatefulWidget {
  static const routeName = '/medical-test-details';
  final MedicalTestModel medicalTest;
  const MedicalTestDetail({super.key, required this.medicalTest});

  @override
  State<MedicalTestDetail> createState() => _MedicalTestDetailState();
}

class _MedicalTestDetailState extends State<MedicalTestDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MEDICINE TEST DETAIL",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: EColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.medicalTest.medicalTestName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                'Price: Rs.${widget.medicalTest.price}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Description:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.medicalTest.description,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Duration:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.medicalTest.duration,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
