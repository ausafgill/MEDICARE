import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/features/patient/services/cart_service.dart';

import 'package:medicare/features/payment%20module/stripe.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/confirm_order.dart';
import 'package:medicare/features/patient/screens/patient_drawer.dart';
import 'package:medicare/features/patient/services/cart_service.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/loading.dart';
import 'package:medicare/shared/utils/helper_button.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';
import 'package:uuid/uuid.dart';

class ConfirmOrder extends ConsumerStatefulWidget {
  final String price;
  const ConfirmOrder({super.key, required this.price});

  @override
  ConsumerState<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends ConsumerState<ConfirmOrder> {
  String choice = '';
  bool isLoading = false;
  Future checkOut() async {
    if (ref.read(cartServiceProvider).medicineCart.isEmpty &&
        ref.read(cartServiceProvider).medicalEquipmentCart.isEmpty) {
      showSnackBar(context: context, content: 'Carts are empty');
    } else {
      setState(() {
        isLoading = true;
      });
      final List<MedicineModel> medicineCart =
          ref.read(cartServiceProvider).medicineCart;
      final List<MedicalEquipmentModel> medicalEquipmentCart =
          ref.read(cartServiceProvider).medicalEquipmentCart;

      final Map<String, List<MedicineModel>> groupedMedicines = {};
      final Map<String, List<MedicalEquipmentModel>> groupedMedicalEquipments =
          {};

      for (final medicine in medicineCart) {
        final companyId = medicine.pharmacyUid;
        if (!groupedMedicines.containsKey(companyId)) {
          groupedMedicines[companyId] = [];
        }
        medicine.price = medicine.price * medicine.medicineQuantity;
        groupedMedicines[companyId]!.add(medicine);
      }

      for (final equipment in medicalEquipmentCart) {
        final pharmacyId = equipment.companyUid;
        if (!groupedMedicalEquipments.containsKey(pharmacyId)) {
          groupedMedicalEquipments[pharmacyId] = [];
        }
        equipment.price = equipment.price * equipment.quantity;
        groupedMedicalEquipments[pharmacyId]!.add(equipment);
      }

      final List<OrderModel> orders = [];

      groupedMedicines.forEach((pharmacyId, medicines) {
        final order = OrderModel(
          orderId: const Uuid().v4(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          pharmacyId: pharmacyId,
          medicines: medicines,
          medicalEquipments: [],
          orderDate: DateTime.now(),
          isCompleted: false,
          price: medicines.fold<double>(
              0, (prev, medicine) => prev + medicine.price),
        );
        orders.add(order);
      });

      groupedMedicalEquipments.forEach((companyId, equipments) {
        final order = OrderModel(
          orderId: const Uuid().v4(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          companyId: companyId,
          medicines: [],
          medicalEquipments: equipments,
          orderDate: DateTime.now(),
          isCompleted: false,
          price: equipments.fold<double>(
              0, (prev, equipment) => prev + equipment.price),
        );
        orders.add(order);
      });

      for (final order in orders) {
        await ref.read(patientControllerProvider).uploadOrderToFirebase(order);
      }

      ref.read(cartServiceProvider).clearMedicineCart();
      ref.read(cartServiceProvider).clearMedicalEquipmentCart();
      setState(() {
        isLoading = false;
      });
    }
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? paymentValue;
  bool ispaymentSelected = false;
  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        ispaymentSelected = true;
        paymentValue = newValue;
        choice = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text("CHECKOUT",
                  style: Theme.of(context).textTheme.headlineMedium),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelperTextField(
                        htxt: 'Enter Name',
                        iconData: Icons.person,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                      ),
                      HelperTextField(
                        htxt: 'Enter Contact NUmber',
                        iconData: Icons.numbers,
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a contact number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Deliver to:',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      HelperTextField(
                        htxt: 'Address',
                        iconData: Icons.home,
                        controller: _addressController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: ispaymentSelected
                                ? EColors.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            border: Border.all(color: EColors.primaryColor),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              iconEnabledColor: ispaymentSelected
                                  ? EColors.light
                                  : EColors.black,
                              isExpanded: true,
                              underline: const SizedBox(),
                              borderRadius: BorderRadius.circular(20.0),
                              hint: Center(
                                child: Text(
                                  paymentValue ?? "Select Payment Method",
                                  style: TextStyle(
                                    color: ispaymentSelected
                                        ? EColors.light
                                        : EColors.black,
                                  ),
                                ),
                              ),
                              focusColor: EColors.primaryColor,
                              onChanged: _onDropdownChanged,
                              items: <String>[
                                'Stripe',
                                'Cash On Delivery'
                              ].map<DropdownMenuItem<String>>((String value) {
                                //choice = value;
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                Text(
                                  '${widget.price} RS',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                )
                              ],
                            ),
                            HelperButton(
                                name: 'CONFIRM',
                                onTap: () async {
                                  if (_key.currentState!.validate()) {
                                    // await PaymentFunction()
                                    //     .makePayment(context);
                                    await checkOut();
                                    if (choice == 'Stripe') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StripeModule()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientScreen()));
                                      showSnackBar(
                                          context: context,
                                          content: 'Order Placed');
                                    }
                                  }
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
