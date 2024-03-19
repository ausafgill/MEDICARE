import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/repository/admin_repository.dart';
import 'package:medicare/models/admin_model.dart';
import 'package:medicare/models/user_model.dart';

final adminControllerProvider = ChangeNotifierProvider((ref) {
  final adminRepository = ref.read(adminRepositoryProvider);
  return AdminController(adminRepository: adminRepository);
});

class AdminController with ChangeNotifier {
  final AdminRepository adminRepository;

  AdminController({required this.adminRepository});

  Stream<List<UserModel>> searchUser({required String query}) {
    return adminRepository.searchUser(query);
  }

  Future<void> downloadFeedback() async {
    try {
      await adminRepository.getFeedbackFromUIDs();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFeedback({required String uid}) async {
    try {
      await adminRepository.removeFeedback(uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  getFeedback() {
    return adminRepository.feedbacksList;
  }

  Future<void> downloadAdminInfo() async {
    try {
      await adminRepository.downloadInfo();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectUser({required String uid}) async {
    try {
      await adminRepository.rejectUser(uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptUser({required String uid}) async {
    try {
      await adminRepository.acceptUser(uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUserInApprovalList() async {
    try {
      await adminRepository.getUsersInApprovalList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  getApprovalRequests() {
    return adminRepository.getApprovalRequests();
  }

  getPharmacyCount() {
    return adminRepository.adminInfo!.pharmacy;
  }

  getPatientCount() {
    return adminRepository.adminInfo!.patient;
  }

  getCompanyCount() {
    return adminRepository.adminInfo!.company;
  }

  getTransporterCount() {
    return adminRepository.adminInfo!.transporter;
  }

  AdminModel? getAdminInfo() {
    return adminRepository.getAdminInfo();
  }
}
