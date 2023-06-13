import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class ControllerProfile extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authCtrl = Get.find<ControllerAuth>();

  Map<String, dynamic> getUserById(List users, String id) {
    return users.firstWhere((user) => user['user_id'] == id, orElse: () => {});
  }

  // Get User Profile Data
  Future<Map<String, dynamic>?> getUserProfileData(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(AppConstans.usersCollection).get();
      var users = snapshot.docs.map((doc) => doc.data()).toList();

      return getUserById(users, userId);
    } catch (e) {
      debugPrint("Mayank :: GetUserProfileData :: Error ::  ${e.toString()}");
      return null;
    }
  }
}
