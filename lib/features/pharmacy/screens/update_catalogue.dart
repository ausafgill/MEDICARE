import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/pharmacy/controller/pharmacy_controller.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class UpdatePharmacyCatalogue extends ConsumerStatefulWidget {
  static const routeName = '/update-pharmacy-catalogue';
  const UpdatePharmacyCatalogue({super.key});

  @override
  ConsumerState<UpdatePharmacyCatalogue> createState() =>
      _UpdateCatalogueState();
}

class _UpdateCatalogueState extends ConsumerState<UpdatePharmacyCatalogue> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _advantagesController = TextEditingController();
  final TextEditingController _sideEffectsController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  File? imageFile;

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _medicineNameController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _advantagesController.dispose();
    _sideEffectsController.dispose();
    _usageController.dispose();
  }

  Future pickImage() async {
    imageFile = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<void> addMedicine() async {
    MedicineModel medicine = MedicineModel(
      medicineUid: const Uuid().v4(),
      pharmacyUid: FirebaseAuth.instance.currentUser!.uid,
      pharmacyName:
          ref.read(profileControllerProvider).getUserProfile()!.userName,
      medicineName: _medicineNameController.text,
      price: int.parse(_priceController.text),
      medicineQuantity: int.parse(_quantityController.text),
      description: _descriptionController.text,
      advantages: _advantagesController.text,
      disadvantages: _sideEffectsController.text,
      usageDetail: _usageController.text,
    );
    await ref
        .read(pharmacyControllerProvider)
        .addMedicineToCatalogue(medicine, imageFile!);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPDATE CATALOGUE",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: EColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!) as ImageProvider<Object>?
                            : const AssetImage('assets/images/addimg.png'),
                        radius: 90,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 120,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: EColors.primaryColor,
                              shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: pickImage,
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              HelperTextField(
                htxt: 'Enter Medicine Name',
                iconData: FontAwesomeIcons.prescriptionBottle,
                controller: _medicineNameController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Enter Medicine Price',
                iconData: FontAwesomeIcons.moneyBill,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              HelperTextField(
                htxt: 'Enter Medicine Quantity',
                iconData: FontAwesomeIcons.list,
                controller: _quantityController,
                keyboardType: TextInputType.number,
              ),
              HelperTextField(
                htxt: 'Enter Description',
                iconData: FontAwesomeIcons.file,
                controller: _descriptionController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Medicine Advantages',
                iconData: Icons.add,
                controller: _advantagesController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Side Effects',
                iconData: Icons.remove,
                controller: _sideEffectsController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: "Usage Details",
                iconData: FontAwesomeIcons.file,
                controller: _usageController,
                keyboardType: TextInputType.text,
              ),
              GestureDetector(
                onTap: () {
                  if (_key.currentState!.validate()) {
                    addMedicine();
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
