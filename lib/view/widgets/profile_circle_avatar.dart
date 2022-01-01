import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar({
    Key? key,
    required this.imageUrl,
    required this.radius,
  }) : super(key: key);
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(radius)),
      height: radius * 2,
      width: radius * 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageUrl == null
            ? Image.asset(
                'assets/images/male.jpg',
                fit: BoxFit.fill,
              )
            : FadeInImage.assetNetwork(
                placeholder: 'assets/images/male.jpg',
                image: imageUrl!,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/male.jpg',
                    fit: BoxFit.fill,
                  );
                },
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}
