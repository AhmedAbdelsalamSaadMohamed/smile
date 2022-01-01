import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';

import 'complete_social_sign_up.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We Send You Verify Message',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Image.asset('assets/images/wait.png'),
              SizedBox(height: 16),
              Text(
                'Please go to your Email ${widget.user.email} and verify this email. ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Expanded(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(height: 16),
                  Text('Waiting for Verify'),
                ],
              ))),
            ],
          ),
        ));
  }

  @override
  void initState() {
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        print('gggggggggggggggggggggggggggggggggggggggggggggggggggggg');
        await FirebaseAuth.instance.currentUser!
          ..reload().then((_) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              print('verify');
              _timer.cancel();
              Get.to(CompleteSocialSignUp(user: widget.user));
            }
          });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
