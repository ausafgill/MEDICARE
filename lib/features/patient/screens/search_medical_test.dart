import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:uuid/uuid.dart';

class SearchMedicalTestsScreen extends ConsumerStatefulWidget {
  static const routeName = '/search-medical-test-screen';
  const SearchMedicalTestsScreen({super.key});

  @override
  ConsumerState<SearchMedicalTestsScreen> createState() => _SearchTestState();
}

class _SearchTestState extends ConsumerState<SearchMedicalTestsScreen> {
  final TextEditingController _searchTestController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchTestController.dispose();
  }

  Future requestMedicalTest(MedicalTestRequestModel medicalRequest) async {
    await ref.read(patientControllerProvider).requestMedical(medicalRequest);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH MEDICAL TEST",
            style: Theme.of(context).textTheme.headlineMedium),
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
                hintText: 'Search Medical Tests...',
                fillColor: EColors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MedicalTestModel>>(
              stream: ref
                  .read(patientControllerProvider)
                  .searchMedicalTests(_searchTestController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there's an error
                } else {
                  final List<MedicalTestModel> medicines = snapshot.data ?? [];
                  if (medicines.isEmpty) {
                    return const Center(
                      child: Text('There are no Medical Tests Available'),
                    );
                  }

                  return ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicalTest = medicines[index];
                      return TestItemsTile(
                        medicalTest: medicalTest,
                        medicalRequest: requestMedicalTest,
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

class TestItemsTile extends StatelessWidget {
  final MedicalTestModel medicalTest;
  final Function medicalRequest;
  const TestItemsTile({
    super.key,
    required this.medicalTest,
    required this.medicalRequest,
  });

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
                    medicalTest.medicalTestName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    medicalTest.pharmacyName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        MedicalTestRequestModel request =
                            MedicalTestRequestModel(
                                requestId: const Uuid().v4(),
                                userId: 'xNdsPtmj9Kbc8ez4M1srfJW73a32',
                                pharmacyId: medicalTest.pharmacyId,
                                medicalTest: medicalTest,
                                isAccepted: false,
                                isRejected: false);
                        medicalRequest(request);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: EColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Request Medical",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '\$${medicalTest.price}',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
