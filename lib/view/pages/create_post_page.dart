import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile/view_model/post_view_model.dart';

class CreatePostPage extends StatelessWidget {
  CreatePostPage({Key? key}) : super(key: key);
  ValueNotifier<List<File>> images = ValueNotifier([]);
  String text = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostViewModel>(
        init: Get.put(PostViewModel()),
        builder: (postController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title:  Text(
                'Create Post'.tr,
              ),
              elevation: 0.5,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.name,
                    cursorHeight: 10,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    decoration:  InputDecoration(
                        border: InputBorder.none,
                        disabledBorder:InputBorder.none ,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'ًWrite Your Post'.tr),
                    onChanged: (value) {
                      text = value;
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: images,
                    builder: (BuildContext context, List<File> value,
                        Widget? child) {
                      return GridView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        dragStartBehavior: DragStartBehavior.start,
                        itemCount: value.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 100,
                                mainAxisExtent: 100,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 0.7),
                        itemBuilder: (context, index) {
                          {
                            return Image.file(value[index]);
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Future<List<XFile>?> xFile =
                                ImagePicker().pickMultiImage();
                            xFile.then((values) {
                              if (values != null) {
                                images.value.addAll(
                                    [...values.map((e) => File(e.path))]);
                                images.notifyListeners();
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {
                            Future<XFile?> xFile = ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            xFile.then((value) {
                              if (value != null) {
                                images.value.add(File(value.path));
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                OutlinedButton(
                    child: Text('Post'.tr),
                    onPressed: () => postController.uploadPost(
                          text: text,
                          images: images.value,
                        )),
              ],
            ),
          );
        });
  }
}
