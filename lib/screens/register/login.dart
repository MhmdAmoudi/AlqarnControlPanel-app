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
  final TextEditingController userId = TextEditingController();
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
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: userId,
                      labelText: 'User Id',
                      hintText: 'enter user id',
                      prefixIcon: Icons.person,
                      validator: (val) {
                        if (val!.trim().isEmpty) return 'enter user id';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          controller.login(context, userId.text.trim());
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
