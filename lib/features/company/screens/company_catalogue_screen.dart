import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/company/controller/company_controller.dart';
import 'package:medicare/features/company/screens/company_drawer.dart';
import 'package:medicare/features/company/screens/medical_equipment_description.dart';
import 'package:medicare/features/company/screens/update_catalogue.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class CompanyCatalogueScreen extends ConsumerStatefulWidget {
  const CompanyCatalogueScreen({super.key});

  @override
  ConsumerState<CompanyCatalogueScreen> createState() =>
      _CatalougueScreenState();
}

class _CatalougueScreenState extends ConsumerState<CompanyCatalogueScreen> {
  Future updateQuantity(String medicineId, int newQuantity) async {
    await ref
        .read(companyControllerProvider)
        .updateEquipmentQuantity(medicineId, newQuantity);
    if (context.mounted) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CATALOGUE",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const CompanyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            StreamBuilder<List<MedicalEquipmentModel>>(
              stream: ref
                  .read(companyControllerProvider)
                  .getMedicalEquipmentCatalogue(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final medicines = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      return CatalogueTile(
                        medicalEquipment: medicine,
                        updateQuantity: updateQuantity,
                      );
                    },
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CompanyUpdateCatalogue.routeName,
                );
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: EColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      "Update Catalogue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogueTile extends StatefulWidget {
  final MedicalEquipmentModel medicalEquipment;
  final Function updateQuantity;

  const CatalogueTile({
    super.key,
    required this.medicalEquipment,
    required this.updateQuantity,
  });

  @override
  State<CatalogueTile> createState() => _CatalogueTileState();
}

class _CatalogueTileState extends State<CatalogueTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            MedicalEquipmentDescription.routeName,
            arguments: [widget.medicalEquipment],
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: EColors.softGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medicalEquipment.equipmentName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Quantitiy: ${widget.medicalEquipment.quantity}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add Quantity"),
                          content: HelperTextField(
                            controller: _quantityController,
                            htxt: 'Enter Quantity',
                            iconData: Icons.add,
                            keyboardType: TextInputType.number,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => widget.updateQuantity(
                                  widget.medicalEquipment.equipmentUid,
                                  int.parse(_quantityController.text) +
                                      widget.medicalEquipment.quantity),
                              child: const Text("Save"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: EColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
