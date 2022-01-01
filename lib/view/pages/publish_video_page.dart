import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:smile/services/firebase/tag_firestore.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';
import 'package:smile/view_model/video_view_model.dart';

class PublishVideoPage extends StatefulWidget {
  PublishVideoPage({Key? key, required this.xFile}) : super(key: key);
  final XFile xFile;
  String? description;

  @override
  State<PublishVideoPage> createState() => _PublishVideoPageState();
}

class _PublishVideoPageState extends State<PublishVideoPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController =
        TextEditingController(text: widget.description);

    return Scaffold(
      appBar: AppBar(
        title: Text('Publish'.tr),
        actions: [IconButton(onPressed: () {
          VideoViewModel().publishVideo(
              filePath: widget.xFile.path,
              description: widget.description);
        }, icon: Icon(Icons.send))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.4,
                child: VideoThumbnailWidget(url: widget.xFile.path)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                  future: TagFireStore().getAllStrTags(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }
                    return RichTextView.editor(
                      controller: _textEditingController,
                      onChanged: (value) {
                        widget.description = value;
                      },
                      hashtagSuggestions: [
                        ...snapshot.data!.map((e) => HashTag(hashtag: e))
                      ],
                      suggestionPosition: SuggestionPosition.bottom,

                      // onSubmitted: (value) {
                      //   widget.description = value;
                      // },
                      // decoratedStyle:
                      //     const TextStyle(fontSize: 20, color: Colors.blue),
                      // basicStyle: const TextStyle(
                      //   fontSize: 20,
                      // ),
                      // maxLines: null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                          disabledBorder: UnderlineInputBorder(),
                          errorBorder: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(),
                          focusedErrorBorder: UnderlineInputBorder(),
                          hintText: 'Describe your video'.tr,
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 24)),
                      //enableSuggestions: true,
                    );
                  }),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     OutlinedButton(
            //       onPressed: () {
            //         VideoViewModel().publishVideo(
            //             filePath: widget.xFile.path,
            //             description: widget.description);
            //       },
            //       child: Text('Publish'.tr),
            //       style: ButtonStyle(
            //           fixedSize: MaterialStateProperty.all(
            //               const Size.fromWidth(double.infinity))),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
