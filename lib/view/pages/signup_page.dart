import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/widgets/custom_text_form_field_widget.dart';
import 'package:smile/view/widgets/sign_in_buttom.dart';
import 'package:smile/view_model/auth_view_model.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKy = GlobalKey<FormState>();
  final AuthViewModel authViewModel = AuthViewModel();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset(
                'assets/images/smile_login.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKy,
                child: Column(
                  children: [
                    CustomTextFormFieldWidget(
                        hint: 'Email ',
                        validator: Validator.newEmail,
                        value: email,
                        onSaved: (val) {
                          email=val;
                        },
                        onChange: (val) {
                          email=val;
                        }),
                    SizedBox(height: 16),
                    CustomTextFormFieldWidget(
                        hint: 'PassWord ',
                        isPassword: true,
                        validator: Validator.newPassword,
                        value: password,
                        onSaved: (val) {
                          password =val;
                        },
                        onChange: (val) {
                          password=val;
                        }),
                    SizedBox(height: 16),
                    OutlinedButton(
                        onPressed: () {
                          if (_formKy.currentState != null) {
                            _formKy.currentState!.save();
                            if (_formKy.currentState!.validate()) {
                              AuthViewModel().createUser(
                                  email: email!, password: password!);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [TextButton(onPressed: (){
                        Get.to(SignInPage(), transition: Transition.leftToRightWithFade);
                      }, child: Text('Sing In', style: TextStyle(color:Colors.blue),))],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
                Text("OR"),
                Expanded(
                    child: Divider(
                  thickness: 2,
                ))
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                onPressed: () {
                  authViewModel.signInByGoogle();
                },
                text: 'Sign In by google'.tr,
                imageUrl: 'assets/images/google.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                onPressed: () {
                  authViewModel.signInByFacebook();
                },
                text: 'Sign In by Facebook'.tr,
                imageUrl: 'assets/images/facebook.png',
              ),
            ),
            SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: OutlinedButton(
                        onPressed: () {
                          authViewModel.signInAnonymously();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Skip'.tr),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }
}
