import 'package:medicare/models/location_model.dart';
import 'package:medicare/shared/enums/accounts.dart';

class UserModel {
  final String uid;
  final String email;
  final String userName;
  final String phoneNumber;
  final AccountType userAccountType;
  final bool isAdminApproved;
  final LocationModel? location;
  final String? operatingHours;
  final String? gender;
  final String? dateOfBirth;
  final bool? offerMedicalTests;
  final String? vehicleNumber;
  final bool? isDenied;
  String? imageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.userAccountType,
    required this.isAdminApproved,
    this.isDenied,
    this.vehicleNumber,
    this.location,
    this.operatingHours,
    this.gender,
    this.dateOfBirth,
    this.offerMedicalTests,
    this.imageUrl,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      phoneNumber: map['phoneNumber'],
      userAccountType: AccountType.fromString(map['userAccountType']),
      isAdminApproved: map['isAdminApproved'],
      isDenied: map['isDenied'],
      vehicleNumber: map['vehicleNumber'],
      // Add location parsing if needed
      operatingHours: map['operatingHours'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      offerMedicalTests: map['offerMedicalTests'],
      imageUrl: map['imageUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'userAccountType': userAccountType.name,
      'isAdminApproved': isAdminApproved,
      //TODO Add location
      'operatingHours': operatingHours,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'offerMedicalTests': offerMedicalTests,
      'vehicleNumber': vehicleNumber,
      'isDenied': isDenied,
      'imageUrl': imageUrl,
    };
  }
}
