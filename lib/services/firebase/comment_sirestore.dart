import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class CommentFirestore {
  final String postId;

  CommentFirestore({required this.postId})
      : commentsReference = FirebaseFirestore.instance
            .collection(tablePosts)
            .doc(postId)
            .collection(tableComments);
  final CollectionReference commentsReference;
  UserModel currentUser = Get.find<AuthViewModel>().currentUser!;

  Future<String> addComment(CommentModel newComment) async {
    return await commentsReference
        .add(newComment.toJson())
        .then((value) => value.id);
  }

  Future<List<CommentModel>?> getComments() async {
    return [
      ...await commentsReference.get().then((value) => value.docs.map((e) =>
          CommentModel.formFire(
              map: e.data() as Map<String, dynamic>, id: e.id)))
    ];
  }

  Future<CommentModel> getComment(String commentId) async {
    return await commentsReference.doc(commentId).get().then((value) =>
        CommentModel.formFire(
            map: value.data() as Map<String, dynamic>, id: value.id));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream() {
    return FirebaseFirestore.instance
        .collection(tablePosts)
        .doc(postId)
        .collection(tableComments)
        .orderBy(fieldCommentTime)
        .snapshots();
  }

  Future<List<dynamic>> getCommentLovers(String commentId) async {
    return await commentsReference.doc(commentId).get().then((value) {
      return (value.data() as Map<String, dynamic>)[fieldCommentLoves]
          as List<dynamic>;
    });
  }

  Future loveComment(String commentId) async {
    await commentsReference.doc(commentId).update({
      fieldCommentLoves: FieldValue.arrayUnion([currentUser.id])
    });
  }

  Future notLoveComment(String commentId) async {
    await commentsReference.doc(commentId).update({
      fieldCommentLoves: FieldValue.arrayRemove([currentUser.id])
    });
  }
}
