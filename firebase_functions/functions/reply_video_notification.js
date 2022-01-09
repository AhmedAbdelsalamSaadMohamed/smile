const functions = require("firebase-functions");
const {firestore, messaging} = require("firebase-admin");
// eslint-disable-next-line max-len
exports.replyVideoNotificationFun =functions.firestore.document("videos/{videoId}/{comments}/{commentId}").onCreate(async (snapshot) =>{
  const text = snapshot.data().text;
  const commentOwnerId = snapshot.data().owner;
  const postId = snapshot.data().postId;
  functions.logger.log(commentOwnerId);
  // eslint-disable-next-line max-len
  const commentOwner = await (firestore().collection("users").doc(commentOwnerId).get()).then(
      (value) => {
        return value.data();
      },
  );
  // eslint-disable-next-line max-len
  const video = await firestore().collection("videos").doc(postId).get().then((value)=>{
    return value.data();
  });
  // post owner notify
  // eslint-disable-next-line max-len
  await firestore().collection("users").doc(video.video_owner_id).collection("notifications").add({
    "action": "Comment on your Video",
    "user_id": commentOwnerId,
    "video_comment_id": snapshot.id,
    "time": snapshot.data().time,
    "seen": false,
    "new": true,
  });
  // notify post commenter s
  // eslint-disable-next-line max-len
  await firestore().collection("videos").doc(postId).collection("comments")
      .where("owner", "not-in", [commentOwnerId, video.video_owner_id] )
      .get().then(
          async (value) => {
            for (const comm of value.docs) {
              // eslint-disable-next-line max-len
              await firestore().collection("users").doc(comm.data().owner).collection("notifications").add({
                "action": "comment_video_commenter",
                "user_id": commentOwnerId,
                "video_comment_id": snapshot.id,
                "time": snapshot.data().time,
                "seen": false,
                "new": true,
              });
              const payload = {
                notification: {
                  // eslint-disable-next-line max-len
                  title: commentOwner.name + " Comment on same video you are comment",
                  // eslint-disable-next-line max-len
                  body: text ? (text.length <= 100 ? text : text.substring(0, 97) + "...") : "",
                  icon: commentOwner.profile_url,
                  click_action: "FLUTTER_NOTIFICATION_CLICK",
                },
                data: {
                  "id": snapshot.id,
                  "action": "comment_video_commenter",
                },
              };
              // eslint-disable-next-line max-len
              firestore().collection("users").doc(comm.data().owner).collection("tokens").get().then((tokens) => {
                tokens.docs.forEach((token) => {
                  functions.logger.log(token.id);
                  messaging().sendToDevice(token.id, payload);
                });
              });
            }
          },
      );
  // eslint-disable-next-line max-len
  // await firestore().collection("users").doc(commentOwnerId).collection("followers").get().then((value) => {
  //   value.docs.forEach((follower) => {
  //     // eslint-disable-next-line max-len
  // eslint-disable-next-line max-len
  //     firestore().collection("users").doc(follower.id).collection("notifications").add({
  //       "action": "Comment on yourPost",
  //       "user_id": commentOwnerId,
  //       "post_id": snapshot.id,
  //       "time": snapshot.data().post_time,
  //       "seen": false,
  //       "new": true,
  //     });
  //   });
  // });
  const payload = {
    notification: {
      title: commentOwner.name+" Comment on your video",
      // eslint-disable-next-line max-len
      body: text ? (text.length <= 100 ? text : text.substring(0, 97) + "...") : "",
      icon: commentOwner.profile_url,
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    data: {
      "id": snapshot.id,
      "action": "comment_video_commenter",
    },
  };
  // eslint-disable-next-line max-len
  await firestore().collection("videos").doc(postId).get().then((video)=>{
    // eslint-disable-next-line max-len
    firestore().collection("users").doc(video.data().video_owner_id).collection("tokens").get().then((tokens)=>{
      tokens.docs.forEach((token)=>{
        functions.logger.log(token.id);
        messaging().sendToDevice(token.id, payload);
      });
    });
  });
});

