import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/profile/controller/controller_profile.dart';
import 'package:flutter_practical/modules/users/views/screen_add_user.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:image_picker/image_picker.dart';

class ScreenProfile extends StatefulWidget {
  final String? uid;
  const ScreenProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final authCtrl = Get.find<ControllerAuth>();
  final profileCtrl = Get.find<ControllerProfile>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: GetX<ControllerAuth>(
          builder: (ctrl) {
            if (ctrl.currentUser != null) {}
            return FutureBuilder<Map<String, dynamic>?>(
              future: profileCtrl.getUserProfileData(widget.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AppHelper.loader(),
                  );
                } else if (snapshot.hasData) {
                  final profileData = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            NetworkImage(profileData['image_path']),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileData['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profileData['mobile_number'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileData['dob'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileData['age'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Edit
                      TextButton(
                        onPressed: () {
                          Get.to(() => ScreenAddUser(
                                uid: profileData['user_id'],
                                age: profileData['age'],
                                dob: profileData['dob'],
                                mobile: profileData['mobile_number'],
                                name: profileData['name'],
                                image: XFile(profileData['image_path']),
                              ));
                        },
                        child: const Text("Edit"),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Error while fetching profile'),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
