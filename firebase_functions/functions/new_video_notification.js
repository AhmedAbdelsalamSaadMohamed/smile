const functions = require("firebase-functions");
const {firestore, messaging} = require("firebase-admin");
// eslint-disable-next-line max-len
exports.newVideoNotificationFun = functions.firestore.document("videos/{videoId}").onCreate(async (snapshot) =>{
  const description = snapshot.data().video_description;
  const ownerId = snapshot.data().video_owner_id;
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
        "action": "upload_video",
        "user_id": ownerId,
        "video_id": snapshot.id,
        "time": snapshot.data().video_time,
        "seen": false,
        "new": true,
      });
    });
  });
  const payload = {
    notification: {
      title: owner.name+" upload a new video",
      // eslint-disable-next-line max-len
      body: description ? (description.length <= 100 ? description : description.substring(0, 97) + "...") : "",
      icon: owner.profile_url,
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    data: {
      "id": snapshot.id,
      "action": "upload_video",
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
