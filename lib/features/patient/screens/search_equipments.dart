import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/services/cart_service.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';
import 'package:medicare/shared/utils/snack_bar.dart';

class SearchMedicalEquipmentsScreen extends ConsumerStatefulWidget {
  static const routeName = '/search-medical-equipment-screen';
  const SearchMedicalEquipmentsScreen({super.key});

  @override
  ConsumerState<SearchMedicalEquipmentsScreen> createState() =>
      _SearchTestState();
}

class _SearchTestState extends ConsumerState<SearchMedicalEquipmentsScreen> {
  final TextEditingController _searchEquipmentController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchEquipmentController.dispose();
  }

  addToMedicalEquipmentCart(MedicalEquipmentModel medicalEquipment) {
    ref.read(cartServiceProvider).addToMedicalEquipmentCart(medicalEquipment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH MEDICAL EQUIPMENTS",
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchTestController,
              onChanged: (query) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Search Medical Equipments...',
                fillColor: EColors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MedicalEquipmentModel>>(
              stream: ref
                  .read(patientControllerProvider)
                  .searchMedicalEquipments(_searchTestController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there's an error
                } else {
                  final List<MedicalEquipmentModel> medicalEquipments =
                      snapshot.data ?? [];
                  if (medicalEquipments.isEmpty) {
                    return const Center(
                      child: Text('There are no Medical Equipments Available'),
                    );
                  }

                  return ListView.builder(
                    itemCount: medicalEquipments.length,
                    itemBuilder: (context, index) {
                      final medicalEquipment = medicalEquipments[index];
                      return EquimentsItemsTile(
                        medicalEquipment: medicalEquipment,
                        addToCart: addToMedicalEquipmentCart,
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

class EquimentsItemsTile extends StatelessWidget {
  final MedicalEquipmentModel medicalEquipment;
  final Function addToCart;
  EquimentsItemsTile(
      {super.key, required this.medicalEquipment, required this.addToCart});
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicalEquipment.equipmentName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    medicalEquipment.companyName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Quantity : ${medicalEquipment.quantity}',
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
                                htxt: 'Add Ammount',
                                iconData: Icons.add,
                                controller: _controller,
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (int.parse(_controller.text) >
                                        medicalEquipment.quantity) {
                                      showSnackBar(
                                          context: context,
                                          content:
                                              'Quantity Cannot be more than available Quantity');
                                    } else {
                                      MedicalEquipmentModel
                                          orderedMedicalEquipment =
                                          medicalEquipment;
                                      orderedMedicalEquipment.quantity =
                                          int.parse(_controller.text);
                                      addToCart(orderedMedicalEquipment);
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
                '\$${medicalEquipment.price}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}

final TextEditingController _searchTestController = TextEditingController();
