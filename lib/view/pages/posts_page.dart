import 'package:flutter/material.dart';
import 'package:smile/model/post_model.dart';
import 'package:smile/view/widgets/new_post_wiget.dart';
import 'package:smile/view/widgets/post_widget.dart';
import 'package:smile/view_model/post_view_model.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  PostViewModel();
    return Scaffold(
    //  appBar: AppBar(title: Text('Posts'.tr),),
      body: Column(
        children: [
          SizedBox(height: 40, child: Container(color: Colors.black,),),
          Expanded(
            child: FutureBuilder<List<PostModel>>(
              future: PostViewModel().getAllPosts(),
              builder: (context, snapshot) {
                if(snapshot.hasError|| !snapshot.hasData){
                  return NewPostWidget(showProfile: true,);
                }else {
                  List<PostModel> posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length +1,
                  itemBuilder: (context, index) {
                    if(index ==0){
                      return NewPostWidget(showProfile: true,);
                    }else{
                      return PostWidget(postId: posts[index-1].postId!);
                    }
                  },

                );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
