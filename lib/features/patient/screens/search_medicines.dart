import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/services/cart_service.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';

class SearchMedicineScreen extends ConsumerStatefulWidget {
  static const routeName = '/search-medicine-screen';
  const SearchMedicineScreen({super.key});

  @override
  ConsumerState<SearchMedicineScreen> createState() => _SearchMedicineState();
}

class _SearchMedicineState extends ConsumerState<SearchMedicineScreen> {
  final TextEditingController _searchMedicineController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchMedicineController.dispose();
  }

  addToMedicineCart(MedicineModel medicine) {
    ref.read(cartServiceProvider).addToMedicineCart(medicine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH MEDICINE",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchMedicineController,
              onChanged: (query) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Search Medicines...',
                fillColor: EColors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MedicineModel>>(
              stream: ref
                  .read(patientControllerProvider)
                  .searchMedicines(_searchMedicineController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there's an error
                } else {
                  final List<MedicineModel> medicines = snapshot.data ?? [];
                  if (medicines.isEmpty) {
                    return const Center(
                      child: Text('There are no Medicines Available'),
                    );
                  }

                  return ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      return CartItemsTile(
                        medicine: medicine,
                        addToCart: addToMedicineCart,
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class CartItemsTile extends StatelessWidget {
  CartItemsTile({
    super.key,
    required this.medicine,
    required this.addToCart,
  });
  final MedicineModel medicine;
  final Function addToCart;
  final TextEditingController _controller = TextEditingController();

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 125,
                width: 125,
                child: Image.network(medicine.imageUrl!),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.medicineName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Quantity : ${medicine.medicineQuantity}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    medicine.pharmacyName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add Quantity"),
                              content: HelperTextField(
                                iconData: Icons.add,
                                keyboardType: TextInputType.number,
                                controller: _controller,
                                htxt: 'Enter Ammount',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (int.parse(_controller.text) >
                                        medicine.medicineQuantity) {
                                      showSnackBar(
                                          context: context,
                                          content:
                                              'Quantity Cannot be more than available Quantity');
                                    } else {
                                      MedicineModel orderedMedicine = medicine;
                                      orderedMedicine.medicineQuantity =
                                          int.parse(_controller.text);
                                      addToCart(orderedMedicine);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Save"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: EColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '\$${medicine.price}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
