import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/chats/screens/message_screen.dart';
import 'package:medicare/features/transporter/screens/available_orders.dart';
import 'package:medicare/features/transporter/screens/active_orders.dart';
import 'package:medicare/shared/constants/colors.dart';

class TransporterScreen extends StatefulWidget {
  static const routeName = '/transporter-screen';
  const TransporterScreen({super.key});

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  List pages = [
    const AvailableOrder(),
    const MessageScreen(),
    const ActiveOrders()
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
          FluidNavBarIcon(icon: FontAwesomeIcons.car),
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
