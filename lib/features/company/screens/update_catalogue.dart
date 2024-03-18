import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/company/controller/company_controller.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/enums/medical_equipment.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';
import 'package:uuid/uuid.dart';

class CompanyUpdateCatalogue extends ConsumerStatefulWidget {
  static const routeName = '/company-update-catalogue';
  const CompanyUpdateCatalogue({super.key});

  @override
  ConsumerState<CompanyUpdateCatalogue> createState() =>
      _UpdateCatalogueState();
}

class _UpdateCatalogueState extends ConsumerState<CompanyUpdateCatalogue> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool isTypeSelected = false;
  String? typeValue;

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _medicineNameController.dispose();
    _quantityController.dispose();
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        isTypeSelected = true;
        typeValue = newValue;
      });
    }
  }

  Future<void> addMedicine() async {
    if (isTypeSelected == true) {
      MedicalEquipmentModel medicalEquipment = MedicalEquipmentModel(
        equipmentUid: const Uuid().v4(),
        companyUid: FirebaseAuth.instance.currentUser!.uid,
        companyName:
            ref.read(profileControllerProvider).getUserProfile()!.userName,
        equipmentName: _medicineNameController.text,
        price: double.parse(_priceController.text),
        equipmentType: typeValue == 'Doctor'
            ? EquipmentType.doctor
            : EquipmentType.patient,
        quantity: int.parse(_quantityController.text),
      );
      await ref
          .read(companyControllerProvider)
          .addMedicalEquipment(medicalEquipment);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      showSnackBar(context: context, content: 'Please Fill All Fields');
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
              const SizedBox(height: 20),
              HelperTextField(
                htxt: 'Enter Equipment Name',
                iconData: FontAwesomeIcons.prescriptionBottle,
                controller: _medicineNameController,
                keyboardType: TextInputType.text,
              ),
              HelperTextField(
                htxt: 'Enter Equipment Price',
                iconData: FontAwesomeIcons.moneyBill,
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              HelperTextField(
                htxt: 'Enter Equipment Quantity',
                iconData: FontAwesomeIcons.list,
                controller: _quantityController,
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: isTypeSelected
                        ? EColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(color: EColors.primaryColor),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      iconEnabledColor:
                          isTypeSelected ? EColors.light : EColors.black,
                      isExpanded: true,
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(20.0),
                      hint: Center(
                        child: Text(
                          typeValue ?? "Select Type",
                          style: TextStyle(
                            color:
                                isTypeSelected ? EColors.light : EColors.black,
                          ),
                        ),
                      ),
                      focusColor: EColors.primaryColor,
                      onChanged: _onDropdownChanged,
                      items: <String>[
                        'Patient',
                        'Doctor',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
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
