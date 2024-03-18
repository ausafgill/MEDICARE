import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:medicare/features/company/screens/active_detail.dart';
import 'package:medicare/features/company/screens/company_catalogue_screen.dart';
import 'package:medicare/shared/constants/colors.dart';

class CompanyScreen extends StatefulWidget {
  static const routeName = '/company-screen';
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  List pages = [const CompanyCatalogueScreen(), const CompanyActiveOrder()];
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
