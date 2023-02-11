import 'package:cached_network_image/cached_network_image.dart';
import 'package:cake_away/Home/imageDetail.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/Utilities/widgets.dart';
import 'package:cake_away/models/like.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:easy_localization/easy_localization.dart';

class PostDetailScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final PicitUser user, currentuser;
  final Function onUpdate;

  PostDetailScreen(
      {this.documentSnapshot, this.user, this.currentuser, this.onUpdate});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _repository = Repository();
  final CarouselController _controller = CarouselController();

  bool _isLiked = false;
  bool _isFavourite = false;
  final Key _mapKey = UniqueKey();
  int _current = 0;

  var key = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> favouroites = [];
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      favouroites =
          (widget.documentSnapshot.data()['favouroites'] ?? []).cast<String>();
      if (favouroites.contains(widget.user.uid)) {
        _isFavourite = true;
      }
      _repository
          .isLiked(
              uid: widget.user.uid, documentSnapshot: widget.documentSnapshot)
          .then((value) {
        setState(() {
          _isLiked = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFF73AEF5),
        title: Text('Post'),
        actions: [
          Visibility(
            visible: ((widget?.user?.uid ?? "") ==
                    (widget.documentSnapshot.data()['ownerUid']))
                ? true
                : false,
            child: GestureDetector(
              onTap: () async {
                await _repository?.deletePost(
                  widget.documentSnapshot.data()['postid'],
                  widget?.user?.uid ?? "",
                );
                Widgets.showInSnackBar("Post deleted", key);
                widget.onUpdate();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.documentSnapshot.data()['title'],
              maxLines: 2,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              List list = (widget.documentSnapshot.data()['imagesUrls']
                  as List<dynamic>);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => ImageDetail(list[_current])),
                ),
              );
            },
            child: Container(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: CarouselSlider(
                      carouselController: _controller,
                      items: (widget.documentSnapshot.data()['imagesUrls']
                              as List<dynamic>)
                          .map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, bottom: 8.0),
                          child: Container(
                            height: 200,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: e,
                                    placeholder: ((context, s) => Center(
                                          child: CircularProgressIndicator(),
                                        )),
                                    errorWidget: (conex, x, _) {
                                      return Center(child: Text("No Image"));
                                    },
                                    width: 125.0,
                                    height: 125.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                        aspectRatio: 1 / 1,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (widget.documentSnapshot.data()['imagesUrls']
                            as List<dynamic>)
                        .asMap()
                        .entries
                        .map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Stack(
            //   children: [

            //     Positioned.fill(
            //       child: CachedNetworkImage(
            //         imageUrl: (widget.documentSnapshot.data()['imagesUrls']
            //                 as List<dynamic>)
            //             .first,
            //         placeholder: ((context, s) => Center(
            //               child: CircularProgressIndicator(),
            //             )),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ],
            // ),
            //),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 4.0),
                    GestureDetector(
                        child: _isLiked
                            ? Icon(
                                Icons.thumb_up,
                                color: Colors.blue,
                                size: 25,
                              )
                            : Icon(
                                FontAwesomeIcons.thumbsUp,
                                size: 25,
                                color: null,
                              ),
                        onTap: () {
                          if (!_isLiked) {
                            setState(() {
                              _isLiked = true;
                            });
                            postLike(widget.documentSnapshot.reference);
                          } else {
                            setState(() {
                              _isLiked = false;
                            });
                            postUnlike(widget.documentSnapshot.reference);
                          }
                        }),
                    new SizedBox(
                      width: 16.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!_isFavourite) {
                          setState(() {
                            _isFavourite = true;
                          });
                          markFavourite(widget.documentSnapshot);
                        } else {
                          setState(() {
                            _isFavourite = false;
                          });
                          unmarkFavourite(widget.documentSnapshot);
                        }
                      },
                      child: _isFavourite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 25,
                            )
                          : Icon(
                              FontAwesomeIcons.heart,
                              size: 25,
                              color: null,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
              visible: widget.documentSnapshot.data()['type'] !=
                  "RequestType.Request",
              child: makeTitle(
                  "Price".tr(), widget.documentSnapshot.data()['price'])),
          makeTitle("City".tr(), widget.documentSnapshot.data()['city']),
          makeTitle("Country".tr(), widget.documentSnapshot.data()['country']),
          Visibility(
            visible:
                widget.documentSnapshot.data()['type'] == "RequestType.Request",
            child: makeTitle(
                "Event Date".tr(), widget.documentSnapshot.data()['eventDate']),
          ),
          //  makeTitle("Description",widget.documentSnapshot.data()['description']),
          //   makeTitle("Description",widget.documentSnapshot.data()['description']),
          makeTitle("Description".tr(),
              widget.documentSnapshot.data()['description']),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: RaisedButton(
                    color: Color(0xFF73AEF5),
                    child: Text(
                      "Contact".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      UrlLauncher.launch(
                          "tel://${widget.documentSnapshot.data()['phonenumber']}");
                    })),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          //   child: Text("Description",
          //       style: TextStyle(fontWeight: FontWeight.bold)),
          // ),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          //   child: Text(widget.documentSnapshot.data()['description']),
          // ),
        ],
      ),
    );
  }

  Widget makeTitle(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(value ?? ""),
        ),
      ],
    );
  }

  void markFavourite(DocumentSnapshot documentSnapshot) async {
    if (!favouroites.contains(widget.currentuser.uid)) {
      favouroites.add(widget.currentuser.uid);
      documentSnapshot.reference.update({"favouroites": favouroites});
    }
  }

  void unmarkFavourite(DocumentSnapshot documentSnapshot) async {
    if (favouroites.contains(widget.currentuser.uid)) {
      favouroites.remove(widget.currentuser.uid);
      documentSnapshot.reference.update({"favouroites": favouroites});
    }
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .doc(widget.currentuser.uid)
        .set(_like.toMap(_like))
        .then((value) {
      if (widget.documentSnapshot.data()['totalLikes'] != null &&
          widget.documentSnapshot.data()['totalLikes'] >= 0) {
        reference.update(
            {"totalLikes": widget.documentSnapshot.data()['totalLikes'] += 1});
      }
      widget?.onUpdate();
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .doc(widget.currentuser.uid)
        .delete()
        .then((value) {
      if (widget.documentSnapshot.data()['totalLikes'] != null &&
          widget.documentSnapshot.data()['totalLikes'] >= 0) {
        reference.update(
            {"totalLikes": widget.documentSnapshot.data()['totalLikes'] -= 1});
      }
      widget?.onUpdate();
      print("Post Unliked");
    });
  }
}
