import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/auth/controller/auth_controller.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/drawer.dart';

class TransporterDrawer extends ConsumerStatefulWidget {
  const TransporterDrawer({super.key});

  @override
  ConsumerState<TransporterDrawer> createState() => _TransporterDrawerState();
}

class _TransporterDrawerState extends ConsumerState<TransporterDrawer> {
  Future logout() async {
    await ref.read(authControllerProvider).signOutUser();
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
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
                'TRANSPORTER PANEL',
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
          MyDrawerTile(icon: Icons.logout, name: 'LOGOUT', onTap: logout),
        ],
      ),
    );
  }
}
