import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rich_text_view/rich_text_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            _Search(),
            Expanded(child: Container())
          ],
        ),

      ),
    );
  }
}

class _Search extends StatelessWidget {
  _Search({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKy = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKy,
        child:
        RichTextView.editor(
          hashtagSuggestions: [
            HashTag(hashtag: '#ddddddd', ),
            HashTag(hashtag: '#ddddddd5'),
            HashTag(hashtag: '#ddddddd'),
            HashTag(hashtag: '#ddddddd'),
            HashTag(hashtag: '#ddddddd'),
          ],
          suggestionPosition: SuggestionPosition.bottom,
          decoration: InputDecoration(),
        )


        // TextFormField(
        //   scrollPadding:const EdgeInsets.all(0),
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     hintText: 'Search'.tr,
        //     prefixIcon: IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: () {},
        //     ),
        //   ),
        // )

    );
  }
}
