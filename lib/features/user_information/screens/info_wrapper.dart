import 'package:flutter/material.dart';
import 'package:medicare/features/user_information/screens/company_info.dart';
import 'package:medicare/features/user_information/screens/patient_info.dart';
import 'package:medicare/features/user_information/screens/transport.dart';
import 'package:medicare/shared/enums/accounts.dart';

class InfoWrapper extends StatefulWidget {
  static const routeName = '/info-wrapper';
  final AccountType accountType;
  const InfoWrapper({
    super.key,
    required this.accountType,
  });

  @override
  State<InfoWrapper> createState() => _InfoWrapperState();
}

class _InfoWrapperState extends State<InfoWrapper> {
  Widget showInfoScreen() {
    if (widget.accountType == AccountType.patient) {
      return const PatientInfo();
    } else if (widget.accountType == AccountType.company ||
        widget.accountType == AccountType.pharmacy) {
      return CompanyInfo(
        accountType: widget.accountType,
      );
    } else {
      return const TransportInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return showInfoScreen();
  }
}
