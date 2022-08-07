import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cake_away/Auth/login.dart';
import 'package:cake_away/Home/editProfile.dart';
import 'package:cake_away/Home/postDetail.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/main.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  var _repository = Repository();
  PicitUser _user;
  String icon;

  Color color;
  bool _saving = false;
  Future<List<DocumentSnapshot>> _future;
  String id = "";
  List<String> languages = ['English', 'French'];

  final df = new DateFormat('dd-MM-yyyy HH:mm');
  @override
  void initState() {
    super.initState();

    retrieveUserDetails();
    //icon = FontAwesomeIcons.heart;
  }

  retrieveUserDetails() async {
    User currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      PicitUser user = await _repository.retrieveUserDetails(currentUser);
      setState(() {
        _user = user;
      });
      id = currentUser.uid;
      _future = _repository.retrieveUserPosts(currentUser.uid);
    } else {
      _future = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF73AEF5),
          elevation: 1,
          title: Text('Profile'.tr()),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings_power),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                _repository.signOut().then((v) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs?.setBool("isLoggedIn", false);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                });
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: _user != null ? _buildProfileView() : Container(),
          ),
        ));
  }

  Widget _buildProfileView() {
    //main scroll view
    return Column(children: <Widget>[
      _buildUserInfo(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "Language: ".tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: DropdownButton<String>(
                value: selectedLanguage,
                isExpanded: true,
                items: (languages ?? []).map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == 'English') {
                      this.setState(() {
                        selectedLanguage = 'English';
                        //icon = "us.png";
                        context.locale = Locale('en', 'US');
                      });
                    } else if (newValue == 'French') {
                      this.setState(() {
                        selectedLanguage = 'French';
                        //icon = "fr.png";
                        context.locale = Locale('fr', 'CA');
                      });
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      _buildUserDetails(),
      Expanded(child: postImagesWidget()),
    ]);
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 0),
              itemBuilder: ((context, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: (snapshot.data[index].data()['imagesUrls']
                                      as List<dynamic>)
                                  ?.first ??
                              "",
                          placeholder: ((context, s) => Center(
                                child: CircularProgressIndicator(),
                              )),
                          width: 125.0,
                          height: 125.0,
                          fit: BoxFit.cover,
                        ),
                        Visibility(
                          visible:
                              (snapshot.data[index].data()['type'] == "Video"),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill_sharp,
                              size: 30,
                              color: Color(0xFF73AEF5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
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
                                ))));
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

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20.0),
          child: Text(_user?.displayName ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10.0),
          child: _user.bio.isNotEmpty ? Text(_user?.bio ?? "") : Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Divider(),
        ),
      ],
    );
  }

  Widget _buildUserDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                    child: Container(
                      //width: 210.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      child: Center(
                        child: Text("Edit Profile".tr(),
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => EditProfileScreen(_user,
                                photoUrl: _user.photoUrl,
                                email: _user.email,
                                bio: _user.bio,
                                name: _user.displayName,
                                city: _user.city,
                                country: _user.country,
                                phone: _user.phone))));
                    retrieveUserDetails();
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 0, right: 0),
                    child: Container(
                      //width: 210.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.grey)),
                      child: Center(
                        child: Text("Remove Account".tr(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    _repository.removeAccount();
                    _repository.signOut().then((v) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs?.setBool("isLoggedIn", false);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
