import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/common/color_value.dart';
import 'package:tmdb/services/firebase_service.dart';
import 'package:tmdb/services/providers/loading_provider.dart';
import 'package:tmdb/ui/bottom_navigation/bottom_navigation.dart';
import 'package:tmdb/ui/home/home.dart';
import 'package:tmdb/widgets/text_form_field/custom_text_form_field.dart';

import '../../../common/navigate.dart';
import '../../../common/shared_code.dart';
import '../../../widgets/loading/loading_animation.dart';
import '../login/login.dart';
import '../reset_password/reset_password.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoadingProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            await SharedCode().setToken('skip', true).then(
                                  (value) => value
                                      ? Navigate.navigatorPushAndRemove(
                                          context, BottomNavigation())
                                      : null,
                                );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Selamat Datang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Masukkan email dan password untuk mendaftar',
                        style: TextStyle(
                          color: Color(0XFF9B9B9B),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomTextFormField(
                        label: 'Masukkan nama',
                        controller: _nameController,
                        validator: (value) =>
                            SharedCode().emptyValidator(value),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: 'Masukkan email',
                        controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) =>
                            SharedCode().emailValidator(value),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: 'Masukkan password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) =>
                            SharedCode().passwordValidator(value),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigate.navigatorPush(context, ResetPassword());
                          },
                          child: Text(
                            'Lupa password?',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            provider.setIsLoad();
                            await FirebaseService()
                                .signUp(
                                  context,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                .then(
                                  (value) => value
                                      ? Navigate.navigatorPushAndRemove(
                                          context, Home())
                                      : null,
                                );
                            provider.setIsLoad();
                          }
                        },
                        child: Text('Daftar'),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Sudah punya akun? ',
                          style: TextStyle(
                            color: ColorValue.greyColor,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: 'Masuk',
                              style: TextStyle(
                                color: ColorValue.secondaryColor,
                                fontSize: 12,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigate.navigatorPush(
                                      context,
                                      const Login(),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: provider.isLoad,
                child: LoadingAnimation(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
