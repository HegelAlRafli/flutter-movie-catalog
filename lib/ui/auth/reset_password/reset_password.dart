import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/services/providers/loading_provider.dart';
import 'package:tmdb/ui/auth/login/login.dart';

import '../../../common/color_value.dart';
import '../../../common/navigate.dart';
import '../../../common/shared_code.dart';
import '../../../services/firebase_service.dart';
import '../../../widgets/loading/loading_animation.dart';
import '../../../widgets/text_form_field/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoadingProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 180,
                          height: 180,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Reset Password',
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
                          'Masukkan email untuk reset password',
                          style: TextStyle(
                            color: Color(0XFF9B9B9B),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CustomTextFormField(
                          label: 'Masukkan email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) =>
                              SharedCode().emailValidator(value),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              provider.setIsLoad();
                              await FirebaseService()
                                  .resetPassword(
                                    context,
                                    email: _emailController.text,
                                  )
                                  .then(
                                    (value) => value
                                        ? Navigate.navigatorPushAndRemove(
                                            context, Login())
                                        : null,
                                  );
                              provider.setIsLoad();
                            }
                          },
                          child: Text('Reset Password'),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Kembali ke ',
                            style: TextStyle(
                              color: ColorValue.greyColor,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
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
              ),
            ),
            Visibility(
              visible: provider.isLoad,
              child: LoadingAnimation(),
            ),
          ],
        ),
      ),
    );
  }
}
