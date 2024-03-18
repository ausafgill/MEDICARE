import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/pharmacy/screens/pharmacy_catalogue_screen.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/pharmacy/screens/active_order.dart';
import 'package:medicare/features/pharmacy/screens/medical_test.dart';

class PharmacyScreen extends StatefulWidget {
  static const routeName = '/pharmacy-screen';
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  List pages = [
    const PharmacyCatalougueScreen(),
    const MedicalTestScreen(),
    const PharmacyActiveOrder()
  ];
  int currIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FluidNavBar(
        onChange: (int index) {
          setState(() {
            currIndex = index;
          });
        },
        icons: [
          FluidNavBarIcon(icon: Icons.shopping_cart),
          FluidNavBarIcon(icon: FontAwesomeIcons.stethoscope),
          FluidNavBarIcon(icon: Icons.list)
        ],
        style: FluidNavBarStyle(
            barBackgroundColor: EColors.primaryColor,
            iconBackgroundColor: EColors.white,
            iconSelectedForegroundColor: const Color.fromARGB(255, 244, 19, 3)),
      ),
      body: pages[currIndex],
    );
  }
}
