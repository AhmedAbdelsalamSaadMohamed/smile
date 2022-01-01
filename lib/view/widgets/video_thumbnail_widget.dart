import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatelessWidget {
  const VideoThumbnailWidget({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: VideoThumbnail.thumbnailData(
          video: url,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128,
          quality: 25,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError ) {
            return Container(child: Text(url),);
          } else if(!snapshot.hasData){
            return Container(color: Colors.grey,);
          }else {
            Uint8List uint8Data = snapshot.data!;
            return Image.memory(
              uint8Data,
              fit: BoxFit.cover,
            );
          }
        });
  }
}
