import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/auth/controller/auth_controller.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';
import 'package:medicare/shared/constants/colors.dart';

class DrawerSetup extends ConsumerStatefulWidget {
  const DrawerSetup({
    super.key,
  });

  @override
  ConsumerState<DrawerSetup> createState() => _DrawerSetupState();
}

class _DrawerSetupState extends ConsumerState<DrawerSetup> {
  late int pharmaCount;
  late int patientCount;
  late int companyCount;
  late int transporterCount;
  Future logout() async {
    await ref.read(authControllerProvider).signOutUser();
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  void initState() {
    pharmaCount = ref.read(adminControllerProvider).getPharmacyCount();
    patientCount = ref.read(adminControllerProvider).getPatientCount();
    companyCount = ref.read(adminControllerProvider).getCompanyCount();
    transporterCount = ref.read(adminControllerProvider).getTransporterCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: EColors.primaryColor),
            child: const Center(
              child: Text(
                'ADMIN PANEL',
                style: TextStyle(color: EColors.white, fontSize: 20),
              ),
            ),
          ),
          MyDrawerTile(
              icon: Icons.home,
              name: 'Home',
              onTap: () {
                Navigator.pop(context);
              }),
          MyDrawerTile(
              icon: Icons.person, name: "$patientCount PATIENTS", onTap: () {}),
          MyDrawerTile(
              icon: Icons.local_pharmacy_rounded,
              name: "$pharmaCount PHARMACIES",
              onTap: () {}),
          MyDrawerTile(
              icon: Icons.corporate_fare,
              name: "$companyCount COMPANIES",
              onTap: () {}),
          MyDrawerTile(
              icon: Icons.emoji_transportation,
              name: "$transporterCount TRANSPORTERS",
              onTap: () {}),
          MyDrawerTile(icon: Icons.logout, name: 'LOGOUT', onTap: logout),
        ],
      ),
    );
  }
}

class MyDrawerTile extends StatefulWidget {
  final IconData icon;
  final String name;
  final void Function()? onTap;
  const MyDrawerTile(
      {super.key, required this.icon, required this.name, required this.onTap});

  @override
  State<MyDrawerTile> createState() => _MyDrawerTileState();
}

class _MyDrawerTileState extends State<MyDrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: EColors.primaryColor,
          ),
          title: InkWell(
            onTap: widget.onTap,
            child: Text(
              widget.name,
              style: TextStyle(color: EColors.primaryColor, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
