import 'dart:io';
import 'package:cake_away/Home/DateModelPicker.dart';
import 'package:cake_away/Home/HelperItems.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/Utilities/constants.dart';
import 'package:cake_away/Utilities/widgets.dart';
import 'package:cake_away/main.dart';
import 'package:cake_away/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum RequestType { Request, Offer }

class Choose extends StatefulWidget {
  final bool isRequest;
  Choose({Key key, this.isRequest = false}) : super(key: key);

  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<Choose> with AutomaticKeepAliveClientMixin {
  bool _saving = false;
  TextEditingController descriptionController;
  TextEditingController titleController;
  TextEditingController cityController;
  TextEditingController countryController;
  TextEditingController priceController;
  final _repository = Repository();
  List<File> images = [];
  File _image;
  File filePath;
  int groupValue = 0;
  String dateString = "Select";
  DateTime selectedDate;

  final picker = ImagePicker();
  var key = GlobalKey<ScaffoldState>();

  bool isVideo = false;
  bool isImage = false;
  bool isLive = false;
  String selectedLiveDateTime;
  User user;

  final df = new DateFormat('dd-MM-yyyy HH:mm');
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    titleController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    priceController = TextEditingController();
    user = _repository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: key,
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.save),
          backgroundColor: Color(0xFF73AEF5),
          onPressed: user == null
              ? null
              : () {
                  uploadPost();
                },
        ),
        backgroundColor: Color(0xFF73AEF5),
        appBar: AppBar(
          title: Text('Service'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF73AEF5),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    clearControllers();
                  },
                  child: Text("Clear".tr()),
                )),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: _pickerView(context),
              ),
            ),
          ),
        ));
  }

  uploadPost() async {
    setState(() {
      _saving = true;
    });

    if (titleController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter title".tr(), key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (cityController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter city".tr(), key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (countryController.text.isEmpty) {
      Widgets.showInSnackBar("Please enter country".tr(), key);
      setState(() {
        _saving = false;
      });
      return;
    }

    if (groupValue == 0) {
      if (priceController.text.isEmpty) {
        Widgets.showInSnackBar("Please enter price".tr(), key);
        setState(() {
          _saving = false;
        });
        return;
      }
    }

    if (groupValue == 1) {
      if (selectedDate == null) {
        Widgets.showInSnackBar("Please select event date".tr(), key);
        setState(() {
          _saving = false;
        });
        return;
      }
    }

    // if (descriptionController.text.isEmpty) {
    //   Widgets.showInSnackBar("Please enter description", key);
    //   setState(() {
    //     _saving = false;
    //   });
    //   return;
    // }

    User currentUser = _repository.getCurrentUser();
    if (currentUser != null) {
      _repository.retrieveUserDetails(currentUser).then((user) {
        _repository.uploadImagesToStorage(images, "Offers").then((result) {
          Post post = Post(
            currentUserUid: currentUser.uid,
            type: groupValue == 0
                ? RequestType.Offer.toString()
                : RequestType.Request.toString(),
            title: titleController.text ?? "",
            city: cityController.text ?? "",
            country: countryController.text ?? "",
            phonenumber: user.phone ?? "",
            eventDate: dateString,
            dateTime: df.format(DateTime.now()),
            description: descriptionController?.text ?? "",
            price: priceController.text ?? "",
            postOwnerName: user?.displayName ?? "",
            totalLikes: 0,
            imagesUrls: result,
          );
          _repository.addPostToDb(post).then((value) {
            setState(() {
              _saving = false;
              clearControllers();
            });
            Widgets.showInSnackBar("Uploaded".tr(), key, color: Colors.green);
          }).catchError((e) {
            setState(() {
              _saving = false;
            });
            Widgets.showInSnackBar("Error adding current post to db : $e", key);
          });
        }).catchError((e) {
          setState(() {
            _saving = false;
          });
          Widgets.showInSnackBar("Error uploading image to storage : $e", key);
        });
      });
    } else {
      setState(() {
        _saving = false;
      });
      Widgets.showInSnackBar("Current User is null".tr(), key);
    }
  }

  Widget buildSegmentedControl() {
    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: Colors.white,
      thumbColor: Color(0xFF73AEF5),
      padding: EdgeInsets.all(8),
      groupValue: groupValue,
      children: {
        0: buildSegment("Offer".tr(), 0),
        1: buildSegment("Request".tr(), 1),
      },
      onValueChanged: (value) {
        setState(() {
          groupValue = value;
        });
      },
    );
  }

  Widget buildSegment(String text, int index) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 10,
            color: groupValue == index ? Colors.white : Colors.black),
      ),
    );
  }

  showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(
                  Icons.camera,
                  color: Color(0xFF73AEF5),
                ),
                title: new Text("Camera".tr()),
                onTap: () {
                  selectImageFromCamera((pickedFile) {
                    handleImage(pickedFile);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.image,
                  color: Color(0xFF73AEF5),
                ),
                title: new Text("Gallery".tr()),
                onTap: () {
                  selectImageFromGallery((pickedFile) {
                    handleImage(pickedFile);
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20)
            ],
          );
        });
  }

  void handleImage(PickedFile pickedFile) {
    return setState(() {
      if (pickedFile != null) {
        setState(() {
          images.add(File(pickedFile.path));
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _pickerView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSegmentedControl(),
          buildTF("Title".tr(), titleController),
          buildTF("City".tr(), cityController),
          buildTF("Country".tr(), countryController),
          Visibility(
              visible: groupValue == 0,
              child: buildTF("Price".tr(), priceController)),
          Visibility(
            visible: groupValue == 1,
            child: buildDatePicker(dateString, () async {
              var datePicked = await DatePickerModel.showSimpleDatePicker(
                context,
                textColor: Colors.black87,
                initialDate: DateTime.now(),
                dateFormat: "dd-MMMM-yyyy",
                titleText: "Select Date",
                locale: DateTimePickerLocale.en_us,
                looping: false,
              );
              selectedDate = datePicked;
              if (selectedDate != null) {
                dateString = HelperItems.DateToStringWithFormat(
                    "MM/dd/yyyy", selectedDate);
              }
            }),
          ),

          SizedBox(height: 15),
          buildGridView(),
          SizedBox(height: 8),
          buildDescriptionTF("Description".tr(), descriptionController),

          //selectedLiveDateTime = df.format(DateTime.now());
        ],
      ),
    );
  }

  Widget buildGridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Add Pictures".tr(),
                style: kLabelStyle,
              ),
            ),
            Visibility(
              visible: groupValue == 1 ? images.length < 3 : true,
              child: IconButton(
                  icon: Icon(Icons.add, size: 30, color: Colors.white),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    showOptions(context);
                  }),
            ),
          ],
        ),
        SizedBox(height: 4),
        Container(
          height: 150,
          child: images.isEmpty
              ? Center(
                  child: Text(
                  "No Pictures".tr(),
                  style: kLabelStyle,
                ))
              : GridView.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(images.length, (index) {
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, bottom: 8.0),
                            child: Container(
                              height: 100,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.file(
                                      File(images[index].path),
                                      width: 180,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Image.file(
                        //     File(images[index].path),
                        //     width: 200,
                        //     height: 200,
                        //   ),
                        // ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  // width: 200,
                                  padding: const EdgeInsets.all(2.0),
                                  color: Colors.red,
                                  child: Text(
                                    "Remove".tr(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )),
                            ))
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget showViewWidget() {
    if (isVideo) {
      return _image == null
          ? Center(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 80.0,
              ),
            )
          : filePath == null
              ? Center(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 80.0,
                  ),
                )
              : Image.file(
                  filePath,
                  fit: BoxFit.cover,
                );
    } else {
      return _image == null
          ? Center(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 80.0,
              ),
            )
          : Image.file(
              _image,
              fit: BoxFit.cover,
            );
    }
  }

  clearControllers() {
    images.clear();
    descriptionController.clear();
    titleController.clear();
    cityController.clear();
    countryController.clear();
    priceController.clear();
  }

  disposeControllers() {
    descriptionController.dispose();
    titleController.dispose();
    cityController.dispose();
    countryController.dispose();
    priceController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
    _image?.delete();
    filePath?.delete();
  }

  @override
  bool get wantKeepAlive => true;
}
