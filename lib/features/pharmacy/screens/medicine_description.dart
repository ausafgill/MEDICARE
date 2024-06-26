import 'package:flutter/material.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/shared/constants/colors.dart';

class MedicineDescription extends StatefulWidget {
  static const routeName = '/medicine-description';
  final MedicineModel medicine;
  const MedicineDescription({
    super.key,
    required this.medicine,
  });

  @override
  State<MedicineDescription> createState() => _MedicineDescriptionState();
}

class _MedicineDescriptionState extends State<MedicineDescription> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.medicine.imageUrl!),
                  backgroundColor: Colors.white,
                  radius: 90,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.medicine.medicineName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                'Price: Rs.${widget.medicine.price}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Medicines Available: ${widget.medicine.medicineQuantity}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "Description:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8),
              child: Text(
                widget.medicine.description,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'ADVANTAGES:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                //   color: EColors.softGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Text(
                    widget.medicine.advantages,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'DISADVANTAGES:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                //   color: EColors.softGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: Text(
                    widget.medicine.disadvantages,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: Text(
                "Usage Details:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Text(
                widget.medicine.usageDetail,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
