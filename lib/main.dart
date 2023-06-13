import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical/firebase_options.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/authentication/views/screen_login.dart';
import 'package:flutter_practical/modules/profile/controller/controller_profile.dart';
import 'package:flutter_practical/modules/users/views/screen_users.dart';
import 'package:flutter_practical/utils/helper/app_binding.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ControllerAuth());
  Get.put(ControllerProfile());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = Get.find<ControllerAuth>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: UsersBinding(),
      title: 'Flutter Practical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: auth.currentUser?.email == null
          ? const ScreenLogin()
          : const ScreenUsers(),
    );
  }
}
