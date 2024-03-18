import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    ref: ref,
    firebase: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  AuthRepository(
      {required this.auth, required this.ref, required this.firebase});

  final FirebaseAuth auth;
  final FirebaseFirestore firebase;
  AuthSignIn? signIn;
  ProviderRef ref;

  Future creatingUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signIn = _CreateUserWithEmailAndPassword(
        auth: auth, email: email, password: password);
    await signIn?.signingIn();
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signIn = _SignInUserWithEmailAndPassword(
        auth: auth, email: email, password: password);
    await signIn?.signingIn();
    try {
      DocumentSnapshot userSnapshot =
          await firebase.collection('users').doc(auth.currentUser!.uid).get();

      UserModel user =
          UserModel.fromMap(userSnapshot.data()! as Map<String, dynamic>);

      ref
          .read(profileControllerProvider)
          .setUserProfileFromModel(userModel: user);
    } catch (e) {
      rethrow;
    }
  }

  Future resetPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future signingOut() async {
    try {
      await auth.signOut();
      //TODO RESET STUFF
    } catch (e) {
      debugPrint('Cannot Sign Out');
    }
  }
}

abstract class AuthSignIn {
  AuthSignIn({
    required this.auth,
  });

  final FirebaseAuth auth;

  Future signingIn();
  Future tryAndCatchBlock(Function function) async {
    try {
      await function();
    } catch (e) {
      rethrow;
    }
  }
}

class _CreateUserWithEmailAndPassword extends AuthSignIn {
  _CreateUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn() async {
    await tryAndCatchBlock(_creatingUser);
  }

  Future _creatingUser() async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}

class _SignInUserWithEmailAndPassword extends AuthSignIn {
  _SignInUserWithEmailAndPassword({
    required super.auth,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Future signingIn() async {
    await tryAndCatchBlock(_signInUser);
  }

  Future _signInUser() async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
