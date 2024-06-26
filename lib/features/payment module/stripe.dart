import 'package:flutter/material.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';

class StripeModule extends StatefulWidget {
  const StripeModule({super.key});

  @override
  State<StripeModule> createState() => _StripeModuleState();
}

class _StripeModuleState extends State<StripeModule> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _mmController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _cardController.dispose();
    _mmController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/stirpe.png',
          height: 60,
          width: 60,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Add Your Payment Information',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            HelperTextField(
                htxt: 'Card Number',
                iconData: Icons.credit_card,
                controller: _cardController,
                keyboardType: TextInputType.number),
            Row(
              children: [
                Expanded(
                    child: HelperTextField(
                        htxt: 'MM/YY',
                        iconData: Icons.credit_card,
                        controller: _mmController,
                        keyboardType: TextInputType.name)),
                Expanded(
                    child: HelperTextField(
                        htxt: 'CVC',
                        iconData: Icons.credit_card,
                        controller: _cvcController,
                        keyboardType: TextInputType.number))
              ],
            ),
            HelperButton(
              name: 'Pay',
              onTap: () {
                if (_cardController.text == '4242424242424242') {
                  showSnackBar(context: context, content: 'Paid Successfully');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PatientScreen()));
                }
              },
              color: Colors.deepPurple,
            )
          ],
        ),
      ),
    );
  }
}
