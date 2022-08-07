import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/main.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfileScreen extends StatefulWidget {
  final String photoUrl, email, bio, name, city, country, phone;
  final PicitUser user;

  EditProfileScreen(this.user,
      {this.photoUrl,
      this.email,
      this.bio,
      this.name,
      this.city,
      this.country,
      this.phone});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _repository = Repository();
  User currentUser;
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();

  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    _emailController.text = widget.email;
    _cityController.text = widget.city;
    _countryController.text = widget.country;
    _phoneController.text = widget.phone;
    currentUser = _repository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF73AEF5),
          elevation: 1,
          title: Text("Edit Profile".tr()),
          leading: GestureDetector(
            child: Icon(Icons.close, color: Colors.white),
            onTap: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(Icons.done, color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  _saving = true;
                });

                _repository
                    .updateDetails(
                  currentUser.uid,
                  _nameController.text,
                  _cityController.text,
                  _countryController.text,
                  _phoneController.text,
                  _bioController.text,
                  _emailController.text,
                )
                    .then((v) {
                  setState(() {
                    _saving = false;
                  });
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
        body: ModalProgressHUD(
            inAsyncCall: _saving,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Name".tr(),
                            labelText: "Name".tr(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: "City".tr(),
                            labelText: "City".tr(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: _countryController,
                          decoration: InputDecoration(
                            hintText: "Country".tr(),
                            labelText: "Country".tr(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone#',
                            labelText: 'Phone#',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: TextField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Bio',
                            labelText: 'Bio',
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Private Information".tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: TextField(
                          controller: _emailController,
                          onChanged: null,
                          decoration: InputDecoration(
                            hintText: "Email address".tr(),
                            labelText: "Email address".tr(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
