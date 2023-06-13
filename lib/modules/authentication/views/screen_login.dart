import 'package:flutter/material.dart';
import 'package:flutter_practical/modules/authentication/controller/controller_auth.dart';
import 'package:flutter_practical/modules/authentication/views/screen_register.dart';
import 'package:flutter_practical/utils/helper/app_helper.dart';
import 'package:get/get.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _authService = Get.find<ControllerAuth>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      "Login",
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

                    // Register Button
                    Obx(
                      () => _authService.isSignInLoading.value
                          ? AppHelper.loader()
                          : ElevatedButton(
                              onPressed: () {
                                AppHelper.dismissKeyboard(context);
                                if (_formKey.currentState!.validate()) {
                                  _authService.signInWithEmailAndPassword(
                                    context,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                              },
                              child: const Text('Login'),
                            ),
                    ),
                    const SizedBox(height: 8.0),

                    // Have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("I don't have an account?"),
                        TextButton(
                          onPressed: () {
                            AppHelper.dismissKeyboard(context);
                            Get.to(() => const ScreenRegister());
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
