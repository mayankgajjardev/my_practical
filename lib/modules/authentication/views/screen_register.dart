import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _authService = Get.find<ControllerAuth>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email Required.";
                        }

                        if (!GetUtils.isEmail(value.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20.0),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password Required.";
                        }

                        if (value.trim().length < 6) {
                          return "Password must be at least 6 characters long.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),

                    // Confirm Password
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Confirm password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (_passwordController.text != value &&
                            _passwordController.text.trim().length > 6) {
                          return 'Passwords not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),

                    // Register Button
                    Obx(
                      () => _authService.isSignUpLoading.value
                          ? AppHelper.loader()
                          : ElevatedButton(
                              onPressed: () {
                                AppHelper.dismissKeyboard(context);
                                if (_formKey.currentState!.validate()) {
                                  _authService.registerWithEmailAndPassword(
                                    context,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                              },
                              child: const Text('Register'),
                            ),
                    ),
                    const SizedBox(height: 8.0),

                    // Have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("I have an account?"),
                        TextButton(
                          onPressed: () {
                            AppHelper.dismissKeyboard(context);
                            Get.back();
                          },
                          child: const Text("Click here"),
                        )
                      ],
                    ),
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
