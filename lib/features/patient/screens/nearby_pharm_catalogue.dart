import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/search_medical_test.dart';
import 'package:medicare/features/patient/screens/search_medicines.dart';
import 'package:medicare/features/patient/services/cart_service.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:uuid/uuid.dart';

class NearbyPharmacy extends ConsumerStatefulWidget {
  static const routeName = '/nearby-pharmacy';
  const NearbyPharmacy({
    super.key,
    required this.pharmacy,
  });
  final UserModel pharmacy;

  @override
  ConsumerState<NearbyPharmacy> createState() => _NearbyPharmacyState();
}

class _NearbyPharmacyState extends ConsumerState<NearbyPharmacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Catalogue",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(widget.pharmacy.userName,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 25,
            ),
            Text("Available Medicines Medicines:",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<MedicineModel>>(
                stream: ref
                    .read(patientControllerProvider)
                    .getPharmacyCatalogue(widget.pharmacy.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MedicineModel> cartItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final medicine = cartItems[index];
                        return CartItemsTile(
                          medicine: medicine,
                          addToCart: (medicine) {
                            ref
                                .read(cartServiceProvider)
                                .addToMedicineCart(medicine);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text("Available Medical Tests:",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.3,
              // width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<MedicalTestModel>>(
                stream: ref
                    .read(patientControllerProvider)
                    .getPharmacyMedicalTests(widget.pharmacy.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MedicalTestModel> cartItems = snapshot.data!;
                    return ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final medicine = cartItems[index];
                        return TestItemsTile(
                          medicalTest: medicine,
                          medicalRequest: () {
                            final medicalTest = MedicalTestRequestModel(
                                requestId: const Uuid().v4(),
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                pharmacyId: medicine.pharmacyId,
                                medicalTest: medicine,
                                isAccepted: false,
                                isRejected: false);
                            ref
                                .read(patientControllerProvider)
                                .requestMedical(medicalTest);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
