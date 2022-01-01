import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/firestorage_service.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/tag_page.dart';
import 'package:smile/view/widgets/profile_follow_button.dart';
import 'package:smile/view/widgets/react_button.dart';
import 'package:smile/view/widgets/share_button.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';
import 'package:video_player/video_player.dart';

import 'comment_button.dart';

class VideoWidget extends StatefulWidget {
  VideoWidget({Key? key, required this.video, required this.autoPlay})
      : super(key: key);
  final VideoModel video;
  final bool autoPlay;
  int? descriptionMaxLines = 5;
  bool isDisposed = false;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late Timer _timer;
  int position = 0;
  RxBool isPaused = false.obs;
  late VideoPlayerViewModel _videoPlayerViewModel;

  VideoViewModel videoViewModel = VideoViewModel();

  @override
  void initState() {
    _videoPlayerViewModel =
        Get.put(VideoPlayerViewModel(), tag: widget.video.id, permanent: true);
    try {
      _videoPlayerViewModel.videoPlayerController.value =
          VideoPlayerController.network(widget.video.url!);
      _videoPlayerViewModel.videoPlayerController.value..initialize();
      {
        setState(() {
          // widget.isBlank;
          if (widget.autoPlay) {
            _videoPlayerViewModel.videoPlayerController.value.play();
          }
          _videoPlayerViewModel.videoPlayerController.value.setLooping(true);
          _timer = Timer.periodic(const Duration(microseconds: 10), (t) {
            if (Get.find<VideoPlayerViewModel>(tag: widget.video.id)
                .videoPlayerController
                .value
                .value
                .isPlaying) {
              // _videoPlayerViewModel.videoPlayerController.value.position
              //     .then((value) {
              Duration _realPosition = _videoPlayerViewModel
                  .videoPlayerController.value.value.position;
              if (position != _realPosition.inSeconds) {
                setState(() {
                  position = _realPosition.inSeconds;
                });
              }
              // });
            }
          });
        });
      }
    } on PlatformException {
      print(
          'PlatformExceptionPlatformExceptionPlatformExceptionPlatformExceptionPlatformExceptionPlatformException');
    } catch (e) {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: GestureDetector(
            onDoubleTap: () {},
            onTap: () {
              setState(() {
                playOrPauseVideo();
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  child: SizedBox(
                    width: _videoPlayerViewModel
                        .videoPlayerController.value.value.size.width,
                    height: _videoPlayerViewModel
                        .videoPlayerController.value.value.size.height,
                    child: _videoPlayerViewModel
                            .videoPlayerController.value.value.isInitialized
                        ? VideoPlayer(
                            _videoPlayerViewModel.videoPlayerController.value,
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                ///  //
                Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        ///left
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              playOrPauseVideo();
                            });
                          },
                          onDoubleTap: () {
                            if (Get.find<AuthViewModel>()
                                .currentUser!
                                .isAnonymous!) {
                              Get.find<VideoPlayerViewModel>(
                                      tag: widget.video.id!)
                                  .videoPlayerController
                                  .value
                                  .pause();
                              Get.to(SignInPage(),
                                  transition: Transition.downToUp);
                            } else
                              setState(() {
                                videoViewModel
                                    .getVideoReact(videoId: widget.video.id!)
                                    .first
                                    .then((react) {
                                  switch (react) {
                                    case reactions.angry:
                                      react = reactions.angry;
                                      break;
                                    case reactions.sad:
                                      react = reactions.angry;
                                      break;
                                    case reactions.non:
                                      react = reactions.sad;
                                      break;
                                    case reactions.smile:
                                      react = reactions.non;
                                      break;
                                    case reactions.haha:
                                      react = reactions.smile;
                                      break;
                                  }
                                  videoViewModel.reactVideo(
                                      videoId: widget.video.id!,
                                      reaction: react);
                                  _showAnimatedReact();
                                }, onError: (_) {
                                  videoViewModel.reactVideo(
                                      videoId: widget.video.id!,
                                      reaction: reactions.sad);
                                  _showAnimatedReact();
                                });
                              });
                          },
                          onLongPress: () {
                            showVideoBottomSheet();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: Colors.transparent,
                          ),
                        ),

                        ///right
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              playOrPauseVideo();
                            });
                          },
                          onDoubleTap: () {
                            if (Get.find<AuthViewModel>()
                                .currentUser!
                                .isAnonymous!) {
                              Get.find<VideoPlayerViewModel>(
                                      tag: widget.video.id!)
                                  .videoPlayerController
                                  .value
                                  .pause();
                              Get.to(SignInPage(),
                                  transition: Transition.downToUp);
                            } else
                              setState(() {
                                videoViewModel
                                    .getVideoReact(videoId: widget.video.id!)
                                    .first
                                    .then((react) {
                                  switch (react) {
                                    case reactions.angry:
                                      react = reactions.sad;
                                      break;
                                    case reactions.sad:
                                      react = reactions.non;
                                      break;
                                    case reactions.non:
                                      react = reactions.smile;
                                      break;
                                    case reactions.smile:
                                      react = reactions.haha;
                                      break;
                                    case reactions.haha:
                                      react = reactions.haha;
                                      break;
                                  }
                                  videoViewModel.reactVideo(
                                      videoId: widget.video.id!,
                                      reaction: react);
                                  _showAnimatedReact();
                                }, onError: (_) {
                                  print(
                                      '/////////////////////////////on error');
                                  videoViewModel.reactVideo(
                                      videoId: widget.video.id!,
                                      reaction: reactions.smile);
                                  _showAnimatedReact();
                                });
                              });
                          },
                          onLongPress: () {
                            showVideoBottomSheet();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    )),

