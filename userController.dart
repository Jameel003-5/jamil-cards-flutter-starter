import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jamil_web/user_model.dart';

class UserController extends GetxController {
  final CollectionReference<Map<String, dynamic>> usersCollection =
  FirebaseFirestore.instance.collection('users'); // Replace with your collection name

  final Rx<UserModel> userModel = UserModel().obs;



  Future<void> fetchUserData(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await usersCollection.doc(userId).get();
      if (snapshot.exists) {
        print("User data: ${snapshot.data()}");
        final UserModel userData = UserModel.fromJson(snapshot.data());
        userModel.value = userData;
        userModel.value.links = userModel.value.links!.where((element) => element['isShown'] == true).toList();
        print("Username: ${userModel.value.userName}");
        update();
        notifyChildrens();
      }
    } catch (error) {
      // Handle any potential errors
      print('Error fetching user data: $error');
    }
  }

  Future<void> fetchAllUsers() async {
    try {
      final QuerySnapshot snapshot = await usersCollection.get();
      final List<UserModel> userList = snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
      userModel.value = userList as UserModel;
    } catch (error) {
      print('Failed to fetch all users: $error');
    }
  }


}

///
// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:q_tap_web/user_model.dart';
//
// class UserController extends GetxController {
//   final CollectionReference<Map<String, dynamic>> usersCollection =
//   FirebaseFirestore.instance.collection('users'); // Replace with your collection name
//
//   final Rx<UserModel> userModel = UserModel().obs;
//
//   Future<void> fetchUserDataFromUrl() async {
//     try {
//       final String currentUrl = window.location.href;
//       final Uri uri = Uri.parse(currentUrl);
//       final String uid = uri.queryParameters['uid']!;
//
//       if (uid != null) {
//         final DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await usersCollection.doc(uid).get();
//         if (snapshot.exists) {
//           final UserModel userData = UserModel.fromJson(snapshot.data());
//           userModel.value = userData;
//         }
//       }
//     } catch (error) {
//       // Handle any potential errors
//       print('Error fetching user data: $error');
//     }
//   }
//
// // Rest of your code...
// }
