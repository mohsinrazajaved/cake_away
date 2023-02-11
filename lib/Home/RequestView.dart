import 'package:cake_away/Home/item.dart';
import 'package:cake_away/Home/postDetail.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/Utilities/widgets.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:cake_away/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestView extends StatefulWidget {
  RequestView({Key key}) : super(key: key);

  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView>
    with AutomaticKeepAliveClientMixin<RequestView> {
  var key = GlobalKey<ScaffoldState>();
  bool _saving = false;
  final Key _mapKey = UniqueKey();
  var _repository = Repository();
  Future<List<DocumentSnapshot>> _future;
  PicitUser _user;
  List<String> cities = [];
  String selectedCity;

  List<String> country = [];
  String selectedCountry;
  User currentUser;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      PicitUser user = await _repository.retrieveUserDetails(currentUser);
      setState(() {
        _user = user;
      });
    }
    _future = _repository.retrievePosts("RequestType.Request");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Request".tr()),
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
          cities = (posts?.map((e) => e.city)?.toSet()?.toList() ?? []);
          country = posts?.map((e) => e.country)?.toSet()?.toList();

          if (selectedCity != null) {
            posts = posts?.where((e) => e.city == selectedCity)?.toList() ?? [];
          }
          if (selectedCountry != null) {
            posts =
                posts?.where((e) => e.country == selectedCountry)?.toList() ??
                    [];
          }

          posts?.sort((a, b) => a.time.millisecondsSinceEpoch
              .compareTo(b.time.millisecondsSinceEpoch));
          posts?.sort((a, b) => a.time.millisecondsSinceEpoch
              .compareTo(b.time.millisecondsSinceEpoch));

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                _header(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: ((context, index) {
                      return ItemList(
                        item: posts[index],
                        ontap: () {
                          if (currentUser == null) {
                            Widgets.showInSnackBar(
                                "Please Signup/Login".tr(), key);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => PostDetailScreen(
                                      user: _user,
                                      currentuser: _user,
                                      documentSnapshot: snapshot.data[index],
                                      onUpdate: () {
                                        retrieveUserDetails();
                                      },
                                    )),
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ),
                ),
              ],
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

  Row _header() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Country: ".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    isExpanded: true,
                    items: (country ?? []).map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "City: ".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCity,
                    isExpanded: true,
                    items: (cities ?? []).map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
