import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/pdf/views/screen_pdf.dart';
import 'package:flutter_practical/modules/profile/views/screen_profile.dart';
import 'package:flutter_practical/modules/users/controller/controller_user.dart';
import 'package:flutter_practical/modules/users/views/screen_add_user.dart';
import 'package:flutter_practical/utils/helper/app_binding.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';

class ScreenUsers extends StatefulWidget {
  const ScreenUsers({super.key});

  @override
  State<ScreenUsers> createState() => _ScreenUsersState();
}

class _ScreenUsersState extends State<ScreenUsers> {
  final userCtrl = Get.find<ControllerUser>();
  final authCtrl = Get.find<ControllerAuth>();

  @override
  void initState() {
    super.initState();
    userCtrl.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authCtrl.signOut();
            },
            icon: const Icon(
              Icons.login_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const ScreenPdf(), binding: PdfBinding());
            },
            icon: const Icon(
              Icons.picture_as_pdf,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => userCtrl.isFetchLoading.value
                  ? Center(child: AppHelper.loader())
                  : userCtrl.users.isEmpty
                      ? const Center(
                          child: Text("No User"),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await userCtrl.fetchUsers();
                          },
                          child: ListView.separated(
                            itemCount: userCtrl.users.length,
                            itemBuilder: (context, int i) {
                              debugPrint(
                                  "Mayank :: User :: ${userCtrl.users[i]}");
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userCtrl.users[i]['image_path']),
                                ),
                                title: Text(userCtrl.users[i]['name']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Mo. :- ${userCtrl.users[i]['mobile_number']}"),
                                    Text("DoB :- ${userCtrl.users[i]['dob']}"),
                                    Text("Age :- ${userCtrl.users[i]['age']}"),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(
                                    () => ScreenProfile(
                                        uid: userCtrl.users[i]['user_id']),
                                    binding: ProfileBinding(),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                          ),
                        ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const ScreenAddUser());
            },
            child: const Text("Add User"),
          )
        ],
      ),
    );
  }
}
