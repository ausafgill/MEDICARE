import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/admin/screens/account_type_list_screen.dart';
import 'package:medicare/features/auth/controller/auth_controller.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/enums/accounts.dart';

class DrawerSetup extends ConsumerStatefulWidget {
  const DrawerSetup({
    super.key,
  });

  @override
  ConsumerState<DrawerSetup> createState() => _DrawerSetupState();
}

class _DrawerSetupState extends ConsumerState<DrawerSetup> {
  Future logout() async {
    await ref.read(authControllerProvider).signOutUser();
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  void initState() {
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
          StreamBuilder<int>(
            stream: ref
                .read(adminControllerProvider)
                .getAccountTypeCount(AccountType.patient),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.front_loader),
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.error),
                  title: Text('Error: ${snapshot.error}'),
                );
              } else {
                final int patientCount = snapshot.data ?? 0;
                return MyDrawerTile(
                  icon: Icons.person,
                  name: "$patientCount PATIENTS",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AccountTypeListScreen.routeName,
                    arguments: [
                      AccountType.patient,
                    ],
                  ),
                );
              }
            },
          ),
          StreamBuilder<int>(
            stream: ref
                .read(adminControllerProvider)
                .getAccountTypeCount(AccountType.pharmacy),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.front_loader),
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.error),
                  title: Text('Error: ${snapshot.error}'),
                );
              } else {
                final int pharmaciesCount = snapshot.data ?? 0;
                return MyDrawerTile(
                  icon: Icons.person,
                  name: "$pharmaciesCount PHARMACIES",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AccountTypeListScreen.routeName,
                    arguments: [
                      AccountType.pharmacy,
                    ],
                  ),
                );
              }
            },
          ),
          StreamBuilder<int>(
            stream: ref
                .read(adminControllerProvider)
                .getAccountTypeCount(AccountType.company),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.front_loader),
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.error),
                  title: Text('Error: ${snapshot.error}'),
                );
              } else {
                final int companyCount = snapshot.data ?? 0;
                return MyDrawerTile(
                  icon: Icons.person,
                  name: "$companyCount COMPANIES",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AccountTypeListScreen.routeName,
                    arguments: [
                      AccountType.company,
                    ],
                  ),
                );
              }
            },
          ),
          StreamBuilder<int>(
            stream: ref
                .read(adminControllerProvider)
                .getAccountTypeCount(AccountType.transporter),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.front_loader),
                  title: Text('Loading...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.error),
                  title: Text('Error: ${snapshot.error}'),
                );
              } else {
                final int transporterCount = snapshot.data ?? 0;
                return MyDrawerTile(
                  icon: Icons.person,
                  name: "$transporterCount TRANSPORTERS",
                  onTap: () => Navigator.pushNamed(
                    context,
                    AccountTypeListScreen.routeName,
                    arguments: [
                      AccountType.transporter,
                    ],
                  ),
                );
              }
            },
          ),
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
