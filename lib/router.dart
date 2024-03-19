import 'package:flutter/material.dart';
import 'package:medicare/features/admin/screens/main_screen.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';
import 'package:medicare/features/auth/screens/signup_screen.dart';
import 'package:medicare/features/auth/screens/user_type.dart';
import 'package:medicare/features/company/screens/main_screen.dart';
import 'package:medicare/features/company/screens/medical_equipment_description.dart';
import 'package:medicare/features/company/screens/order_description.dart';
import 'package:medicare/features/company/screens/update_catalogue.dart';
import 'package:medicare/features/onboarding/screens/onboarding.dart';
import 'package:medicare/features/patient/screens/main_screen.dart';
import 'package:medicare/features/patient/screens/search_equipments.dart';
import 'package:medicare/features/patient/screens/search_medical_test.dart';
import 'package:medicare/features/patient/screens/search_medicines.dart';
import 'package:medicare/features/pharmacy/screens/main_screen.dart';
import 'package:medicare/features/pharmacy/screens/medical_test_details.dart';
import 'package:medicare/features/pharmacy/screens/medicine_description.dart';
import 'package:medicare/features/pharmacy/screens/order_detail.dart';
import 'package:medicare/features/pharmacy/screens/update_catalogue.dart';
import 'package:medicare/features/user_information/screens/approval_denied.dart';
import 'package:medicare/features/user_information/screens/awaiting_response.dart';
import 'package:medicare/features/user_information/screens/info_wrapper.dart';
import 'package:medicare/features/user_information/screens/success.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/models/medicine_model.dart';
import 'package:medicare/shared/enums/accounts.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OnboardingScreens.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingScreens(),
      );

    case AwaitingResponse.routeName:
      return MaterialPageRoute(
        builder: (context) => const AwaitingResponse(),
      );
    case ApprovalDenied.routeName:
      return MaterialPageRoute(
        builder: (context) => const ApprovalDenied(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case UserType.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserType(),
      );
    case SignUpScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => SignUpScreen(
          accountType: args[0] as AccountType,
        ),
      );
    case InfoWrapper.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => InfoWrapper(
          accountType: args[0] as AccountType,
        ),
      );
    case SuccesScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SuccesScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AdminScreen(),
      );
    case PharmacyScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const PharmacyScreen(),
      );
    case PatientScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const PatientScreen(),
      );
    case CompanyScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CompanyScreen(),
      );
    case MedicineDescription.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => MedicineDescription(
          medicine: args[0] as MedicineModel,
        ),
      );
    case MedicalTestDetail.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => MedicalTestDetail(
          medicalTest: args[0] as MedicalTestModel,
        ),
      );
    case UpdatePharmacyCatalogue.routeName:
      return MaterialPageRoute(
        builder: (context) => const UpdatePharmacyCatalogue(),
      );
    case PharmacyOrderDetailScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const PharmacyOrderDetailScreen(),
      );
    case CompanyOrderDetailScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CompanyOrderDetailScreen(),
      );
    case CompanyUpdateCatalogue.routeName:
      return MaterialPageRoute(
        builder: (context) => const CompanyUpdateCatalogue(),
      );
    case MedicalEquipmentDescription.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;
      return MaterialPageRoute(
        builder: (context) => MedicalEquipmentDescription(
          medicalEquipment: args[0] as MedicalEquipmentModel,
        ),
      );
    case SearchMedicalTestsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchMedicalTestsScreen(),
      );
    case SearchMedicineScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchMedicineScreen(),
      );
    case SearchMedicalEquipmentsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchMedicalEquipmentsScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('This Page Does not Exist'),
          ),
        ),
      );
  }
}
