import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/success.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/loading.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/location_selection.dart';
import 'package:medicare/shared/utils/pick_image.dart';

class CompanyInfo extends ConsumerStatefulWidget {
  final AccountType accountType;
  const CompanyInfo({super.key, required this.accountType});

  @override
  ConsumerState<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends ConsumerState<CompanyInfo> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ophrsController = TextEditingController();
  final TextEditingController _phonenumController = TextEditingController();
  File? image;
  bool isLoading = false;
  GeoPoint? point;
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ophrsController.dispose();
    _phonenumController.dispose();
  }

  Future submitInformation() async {
    setState(() {
      isLoading = true;
    });
    if (_key.currentState!.validate() &&
        _nameController.text.trim() != "" &&
        _ophrsController.text.trim() != "" &&
        point != null &&
        image != null) {
      ref.read(profileControllerProvider).setUserProfile(
            userName: _nameController.text.trim(),
            phoneNumber: _phonenumController.text.trim(),
            accountType: widget.accountType,
            isAdminApproved: false,
            operatingHours: _ophrsController.text,
            location: point,
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

  Future getLocation() async {
    point = await getCurrentLocationAndShowMap(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
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
                    keyboardType: TextInputType.phone,
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
                      controller: _ophrsController),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: getLocation,
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                            color: point == null
                                ? Colors.transparent
                                : EColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            border: Border.all(color: EColors.primaryColor)),
                        child: ListTile(
                          leading: const Icon(
                            Icons.map,
                          ),
                          title: Text(
                            point == null
                                ? "Select Location"
                                : "Selected Location",
                            style: TextStyle(
                                color: point == null
                                    ? EColors.black
                                    : EColors.light),
                          ),
                        ),
                      ),
                    ),
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
                            color:
                                image == null ? EColors.black : EColors.light,
                          ),
                          title: Text(
                            "Upload License",
                            style: TextStyle(
                                color: image == null
                                    ? EColors.black
                                    : EColors.light),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  HelperButton(
                    name: "Submit",
                    onTap: submitInformation,
                    isLoading: isLoading,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
  }
}
