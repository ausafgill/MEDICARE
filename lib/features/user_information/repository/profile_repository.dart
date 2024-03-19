import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/location_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/enums/accounts.dart';
import 'package:uuid/uuid.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ProfileRepository {
  UserModel? userProfile;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRepository({required this.firestore, required this.auth});

  Future getUserProfileFromFirebase() async {
    final doc =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    userProfile = UserModel.fromMap(doc.data()!);
  }

  setUserProfileFromModel({required UserModel userModel}) {
    userProfile = userModel;
  }

  setUserProfile({
    required String userName,
    required String phoneNumber,
    required AccountType accountType,
    required bool isAdminApproved,
    LocationModel? location,
    String? operatingHours,
    String? gender,
    String? dateOfBirth,
    bool? offerMedicalTests,
    String? vehicleNumber,
  }) {
    userProfile = UserModel(
      uid: auth.currentUser!.uid,
      email: auth.currentUser!.email!,
      userName: userName,
      phoneNumber: phoneNumber,
      userAccountType: accountType,
      isAdminApproved: isAdminApproved,
      location: location,
      operatingHours: operatingHours,
      gender: gender,
      dateOfBirth: dateOfBirth,
      offerMedicalTests: offerMedicalTests,
      vehicleNumber: vehicleNumber,
    );
  }

  Future uploadNewProfile(File? image) async {
    try {
      String imageUrl;
      if (userProfile!.userAccountType != AccountType.patient) {
        imageUrl = await uploadImage(image!);
        userProfile!.imageUrl = imageUrl;
      }
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(userProfile!.toJson());

      if (userProfile!.userAccountType == AccountType.patient) {
        await firestore.collection('admin').doc('appdata').update(
          {
            userProfile!.userAccountType.name: FieldValue.increment(1),
          },
        );
      }
      if (userProfile!.userAccountType != AccountType.patient) {
        await firestore.collection('admin').doc('appdata').update({
          'approvals': FieldValue.arrayUnion([auth.currentUser!.uid]),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future uploadImage(File image) async {
    try {
      String imageName =
          const Uuid().v4(); // Generate a UUID for the image file name
      String collection;
      if (userProfile!.userAccountType == AccountType.company ||
          userProfile!.userAccountType == AccountType.pharmacy) {
        collection = 'Licenses';
      } else {
        collection = 'CNIC';
      }
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('$collection/$imageName.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}
