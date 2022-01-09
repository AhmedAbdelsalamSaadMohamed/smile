const admin = require("firebase-admin");
const {commentPostNotification} = require("./comment_post_notification");
const {newPostNotificationFun} = require("./new_post_notification");
const {newVideoNotificationFun} = require("./new_video_notification");
const {commentVideoNotificationFun} = require("./comment_video_notification");
const {replyVideoNotificationFun} = require("./reply_video_notification");
admin.initializeApp();
// eslint-disable-next-line max-len
exports.newVideoNotification = newVideoNotificationFun;
// eslint-disable-next-line max-len
exports.newPostNotification = newPostNotificationFun;
// eslint-disable-next-line max-len
exports.newCommentNotification = commentPostNotification;

exports.commentVideoNotification = commentVideoNotificationFun;
exports.replyVideoNotification = replyVideoNotificationFun;
