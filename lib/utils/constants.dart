const String collectionUsers = 'users';
const String fieldUserId = 'user_id';
const String fieldUserName = 'name';
const String fieldUserEmail = 'email';
const String fieldUserIsAnonymous = 'sign_in_method';
const String fieldUserProfileUrl = 'profile_url';
const String fieldUserGender = 'gender';
const String fieldUserUsername = 'username';
const String fieldUserPhone = 'phone';

/// followings
const String collectionFollowings = 'followings';
const String fieldFollowingId = 'following_id';
const String fieldFollowingNotify = 'following_notify';

/// followers
const String collectionFollowers = 'followers';
const String fieldFollowerId = 'follower_id';

///          videos
const String collectionVideos = 'videos';
const String fieldVideoId = 'video_id';
const String fieldVideoName = 'video_name';
const String fieldVideoUrl = 'video_url';
const String fieldVideoDescription = 'video_description';
const String fieldVideoOwnerId = 'video_owner_id';
const String fieldVideoTime = 'video_time';
const String fieldVideoImageUrl = 'video_image_url';

/// Tags
const String collectionTags = 'tags';
const String fieldTagId = 'tag_id';
const String fieldTag = 'tag';

/// for Posts
///
const String tablePosts = 'posts';
const String fieldPostId = 'post_id';
const String fieldPostOwnerId = 'owner_id';
const String fieldPostText = 'post_text';
const String fieldPostImagesUrls = 'post_images_urls';
const String fieldPostVideoUrl = 'post_video_url';
const String fieldPostCommentsIsd = 'post_comments_ids';
const String fieldPostSharesIds = 'post_shares_ids';
const String fieldPostLovesIds = 'post_loves_ids';
// const String fieldPostSadsIds = 'post_sads_ids';
// const String fieldPostAngriesIds = 'post_angries_ids';
// const String fieldPostCaresIds = 'post_cares_ids';
const String fieldPostTime = 'post_time';
//////////////////////////////////////////////////////////////
/// for Comments
///
const String tableComments = 'comments';
const String fieldCommentId = 'id';
const String fieldCommentTime = 'time';
const String fieldCommentOwner = 'owner';
const String fieldCommentText = 'text';
const String fieldCommentPostId = 'postId';
const String fieldCommentImage = 'image';
const String fieldCommentVideo = 'video';
const String fieldCommentLoves = 'loves';

/// for Replies
///
const String tableReplies = 'replies';
const String fieldReplyId = 'id';
const String fieldReplyOwner = 'owner';
const String fieldReplyCommentId = 'comment_id';
const String fieldReplyText = 'text';
const String fieldReplyImage = 'image';
const String fieldReplyVideo = 'video';
const String fieldReplyTime = 'time';
const String fieldReplyLoves = 'loves';

/// favorites
const String collectionFavorites = 'favorites';

/// reactions

const String collectionReactions ='reactions';
const String fieldReactionId ='react_id';
const String fieldReaction = 'react';