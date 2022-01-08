const functions = require("firebase-functions");
const {firestore, messaging} = require("firebase-admin");
// eslint-disable-next-line max-len
exports.newPostNotificationFun = functions.firestore.document("posts/{postId}").onCreate(async (snapshot) =>{
  const text = snapshot.data().post_text;
  const ownerId = snapshot.data().owner_id;
  functions.logger.log(ownerId);
  // eslint-disable-next-line max-len
  const owner = await (firestore().collection("users").doc(ownerId).get()).then(
      (value) => {
        return value.data();
      },
  );
    // eslint-disable-next-line max-len
  await firestore().collection("users").doc(ownerId).collection("followers").get().then((value) => {
    value.docs.forEach((follower) => {
      // eslint-disable-next-line max-len
      firestore().collection("users").doc(follower.id).collection("notifications").add({
        "action": "upload_post",
        "user_id": ownerId,
        "post_id": snapshot.id,
        "time": snapshot.data().post_time,
        "seen": false,
        "new": true,
      });
    });
  });
  const payload = {
    notification: {
      title: owner.name+" Publish a new Post",
      // eslint-disable-next-line max-len
      body: text ? (text.length <= 100 ? text : text.substring(0, 97) + "...") : "",
      icon: owner.profile_url,
      click_action: "https://${process.env.GCLOUD_PROJECT}.firebaseapp.com",
    },
  };
    // eslint-disable-next-line max-len
  await firestore().collection("users").doc(ownerId).collection("followers").get().then((value)=>{
    value.docs.forEach((follower)=>{
      functions.logger.log(follower.id);
      // eslint-disable-next-line max-len
      firestore().collection("users").doc(follower.id).collection("tokens").get().then((tokens)=>{
        tokens.docs.forEach((token)=>{
          functions.logger.log(token.id);
          messaging().sendToDevice(token.id, payload);
        });
      });
    });
  });
});
