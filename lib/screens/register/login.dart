import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:manage/screens/register/controller/login_controller.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:sizer/sizer.dart';

import '../../utilities/appearance/style.dart';
import '../../widgets/custom_textfield.dart';

class Login extends StatefulWidget {
  const Login({this.isUnAuthorizedReset = false, Key? key}) : super(key: key);
  final bool isUnAuthorizedReset;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController controller = LoginController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.isUnAuthorizedReset) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.unauthorizedResetAlert();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'asset/images/main_logo.png',
              height: 15.h,
            ),
            SizedBox(height: 1.h),
            GradientText(
              'LOGIN',
              style: TextStyle(fontSize: 5.h),
              colors: const [
                Colors.lightBlueAccent,
                Colors.blue,
                AppColors.mainColor,
              ],
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextFormField(
                        controller: username,
                        labelText: 'Username',
                        hintText: 'enter username id',
                        prefixIcon: Icons.person,
                        validator: (val) {
                          if (val!.trim().isEmpty) return 'enter username';
                          return null;
                        },
                      ),
                    ),
                    CustomTextFormField(
                      controller: password,
                      labelText: 'Password',
                      hintText: 'enter password',
                      prefixIcon: Icons.password_rounded,
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty) return 'enter password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          controller.login(
                            context,
                            username.text.trim(),
                            password.text,
                          );
                        }
                      },
                      child: const Text('Login'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
