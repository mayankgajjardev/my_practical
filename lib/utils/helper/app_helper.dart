import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHelper {
  // Dismiss Keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static bool checkEmptyValidation(
    String name,
    String mobile,
    String dob,
    String age,
    String image,
  ) {
    if (name.isEmpty ||
        mobile.isEmpty ||
        dob.isEmpty ||
        age.isEmpty ||
        image.isEmpty) {
      return false;
    }
    return true;
  }

  // Loading Widget
  static loader() {
    return const SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator.adaptive(strokeWidth: 3),
    );
  }

  // Error Dialog
  static errorDialog(BuildContext context, String error) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              CupertinoDialogAction(
                child: const Text("Ok"),
                onPressed: () => Get.back(),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Get.back(),
              ),
            ],
          );
        },
      );
    }
  }
}
