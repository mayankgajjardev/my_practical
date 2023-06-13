import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/views/screen_login.dart';
import 'package:flutter_practical/modules/users/views/screen_users.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';

class ControllerAuth extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _currentUser = Rxn<User>();
  var isSignInLoading = false.obs;
  var isSignUpLoading = false.obs;

  // get current User
  User? get currentUser => _currentUser.value;

  @override
  void onClose() {
    super.onClose();
    debugPrint("Badhuy Puru.............");
  }

  @override
  void onInit() {
    _currentUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  // Login with Email and Password
  Future<void> registerWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    isSignUpLoading(true);

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      isSignUpLoading(false);
      Get.back();
    } catch (e) {
      AppHelper.errorDialog(context, e.toString());
      debugPrint("Mayank :: Login Error :: ${e.toString()}");
      isSignUpLoading(false);
    }
  }

  // Sign In With Email and Password
  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    isSignInLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isSignInLoading(false);
      Get.offAll(() => const ScreenUsers());
    } catch (e) {
      AppHelper.errorDialog(context, e.toString());
      debugPrint("Mayank :: Register Error :: ${e.toString()}");
      isSignInLoading(false);
    }
  }

  // SignOut
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => const ScreenLogin());
  }
}
