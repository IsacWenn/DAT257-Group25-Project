import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthapp/backend/user/firebase_user.dart';
import 'package:healthapp/caffeine_detailed_view.dart';
import 'package:healthapp/services/auth/auth/firebase_auth_provider.dart';
import 'dart:math' as math;

import 'package:healthapp/util/weatherPreferences.dart';

class UserRepository {
final FirebaseAuthProvider provider;
  final CollectionReference instance;

  UserRepository()
      : provider = FirebaseAuthProvider(),
        instance = FirebaseFirestore.instance.collection('Users');

  Future<bool> hasFirstAndLastName() async {
    FirebaseUser? user = await getCurrentUser();
    if (user == null) {
      return false;
    } else {
      return user.firstName.isNotEmpty && user.lastName.isNotEmpty;
    }
  }

  Future<void> addUser(String firstName, String lastName) async {
    final currentUserId = provider.currentUser?.id;
    await instance.doc(currentUserId).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': provider.currentUser?.email,
      'id': currentUserId,
    });
  }

  Future<FirebaseUser?> getCurrentUser() async {

    final currentUserId = provider.currentUser?.id;

    final snapshot = await instance.where('id', isEqualTo: currentUserId).get();

    if (snapshot.docs.isNotEmpty) {
      final Map<String, dynamic> data =
          snapshot.docs.first.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        return FirebaseUser.fromMap(data);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

class FirebaseUser {
  final String firstName;
  final String lastName;
  final String email;
  final String initals;

  FirebaseUser(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.initals});

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      firstName: map['firstName'] ?? "",
      lastName: map['lastName'] ?? "",
      email: map['email'] ?? "",
      initals: map['firstName'][0] + map['lastName'][0],
    );
  }

  @override
  String toString() {
    return 'FirebaseUser{firstName: $firstName, lastName: $lastName, email: $email, initals: $initals}';
  }
}
