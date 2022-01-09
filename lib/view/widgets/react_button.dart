import 'package:flutter/material.dart';

enum reactions {
  angry,
  sad,
  non,
  smile,
  haha,
}

class ReactButton extends StatelessWidget {
  const ReactButton(
      {Key? key,
      required this.react,
      required this.onTab,
      required this.onLongPress})
      : super(key: key);
  final reactions react;
  final Function() onTab, onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: onTab,
        onLongPress: onLongPress,
        child: ReactionImage(
          react: react,
        ),
      ),
    );
  }

  non() {
    return const Icon(
      Icons.tag_faces_outlined,
      color: Colors.white,
      size: 50,
    );
  }
}

class ReactionImage extends StatelessWidget {
  const ReactionImage({Key? key, required this.react}) : super(key: key);
  final reactions react;

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'assets/images/outlinedReacts/non.png';
    switch (react) {
      case reactions.angry:
        imageUrl = 'assets/images/outlinedReacts/angry.png';
        break;
      case reactions.sad:
        imageUrl = 'assets/images/outlinedReacts/sad.png';
        break;
      case reactions.non:
        imageUrl = 'assets/images/outlinedReacts/non.png';
        break;
      case reactions.smile:
        imageUrl = 'assets/images/outlinedReacts/smile.png';
        break;
      case reactions.haha:
        imageUrl = 'assets/images/outlinedReacts/haha.png';
        break;
    }
    return Image.asset(imageUrl);
  }
}
