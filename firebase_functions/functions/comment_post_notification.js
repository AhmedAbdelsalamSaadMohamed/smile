const functions = require("firebase-functions");
const {firestore, messaging} = require("firebase-admin");
// eslint-disable-next-line max-len
exports.commentPostNotification =functions.firestore.document("posts/{postId}/comments/{commentId}").onCreate(async (snapshot) =>{
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
  const post = await firestore().collection("posts").doc(postId).get().then((value)=>{
    return value.data();
  });
    // post owner notify
    // eslint-disable-next-line max-len
  await firestore().collection("users").doc(post.owner_id).collection("notifications").add({
    "action": "Comment on yourPost",
    "user_id": commentOwnerId,
    "comment_id": snapshot.id,
    "time": snapshot.data().time,
    "seen": false,
    "new": true,
  });
  // eslint-disable-next-line max-len
  await firestore().collection("users").doc(commentOwnerId).collection("followers").get().then((value) => {
    value.docs.forEach((follower) => {
      // eslint-disable-next-line max-len
      firestore().collection("users").doc(follower.id).collection("notifications").add({
        "action": "Comment on yourPost",
        "user_id": commentOwnerId,
        "post_id": snapshot.id,
        "time": snapshot.data().post_time,
        "seen": false,
        "new": true,
      });
    });
  });
  const payload = {
    notification: {
      title: commentOwner.name+" Publish a new Post",
      // eslint-disable-next-line max-len
      body: text ? (text.length <= 100 ? text : text.substring(0, 97) + "...") : "",
      icon: commentOwner.profile_url,
      click_action: "https://${process.env.GCLOUD_PROJECT}.firebaseapp.com",
    },
  };
    // eslint-disable-next-line max-len
  await firestore().collection("posts").doc(postId).get().then((post)=>{
    // eslint-disable-next-line max-len
    firestore().collection("users").doc(post.data().owner_id).collection("tokens").get().then((tokens)=>{
      tokens.docs.forEach((token)=>{
        functions.logger.log(token.id);
        messaging().sendToDevice(token.id, payload);
      });
    });
  });


  // eslint-disable-next-line max-len
  // await firestore().collection("users").doc(ownerId).collection("followers").get().then((value)=>{
  //   value.docs.forEach((follower)=>{
  //     functions.logger.log(follower.id);
  //     // eslint-disable-next-line max-len
  // eslint-disable-next-line max-len
  //     firestore().collection("users").doc(follower.id).collection("tokens").get().then((tokens)=>{
  //       tokens.docs.forEach((token)=>{
  //         functions.logger.log(token.id);
  //         messaging().sendToDevice(token.id, payload);
  //       });
  //     });
  //   });
  // });
});

