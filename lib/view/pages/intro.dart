import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/signup_page.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [pageWelcome(), page5050(),pageSecure()],
      done: Text('done'),
      onDone: () {
        Get.to(SignInPage());
      },
      showNextButton: true,
      showSkipButton: true,
      color: Theme.of(context).primaryColor,
      next: Text('next'),
      skip: Text('Skip'),
      onSkip: () {
        Get.to(SignInPage());
      },
    );
  }

  _customButton(context,
      {required String text, required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OutlinedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 3,
                // color: Theme.of(context).primaryColor,
              ),
            ),
          )),
    );
  }

  page1(context) {
    return PageViewModel(
      title: 'page1',
      bodyWidget: Scaffold(
        body: Column(
          //: MainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: Get.height * 0.05,
              child: Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/textlogo.png'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                'assets/images/smile_login.png',
                fit: BoxFit.contain,
              ),
            ),
            _customButton(context, text: 'Sign In', onPressed: () {
              Get.to(SignInPage());
            }),
            _customButton(context, text: 'Sign Up', onPressed: () {
              Get.to(SignUpPage());
            }),
            Expanded(child: Container()),
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
                ))
          ],
        ),
      ),
    );
  }

  page2() {
    return PageViewModel(
      title: 'Page 2',
      body: 'page 2 body',
      image: Image.asset(
        'assets/images/smile_login.png',
        fit: BoxFit.contain,
      ),
    );
  }

  page3() {
    return PageViewModel(
      title: 'Page 3',
      body: 'page 3 body',
      image: Image.asset(
        'assets/images/smile_login.png',
        fit: BoxFit.contain,
      ),
    );
  }
  page5050(){
    return PageViewModel(
      title: 'New Model for Interact the video',
      body: 'The video screen split into Two parts for Positive or negative interaction ',
      image: Padding(
        padding: const EdgeInsets.only(top: 50,left: 50),
        child: Image.asset(
          'assets/images/5050.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  pageSecure(){
    return PageViewModel(
      title: 'User Data Security',
      body: 'You must make sure that your data is safe.\n'
          'All data is encrypted\n',
      image: Image.asset(
        'assets/images/secure.png',
        fit: BoxFit.contain,
      ),
    );
  }
  pageWelcome(){
    return PageViewModel(
      title: 'Welcome to Smile Mobile App',
      body: 'You can find Funny Videos or Posts\n'
          'and You can Share your videos or posts\n',
      image: Image.asset(
        'assets/images/welcome.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
