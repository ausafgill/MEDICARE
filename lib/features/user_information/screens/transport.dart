import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/success.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/pick_image.dart';

class TransportInfo extends ConsumerStatefulWidget {
  const TransportInfo({super.key});

  @override
  ConsumerState<TransportInfo> createState() => _TransportInfoState();
}

class _TransportInfoState extends ConsumerState<TransportInfo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ophrsController = TextEditingController();
  final TextEditingController _phonenumController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  File? image;
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ophrsController.dispose();
    _phonenumController.dispose();
    _vehicleController.dispose();
  }

  Future submitInformation() async {
    setState(() {
      isLoading = true;
    });
    if (_key.currentState!.validate() &&
        _nameController.text.trim() != "" &&
        _ophrsController.text.trim() != "" &&
        _vehicleController.text.trim() != "" &&
        image != null) {
      ref.read(profileControllerProvider).setUserProfile(
            userName: _nameController.text.trim(),
            phoneNumber: _phonenumController.text.trim(),
            accountType: AccountType.transporter,
            isAdminApproved: false,
            operatingHours: _ophrsController.text,
            vehicleNumber: _vehicleController.text.trim(),
          );
      await ref.read(profileControllerProvider).uploadNewProfile(image: image);
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
    setState(() {
      isLoading = false;
    });
  }

  Future pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
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
            HelperTextField(
              htxt: "Enter Phone number",
              iconData: Icons.call,
              keyboardType: TextInputType.number,
              controller: _phonenumController,
              validator: (value) {
                if (value.toString().length != 11) {
                  return "Phone Number must be 11 Digits";
                }
                return null;
              },
            ),
            HelperTextField(
              htxt: "Enter Operating Hours",
              iconData: Icons.timer,
              keyboardType: TextInputType.text,
              controller: _ophrsController,
            ),
            HelperTextField(
              htxt: "Enter Vehicle Registration Number",
              iconData: Icons.car_crash,
              keyboardType: TextInputType.text,
              controller: _vehicleController,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                      color: image == null
                          ? Colors.transparent
                          : EColors.primaryColor,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(color: EColors.primaryColor)),
                  child: ListTile(
                    leading: Icon(
                      Icons.upload,
                      color: image == null ? EColors.black : EColors.light,
                    ),
                    title: Text(
                      "Upload Cnic",
                      style: TextStyle(
                        color: image == null ? EColors.black : EColors.light,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            HelperButton(
                name: "Submit", onTap: submitInformation, isLoading: isLoading),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
