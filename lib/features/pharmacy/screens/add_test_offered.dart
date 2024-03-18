import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/pharmacy/controller/pharmacy_controller.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:uuid/uuid.dart';

class AddTestOffered extends ConsumerStatefulWidget {
  const AddTestOffered({super.key});

  @override
  ConsumerState<AddTestOffered> createState() => _AddTestOfferedState();
}

class _AddTestOfferedState extends ConsumerState<AddTestOffered> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _medicalTestNameController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  addMedicalTest() async {
    final medicalTest = MedicalTestModel(
        medicalTestUid: const Uuid().v4(),
        medicalTestName: _medicalTestNameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        duration: _durationController.text,
        pharmacyId: FirebaseAuth.instance.currentUser!.uid,
        pharmacyName:
            ref.read(profileControllerProvider).getUserProfile()!.userName);
    await ref
        .read(pharmacyControllerProvider)
        .addMedicalTestToCatalogue(medicalTest);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _medicalTestNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD TESTS",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: EColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              HelperTextField(
                htxt: 'Enter Medical Test Name',
                iconData: FontAwesomeIcons.stethoscope,
                controller: _medicalTestNameController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Enter Price',
                iconData: FontAwesomeIcons.moneyBill,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              HelperTextField(
                htxt: 'Enter Description',
                iconData: FontAwesomeIcons.file,
                controller: _descriptionController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Enter Duration',
                iconData: Icons.timer,
                controller: _durationController,
                keyboardType: TextInputType.text,
              ),
              GestureDetector(
                onTap: () {
                  if (_key.currentState!.validate()) {
                    addMedicalTest();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 180,
                  decoration: BoxDecoration(
                    color: EColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
