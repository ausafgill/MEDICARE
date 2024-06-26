import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:medicare/shared/enums/accounts.dart';

class UserModel {
  final String uid;
  String email;
  final String userName;
  String phoneNumber;
  final AccountType userAccountType;
  final bool isAdminApproved;
  final GeoPoint? location;
  final String? operatingHours;
  String? gender;
  final String? dateOfBirth;
  final bool? offerMedicalTests;
  String? vehicleNumber;
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
      location:
          map['location'] != null ? GeoPoint.fromMap(map['location']) : null,
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
      'location': location?.toMap(),
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
