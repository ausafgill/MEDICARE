import 'package:flutter/material.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/shared/constants/colors.dart';

class MedicalEquipmentDescription extends StatefulWidget {
  static const routeName = '/medical-equipment-description';
  final MedicalEquipmentModel medicalEquipment;
  const MedicalEquipmentDescription({
    super.key,
    required this.medicalEquipment,
  });

  @override
  State<MedicalEquipmentDescription> createState() =>
      _MedicineDescriptionState();
}

class _MedicineDescriptionState extends State<MedicalEquipmentDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("MEDICINE DETAIL",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: EColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.medicalEquipment.equipmentName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                'Price: \$${widget.medicalEquipment.price}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Equipments Available : ${widget.medicalEquipment.quantity}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Equipments Type : ${widget.medicalEquipment.equipmentType.name}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
