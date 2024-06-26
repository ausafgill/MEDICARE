import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:medicare/features/chats/screens/message_screen.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/patient/screens/add_to_cart.dart';
import 'package:medicare/features/patient/screens/home.dart';
import 'package:medicare/features/patient/screens/order_history.dart';

class PatientScreen extends StatefulWidget {
  static const routeName = '/patient-screen';
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  List pages = [
    const PatientHomeScreen(),
    const CartScreen(),
    const MessageScreen(),
    const OrderHistory(),
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
          FluidNavBarIcon(icon: Icons.home),
          FluidNavBarIcon(icon: Icons.shopping_cart),
          FluidNavBarIcon(icon: Icons.chat),
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
