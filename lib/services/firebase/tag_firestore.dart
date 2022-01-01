import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/model/tag_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/video_firestore.dart';
import 'package:smile/utils/constants.dart';

class TagFireStore {
  final CollectionReference _tagsCollection =
      FirebaseFirestore.instance.collection(collectionTags);

  Future<Map<String, List<String>>> getAllTags() {
    return _tagsCollection.get().then((value) {
      List<TagModel> tagModels = [
        ...value.docs
            .map((e) => TagModel.fromJson(e.data() as Map<String, dynamic>))
      ];
      List<String> tags = {...tagModels.map((e) => e.tag!)}.toList();
      Map<String, List<String>> result = {};
      List<String> _getTagVideosIds(String tag) {
        return [
          ...tagModels
              .where((tagModel) => tagModel.tag == tag)
              .map((e) => e.videoId!)
        ];
      }

      for (var tag in tags) {
        result.addAll({tag: _getTagVideosIds(tag)});
      }

      return result;
    });
  }

  addVideoTag(TagModel tag) {
    _tagsCollection
        .add(
      tag.toJson(),
    )
        .then((value) {
      tag.id = value.id;
      _tagsCollection.doc(value.id).update(tag.toJson());
    });
  }

  // Future<List<VideoModel>>
  Future<List<Future<VideoModel>>> getTagVideos(String tagStr) async {
    return _tagsCollection
        .where(fieldTag, isEqualTo: tagStr)
        .get()
        .then((value) {
      return [
        ...[
          ...value.docs.map((e) =>
              TagModel.fromJson(e.data() as Map<String, dynamic>).videoId)
        ].map((videoId) => VideoFireStore().getVideo(videoId: videoId ?? ''))
      ];
    });
  }


  Future<List<String>>getAllStrTags() {
    return _tagsCollection.get().then((value) {
      List<TagModel> tagModels = [
        ...value.docs
            .map((e) => TagModel.fromJson(e.data() as Map<String, dynamic>))
      ];
      List<String> tags = {...tagModels.map((e) => e.tag!)}.toList();
     return tags;


    });
  }
}
