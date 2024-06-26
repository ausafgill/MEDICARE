import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/user_information/repository/profile_repository.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as point;
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/enums/accounts.dart';

final profileControllerProvider = Provider((ref) {
  ProfileRepository profileRepository = ref.read(profileRepositoryProvider);
  return ProfileController(profileRepository: profileRepository);
});

class ProfileController {
  ProfileRepository profileRepository;
  ProfileController({required this.profileRepository});

  Future getProfileFromFirebase() async {
    await profileRepository.getUserProfileFromFirebase();
  }

  setUserProfile(
      {required String userName,
      required String phoneNumber,
      required AccountType accountType,
      required bool isAdminApproved,
      point.GeoPoint? location,
      String? operatingHours,
      String? gender,
      String? dateOfBirth,
      bool? offerMedicalTests,
      String? vehicleNumber}) {
    profileRepository.setUserProfile(
      userName: userName,
      phoneNumber: phoneNumber,
      accountType: accountType,
      isAdminApproved: isAdminApproved,
      location: location,
      operatingHours: operatingHours,
      gender: gender,
      dateOfBirth: dateOfBirth,
      offerMedicalTests: offerMedicalTests,
      vehicleNumber: vehicleNumber,
    );
  }

  setUserProfileFromModel({required UserModel userModel}) {
    profileRepository.setUserProfileFromModel(userModel: userModel);
  }

  UserModel? getUserProfile() {
    return profileRepository.userProfile;
  }

  getUserType() {
    return profileRepository.userProfile!.userAccountType;
  }

  Future uploadNewProfile({File? image}) async {
    await profileRepository.uploadNewProfile(image);
  }
}
