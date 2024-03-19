import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/success.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class PatientInfo extends ConsumerStatefulWidget {
  const PatientInfo({super.key});

  @override
  ConsumerState<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends ConsumerState<PatientInfo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phonenumController = TextEditingController();
  bool isGenderSelected = false;
  String? genderValue;
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _phonenumController.dispose();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Correct function signature for onChanged
  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        isGenderSelected = true;
        genderValue = newValue;
      });
    }
  }

  Future submitInformation() async {
    if (_key.currentState!.validate() &&
        _nameController.text.trim() != "" &&
        _dateController.text.trim() != "" &&
        isGenderSelected) {
      ref.read(profileControllerProvider).setUserProfile(
          userName: _nameController.text.trim(),
          phoneNumber: _phonenumController.text.trim(),
          accountType: AccountType.patient,
          isAdminApproved: true,
          gender: genderValue,
          dateOfBirth: _dateController.text);
      await ref.read(profileControllerProvider).uploadNewProfile();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, SuccesScreen.routeName);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Please Fill All The Fields In Correct Format"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Get Started"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Center(
                child: Text(
                  "Complete Your Profile",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            HelperTextField(
                htxt: 'Enter Your Name',
                iconData: Icons.person,
                keyboardType: TextInputType.text,
                controller: _nameController),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                decoration: const InputDecoration(
                    hintText: "Select DOB",
                    fillColor: EColors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_month_outlined)),
              ),
            ),
            HelperTextField(
              htxt: "Enter Phone number",
              keyboardType: TextInputType.phone,
              iconData: Icons.call,
              controller: _phonenumController,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: isGenderSelected
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
                        isGenderSelected ? EColors.light : EColors.black,
                    isExpanded: true,
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(20.0),
                    hint: Center(
                      child: Text(
                        genderValue ?? "Select Gender",
                        style: TextStyle(
                          color:
                              isGenderSelected ? EColors.light : EColors.black,
                        ),
                      ),
                    ),
                    focusColor: EColors.primaryColor,
                    onChanged: _onDropdownChanged,
                    items: <String>[
                      'Male',
                      'Female',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(color: EColors.primaryColor)),
                child: const ListTile(
                  leading: Icon(
                    Icons.map,
                  ),
                  title: Text(
                    "Select Location",
                    style: TextStyle(color: EColors.black),
                  ),
                ),
              ),
            ),
            const Spacer(),
            HelperButton(
              name: "Submit",
              onTap: submitInformation,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