                    ///description
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.descriptionMaxLines == null) {
                              widget.descriptionMaxLines = 2;
                            } else {
                              widget.descriptionMaxLines = null;
                            }
                          });
                        },
                        child: HashTagText(
                          text: (widget.video.description ?? ''),
                          maxLines: widget.descriptionMaxLines,
                          basicStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          decoratedStyle: const TextStyle(color: Colors.blue),
                          onTap: (tag) {
                            Get.find<VideoPlayerViewModel>(tag: widget.video.id)
                                .videoPlayerController
                                .value
                                .pause();
                            Get.to(TagPage(hashtag: tag),
                                transition: Transition.rightToLeft);
                          },
                        )),

                    /// time line
                    timeLine(),
                  ],
                ),

                /// play button
                Obx(
                  () => isPaused.value == false
                      ? Container()
                      : Positioned(
                          top: MediaQuery.of(context).size.height * 0.5 - 25,
                          left: MediaQuery.of(context).size.width * 0.5 - 25,
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 60,
                            color: Colors.white,
                          )),
                ),

                /// buttons
                Positioned(
                    right: 5,
                    top: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        ProfileFollowButton(video: widget.video),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<reactions>(
                            stream: videoViewModel.getVideoReact(
                                videoId: widget.video.id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return const ReactButton(
                                  react: reactions.non,
                                );
                              }
                              return ReactButton(
                                react: snapshot.data!,
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        CommentButton(
                          videoId: widget.video.id ?? ' ',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                         ShareButton(video: widget.video,),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  playOrPauseVideo() {
    if (Get.find<VideoPlayerViewModel>(tag: widget.video.id)
        .videoPlayerController
        .value
        .value
        .isPlaying) {
      Get.find<VideoPlayerViewModel>(tag: widget.video.id)
          .videoPlayerController
          .value
          .pause();
      isPaused.value = true;
    } else {
      Get.find<VideoPlayerViewModel>(tag: widget.video.id)
          .videoPlayerController
          .value
          .play();
      isPaused.value = false;
    }
  }

  @override
  void dispose() {
    widget.isDisposed = true;
    if (_videoPlayerViewModel.videoPlayerController.value.value.isInitialized) {
      _timer.cancel();
      _videoPlayerViewModel.videoPlayerController.value
        ..pause()
        ..setVolume(0)
        ..dispose().then((value) =>
            print('==============-----------dispose--------============='));
    } else {
      _videoPlayerViewModel.videoPlayerController.value =
          VideoPlayerController.network('dataSource');
    }
    super.dispose();
  }

  timeLine() {
    Duration duration = Duration(seconds: position);
    Duration total = Get.find<VideoPlayerViewModel>(tag: widget.video.id)
        .videoPlayerController
        .value
        .value
        .duration;
    String sDuration =
        "${duration.inHours == 0 ? '' : duration.inHours.toString() + ':'}${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    String totalStr =
        "${total.inHours == 0 ? '' : total.inHours.toString() + ':'}${total.inMinutes.remainder(60)}:${(total.inSeconds.remainder(60))}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            sDuration,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Expanded(
            child:

                ///
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SizedBox(
                height: (isPaused.value &&
                        !_videoPlayerViewModel
                            .videoPlayerController.value.value.isBuffering
                    ? 2
                    : 1),
                child: VideoProgressIndicator(
                  _videoPlayerViewModel.videoPlayerController.value,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    backgroundColor: Colors.transparent,
                    bufferedColor: Colors.white.withOpacity(0.5),
                    playedColor: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),

            // Slider(
            //   value: 0.0 + position,
            //   onChanged: (newValue) {
            //     setState(() {
            //       position = newValue.toInt();
            //       Get.find<VideoPlayerViewModel>(tag: widget.video.id)
            //           .videoPlayerController
            //           .value
            //           .seekTo(Duration(seconds: newValue.toInt()));
            //     });
            //   },
            //   max: 0.0 +
            //       Get.find<VideoPlayerViewModel>(tag: widget.video.id)
            //           .videoPlayerController
            //           .value
            //           .value
            //           .duration
            //           .inSeconds,
            //
            // ),
          ),
          Text(totalStr,
              style: const TextStyle(color: Colors.white, fontSize: 12))
        ],
      ),
    );
  }

  _showAnimatedReact() {
    bool start = false;

    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 10))
            .then((value) => setState(() {
                  start = true;
                }));
        Future.delayed(
          const Duration(milliseconds: 500),
        ).then((value) => Get.back());
        return Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: MediaQuery.of(context).size.width * 0.4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: start ? 50 : 100,
                  height: start ? 50 : 100,
                  curve: Curves.fastOutSlowIn,
                  child: StreamBuilder<reactions>(
                      stream: videoViewModel.getVideoReact(
                          videoId: widget.video.id!),
                      builder: (context, snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const ReactionImage(
                            react: reactions.non,
                          );
                        }
                        return ReactionImage(
                          react: snapshot.data!,
                        );
                      }),
                )),
          ],
        );
      },
    );
  }

  showVideoBottomSheet() {
    Get.bottomSheet(BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: Text('Save Video'.tr),
              onTap: () {
                if (Get.find<AuthViewModel>()
                    .currentUser!
                    .isAnonymous!) {
                  Get.find<VideoPlayerViewModel>(
                      tag: widget.video.id!)
                      .videoPlayerController
                      .value
                      .pause();
                  Get.to(SignInPage(),
                      transition: Transition.downToUp);
                } else
                FireStorageService().downloadVideo(widget.video);
                Get.back();
              },
            ),
            StreamBuilder<bool>(
                stream: VideoViewModel().isFavorite(videoId: widget.video.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text('');
                  }
                  bool isFavorite = snapshot.data!;
                  return ListTile(
                    leading: isFavorite
                        ? const Icon(Icons.bookmark_remove_outlined)
                        : const Icon(Icons.bookmark_border_outlined),
                    title: isFavorite
                        ? Text('Remove from Favorites'.tr)
                        : Text('Add to Favorites'.tr),
                    onTap: () {
                      if (Get.find<AuthViewModel>()
                          .currentUser!
                          .isAnonymous!) {
                        Get.find<VideoPlayerViewModel>(
                            tag: widget.video.id!)
                            .videoPlayerController
                            .value
                            .pause();
                        Get.to(SignInPage(),
                            transition: Transition.downToUp);
                      } else
                      setState(() {
                        isFavorite
                            ? VideoViewModel().unFavoriteVideo(widget.video.id!)
                            : VideoViewModel().favoriteVideo(widget.video.id!);
                        isFavorite = !isFavorite;
                      });
                      Get.back();
                    },
                  );
                }),
            ListTile(
              leading: const Icon(Icons.outlined_flag_rounded),
              title: Text('Report'.tr),
              onTap: () {
                if (Get.find<AuthViewModel>()
                    .currentUser!
                    .isAnonymous!) {
                  Get.find<VideoPlayerViewModel>(
                      tag: widget.video.id!)
                      .videoPlayerController
                      .value
                      .pause();
                  Get.to(SignInPage(),
                      transition: Transition.downToUp);
                }
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.do_disturb_alt_rounded),
              title: Text('Not Interested'.tr),
              onTap: () {
                if (Get.find<AuthViewModel>()
                    .currentUser!
                    .isAnonymous!) {
                  Get.find<VideoPlayerViewModel>(
                      tag: widget.video.id!)
                      .videoPlayerController
                      .value
                      .pause();
                  Get.to(SignInPage(),
                      transition: Transition.downToUp);
                }
                Get.back();
              },
            ),
          ],
        );
      },
    ));
  }
}
