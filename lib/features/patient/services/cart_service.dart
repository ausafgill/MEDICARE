import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/medical_equipement_model.dart';
import 'package:medicare/models/medicine_model.dart';

final cartServiceProvider = Provider((ref) => CartService());

class CartService {
  List<MedicalEquipmentModel> _medicalEquipmentCart = [];
  List<MedicineModel> _medicineCart = [];

  List<MedicineModel> get medicineCart => _medicineCart;
  List<MedicalEquipmentModel> get medicalEquipmentCart => _medicalEquipmentCart;

  void addToMedicineCart(MedicineModel medicine) {
    _medicineCart.add(medicine);
  }

  void addToMedicalEquipmentCart(MedicalEquipmentModel medicalEquipment) {
    _medicalEquipmentCart.add(medicalEquipment);
  }

  void addMedicineQuantity(MedicineModel medicine) {
    for (var i = 0; i < _medicineCart.length; i++) {
      if (medicineCart[i].medicineUid == medicine.medicineUid) {
        medicineCart[i].medicineQuantity++;
        break;
      }
    }
  }

  List<String> getPharmaciesId() {
    List<String> pharmacies = [];
    for (var i = 0; i < _medicineCart.length; i++) {
      pharmacies.add(_medicineCart[i].pharmacyUid);
    }
    return pharmacies;
  }

  List<String> getCompaniesId() {
    List<String> companies = [];
    for (var i = 0; i < _medicalEquipmentCart.length; i++) {
      companies.add(_medicalEquipmentCart[i].companyUid);
    }
    return companies;
  }

  void removeMedicineQuantity(MedicineModel medicine) {
    for (var i = 0; i < _medicineCart.length; i++) {
      if (_medicineCart[i].medicineUid == medicine.medicineUid) {
        _medicineCart[i].medicineQuantity--;
        if (_medicineCart[i].medicineQuantity == 0) {
          removeFromMedicineCart(medicine);
        }
        break;
      }
    }
  }

  void addMedicalEquipmentQuantity(MedicalEquipmentModel medicalEquipment) {
    for (var i = 0; i < _medicalEquipmentCart.length; i++) {
      if (_medicalEquipmentCart[i].equipmentUid ==
          medicalEquipment.equipmentUid) {
        _medicalEquipmentCart[i].quantity++;
        break;
      }
    }
  }

  void removeMedicalEquipmentQuantity(MedicalEquipmentModel medicalEquipment) {
    for (var i = 0; i < _medicalEquipmentCart.length; i++) {
      if (_medicalEquipmentCart[i].equipmentUid ==
          medicalEquipment.equipmentUid) {
        _medicalEquipmentCart[i].quantity--;
        if (_medicalEquipmentCart[i].quantity == 0) {
          removeFromMedicalEquipmentCart(medicalEquipment);
        }

        break;
      }
    }
  }

  double getTotalPrice() {
    double price = 0;

    _medicalEquipmentCart.forEach((equipment) {
      price += (equipment.price * equipment.quantity);
    });
    _medicineCart.forEach((medicine) {
      price += (medicine.price * medicine.medicineQuantity);
    });
    return price;
  }

  void removeFromMedicineCart(MedicineModel medicine) {
    _medicineCart.remove(medicine);
  }

  void removeFromMedicalEquipmentCart(MedicalEquipmentModel medicalEquipment) {
    _medicalEquipmentCart.remove(medicalEquipment);
  }

  void clearMedicalEquipmentCart() {
    _medicalEquipmentCart.clear();
  }

  void clearMedicineCart() {
    _medicineCart.clear();
  }
}
