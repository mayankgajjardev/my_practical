import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/users/controller/controller_user.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ScreenAddUser extends StatefulWidget {
  final String? uid;
  final String? name;
  final String? mobile;
  final String? dob;
  final String? age;
  final XFile? image;
  const ScreenAddUser({
    super.key,
    this.name,
    this.mobile,
    this.dob,
    this.age,
    this.image,
    this.uid,
  });

  @override
  State<ScreenAddUser> createState() => _ScreenAddUserState();
}

class _ScreenAddUserState extends State<ScreenAddUser> {
  final authCtrl = Get.find<ControllerAuth>();
  final userCtrl = Get.find<ControllerUser>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (AppHelper.checkEmptyValidation(widget.name ?? '', widget.mobile ?? '',
        widget.dob ?? '', widget.age ?? '', widget.image?.path ?? '')) {
      _nameController.text = widget.name ?? '';
      _mobileController.text = widget.mobile ?? '';
      _dobController.text = widget.dob ?? '';
      _ageController.text = widget.age ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    userCtrl.selectedImage.value = XFile('');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Mayank :: Path :: ${userCtrl.selectedImage.value.path}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        userCtrl.pickImageFromGallery();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Obx(
                            () => userCtrl.selectedImage.value.path.isNotEmpty
                                ? Image.file(
                                    File(userCtrl.selectedImage.value.path),
                                    height: 200.0,
                                    width: 200.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    widget.image?.path ?? '',
                                    height: 200.0,
                                    width: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name Required.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // Mobile Number
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Mobile Number",
                        prefixIcon: Icon(Icons.numbers_rounded),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Mobile Number Required.";
                        }

                        if (value.trim().length != 10) {
                          return "Invalid Mobile Number.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // DOB
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "DOB",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (_dobController.text.isEmpty) {
                          return "Select DoB";
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          _dobController.text = formattedDate;
                        } else {
                          debugPrint("Date is not selected");
                        }
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // Age
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Age",
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Age Required.";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // Add User Button
                    Obx(
                      () => userCtrl.isLoading.value
                          ? AppHelper.loader()
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _dobController.text.isNotEmpty) {
                                  if ((widget.uid ?? '').isEmpty) {
                                    userCtrl.addUserWithImage(
                                      _nameController.text,
                                      _mobileController.text,
                                      _dobController.text,
                                      _ageController.text,
                                      userCtrl.selectedImage.value,
                                    );
                                  } else {
                                    userCtrl.updateUser(
                                      widget.uid ?? '',
                                      _nameController.text,
                                      _mobileController.text,
                                      _dobController.text,
                                      _ageController.text,
                                      userCtrl.selectedImage.value,
                                    );
                                  }
                                }
                              },
                              child: const Text('Add'),
                            ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
