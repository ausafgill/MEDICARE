import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/patient_drawer.dart';
import 'package:medicare/features/patient/services/cart_service.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/loading.dart';
import 'package:medicare/shared/utils/snack_bar.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool isLoading = false;
  addMedicineQuantity(MedicineModel medicine) {
    ref.read(cartServiceProvider).addMedicineQuantity(medicine);
    setState(() {});
  }

  removeMedicineQuantity(MedicineModel medicine) {
    ref.read(cartServiceProvider).removeMedicineQuantity(medicine);
    setState(() {});
  }

  addMedicalEquipmentQuantity(MedicalEquipmentModel medicine) {
    ref.read(cartServiceProvider).addMedicalEquipmentQuantity(medicine);
    setState(() {});
  }

  removeMedicalEquipmentQuantity(MedicalEquipmentModel medicine) {
    ref.read(cartServiceProvider).removeMedicalEquipmentQuantity(medicine);
    setState(() {});
  }

  Future checkOut() async {
    if (ref.read(cartServiceProvider).medicineCart.isEmpty &&
        ref.read(cartServiceProvider).medicalEquipmentCart.isEmpty) {
      showSnackBar(context: context, content: 'Carts are empty');
    } else {
      setState(() {
        isLoading = true;
      });
      List<String> pharmaciesId =
          ref.read(cartServiceProvider).getPharmaciesId();
      List<String> companiesId = ref.read(cartServiceProvider).getCompaniesId();
      final OrderModel order = OrderModel(
        orderId: const Uuid().v4(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        pharmaciesId: pharmaciesId,
        companyId: companiesId,
        medicines: ref.read(cartServiceProvider).medicineCart,
        medicalEquipments: ref.read(cartServiceProvider).medicalEquipmentCart,
        orderDate: DateTime.now(),
        isCompleted: false,
        price: ref.read(cartServiceProvider).getTotalPrice(),
      );
      await ref.read(patientControllerProvider).uploadOrderToFirebase(order);
      ref.read(cartServiceProvider).clearMedicineCart();
      ref.read(cartServiceProvider).clearMedicalEquipmentCart();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text("CART",
                  style: Theme.of(context).textTheme.headlineMedium),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            drawer: const PatientDrawer(),
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Medicines',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ref.read(cartServiceProvider).medicineCart.isEmpty
                      ? const Center(child: Text('Medicine Cart Empty'))
                      : ListView.builder(
                          itemCount:
                              ref.read(cartServiceProvider).medicineCart.length,
                          itemBuilder: (context, index) {
                            final medicine = ref
                                .read(cartServiceProvider)
                                .medicineCart[index];
                            return CartMedicineTile(
                              addQuantity: addMedicineQuantity,
                              removeQuantity: removeMedicineQuantity,
                              medicine: medicine,
                            );
                          },
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Medical Equipments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ref
                          .read(cartServiceProvider)
                          .medicalEquipmentCart
                          .isEmpty
                      ? const Center(
                          child: Text('Medical Equipment Cart Empty'))
                      : ListView.builder(
                          itemCount: ref
                              .read(cartServiceProvider)
                              .medicalEquipmentCart
                              .length,
                          itemBuilder: (context, index) {
                            final medicalEquipment = ref
                                .read(cartServiceProvider)
                                .medicalEquipmentCart[index];
                            return CartMedicalEquipmentTile(
                              medicalEquipment: medicalEquipment,
                              addQuantity: addMedicalEquipmentQuantity,
                              removeQuantity: removeMedicalEquipmentQuantity,
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL",
                            style: TextStyle(color: EColors.primaryColor),
                          ),
                          Text(
                            '\$${ref.read(cartServiceProvider).getTotalPrice().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: checkOut,
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                              color: EColors.primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Center(
                              child: Text(
                                "Checkout",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class CartMedicineTile extends StatelessWidget {
  const CartMedicineTile({
    super.key,
    required this.medicine,
    required this.addQuantity,
    required this.removeQuantity,
  });
  final MedicineModel medicine;
  final Function addQuantity;
  final Function removeQuantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 207, 204, 204),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.network(
                medicine.imageUrl!,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine.medicineName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => removeQuantity(medicine),
                    icon: Icon(
                      Icons.remove,
                      color: EColors.primaryColor,
                    ),
                  ),
                  Text(
                    medicine.medicineQuantity.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => addQuantity(medicine),
                    icon: Icon(
                      Icons.add,
                      color: EColors.primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          trailing: Text(
            "\$${(medicine.price * medicine.medicineQuantity).toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}

class CartMedicalEquipmentTile extends StatelessWidget {
  const CartMedicalEquipmentTile({
    super.key,
    required this.medicalEquipment,
    required this.addQuantity,
    required this.removeQuantity,
  });
  final MedicalEquipmentModel medicalEquipment;
  final Function addQuantity;
  final Function removeQuantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicalEquipment.equipmentName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => removeQuantity(medicalEquipment),
                      icon: Icon(
                        Icons.remove,
                        color: EColors.primaryColor,
                      ),
                    ),
                    Text(
                      medicalEquipment.quantity.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () => addQuantity(medicalEquipment),
                      icon: Icon(
                        Icons.add,
                        color: EColors.primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            trailing: Text(
              "\$${(medicalEquipment.price * medicalEquipment.quantity).toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}
