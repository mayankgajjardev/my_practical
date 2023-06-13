import 'package:flutter_practical/modules/pdf/controller/controller_pdf.dart';
import 'package:flutter_practical/modules/profile/controller/controller_profile.dart';
import 'package:flutter_practical/modules/users/controller/controller_user.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ControllerProfile>(ControllerProfile());
  }
}

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ControllerUser>(ControllerUser());
  }
}

class PdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ControllerPdf>(ControllerPdf());
  }
}
