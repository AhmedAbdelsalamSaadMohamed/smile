import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.imageUrl})
      : super(key: key);

  final Function() onPressed;
  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            SizedBox(height: 30, width: 30, child: Image.asset(imageUrl)),
            const SizedBox(width: 16,),
            Text(text),
          ]),
        ),
      ),
    );
  }
}
