import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  HomeViewModel() {
    // allVideos.then((value) {
    //   max = value.length;
    //   _addItem(index: 0);
    // });
    // _addItem(index: 0);
  }
  int lastIndex = 0;
  int lastFollowingIndex = 0;
  // Future<List<VideoModel>> allVideos = VideoFireStore().getAllVideos();
  //
  //
  // RxList<Widget> widgets = <Widget>[].obs;
  //
  // int max = 0;
  //
  // //Widget
  // VideoIndex(int index){
  //   lastIndex = index;
  //   return index;
  // }
  // getVideo({required int index, required int max}) {
  //   max = max;
  //   _addItem(index: index);
  //   lastIndex = index;
  // }
  //
  // _addItem({required int index}) {
  //   for (int i = 0; i < 3 && widgets.length < max; i++) {
  //     widgets.addIf(
  //         widgets.length == index + i,
  //         FutureBuilder<VideoModel>(
  //             future: allVideos.then((value) => value[index + i]),
  //             builder: (context, snapshot) {
  //               if (snapshot.hasError) {
  //                 return Center(
  //                   child: Text('Error'.tr),
  //                 );
  //               } else if (!snapshot.hasData) {
  //                 return Center(
  //                   child: Text('Loading...'.tr),
  //                 );
  //               } else {
  //                 return Builder(builder: (context) {
  //                   return VideoWidget(
  //                     video: snapshot.data!,
  //                     // type: 'network',
  //                     autoPlay: (index + i == initialized || index + i == 0)
  //                         ? true
  //                         : false,
  //                   );
  //                 });
  //               }
  //             }));
  //   }
  // }
}
