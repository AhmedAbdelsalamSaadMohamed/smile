
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends GetxController {

    Rx<VideoPlayerController> videoPlayerController=VideoPlayerController.network('url').obs;

  init (String url){
    videoPlayerController = VideoPlayerController.network(url).obs;
    videoPlayerController.value.initialize().then((value) => update());
  }


  // init({required String videoUrl, required String type}) {
  //   try {
  //     if (type == 'assets') {
  //       videoPlayerController = VideoPlayerController.asset(videoUrl);
  //     }
  //     if (type == 'file') {
  //       videoPlayerController = VideoPlayerController.file(File(videoUrl));
  //     }
  //     if (type == 'network') {
  //       videoPlayerController = VideoPlayerController.network(videoUrl);
  //     }
  //
  //     videoPlayerController.initialize().then((_) {
  //       videoPlayerController.play();
  //       videoPlayerController.setLooping(true);
  //       update();
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //@override
  // void onReady() {
  //   videoPlayerController.play();
  // }
  // stopVideo() {
  //   videoPlayerController.pause();
  // }

  // @override
  // void dispose() {
  //   videoPlayerController.pause();
  // }
  //
  // @override
  // void onClose() {
  //   videoPlayerController.pause();
 // }
}
