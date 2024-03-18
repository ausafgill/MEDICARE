import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/auth/screens/signup_screen.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:medicare/shared/utils/helper_button.dart';

class UserType extends StatefulWidget {
  static const routeName = '/user-type';
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool isselect = false;
  AccountType? selectedAccountType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              child: Center(
                child: Text(
                  "Select Account Type",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: [
              AccountTile(
                type: 'PATIENT ACCOUNT',
                iconData: Icons.person,
                onSelect: () {
                  setState(() {
                    selectedAccountType = AccountType.patient;
                    isselect = true;
                  });
                },
                isSelected: selectedAccountType == AccountType.patient,
              ),
              AccountTile(
                type: 'PHARMACY ACCOUNT',
                iconData: Icons.local_pharmacy,
                onSelect: () {
                  setState(() {
                    selectedAccountType = AccountType.pharmacy;
                    isselect = true;
                  });
                },
                isSelected: selectedAccountType == AccountType.pharmacy,
              ),
              AccountTile(
                type: 'COMPANY ACCOUNT',
                iconData: Icons.corporate_fare,
                onSelect: () {
                  setState(() {
                    selectedAccountType = AccountType.company;
                    isselect = true;
                  });
                },
                isSelected: selectedAccountType == AccountType.company,
              ),
              AccountTile(
                type: 'TRANSPORTER ACCOUNT',
                iconData: Icons.car_crash,
                onSelect: () {
                  setState(() {
                    selectedAccountType = AccountType.transporter;
                    isselect = true;
                  });
                },
                isSelected: selectedAccountType == AccountType.transporter,
              ),
            ],
          ),
          HelperButton(
            name: "CONTINUE",
            onTap: () {
              if (isselect == true) {
                Navigator.pushNamed(
                  context,
                  SignUpScreen.routeName,
                  arguments: [selectedAccountType],
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text("Please Select an Account Type"),
                    );
                  },
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(color: EColors.darkGrey),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: EColors.primaryColor,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String type;
  final IconData iconData;
  final VoidCallback onSelect;
  final bool isSelected;

  const AccountTile({
    super.key,
    required this.type,
    required this.iconData,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: GestureDetector(
        onTap: onSelect,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? EColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: EColors.primaryColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  iconData,
                  color: isSelected ? EColors.white : EColors.primaryColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  type,
                  style: TextStyle(
                      color: isSelected ? Colors.white : EColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
