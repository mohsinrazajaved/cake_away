import 'package:cake_away/Home/item.dart';
import 'package:cake_away/Home/postDetail.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:cake_away/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Favourite extends StatefulWidget {
  Favourite({Key key}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite>
    with AutomaticKeepAliveClientMixin<Favourite> {
  var key = GlobalKey<ScaffoldState>();
  bool _saving = false;
  Future<List<DocumentSnapshot>> _future;
  User currentUser;
  PicitUser _user;
  var _repository = Repository();

  @override
  void initState() {
    super.initState();
    User currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      retrieveUserDetails();
    } else {
      _future = Future.value([]);
    }
  }

  retrieveUserDetails() async {
    currentUser = _repository.getCurrentUser();
    PicitUser user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retrieveFavouritePosts(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Favourites'),
        elevation: 1,
        backgroundColor: Color(0xFF73AEF5),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Column(
            children: [
              Expanded(
                child: _buildPostView(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: postImagesWidget(),
      ),
    );
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        List<Post> posts = [];
        if (snapshot.hasData) {
          posts = snapshot?.data?.map((e) => Post.fromJson(e.data()))?.toList();
          posts.sort((a, b) => a.time.millisecondsSinceEpoch
              .compareTo(b.time.millisecondsSinceEpoch));
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: ((context, index) {
                return ItemList(
                  item: posts[index],
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => PostDetailScreen(
                              user: _user,
                              currentuser: _user,
                              documentSnapshot: snapshot.data[index],
                              onUpdate: () {
                                // retrieveUserDetails(_currentPosition);
                              },
                            )),
                      ),
                    );
                  },
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('No Posts Found'),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
        return Center(
          child: Text(''),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
