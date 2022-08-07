import 'package:cake_away/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';

class Widgets {
  static void showInSnackBar(String value, GlobalKey<ScaffoldState> key,
      {MaterialColor color}) {
    key?.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.red,
        content: Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Widget buildTF(String text, TextEditingController controller,
    {String hint = "Enter "}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10.0),
      Text(
        text,
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 50.0,
        child: TextField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(14),
            hintText: hint.tr() + text,
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
      SizedBox(height: 10.0),
    ],
  );
}

Widget buildDescriptionTF(String text, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        text,
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 130.0,
        child: TextField(
          controller: controller,
          obscureText: false,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLines: 10,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(14),
            hintText: "Description here!".tr(),
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
      SizedBox(height: 20.0),
    ],
  );
}

Widget buildDatePicker(String text, Function ontap) {
  // setState(() {
  //   dateString = HelperItems.DateToStringWithFormat("MM/dd/yyyy", datePicked);
  //   weekController.text = Jiffy(DateTime.now()).week.toString();
  // });
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Event Date',
        style: kLabelStyle,
      ),
      SizedBox(height: 15.0),
      GestureDetector(
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        onTap: ontap,
      ),
    ],
  );
}

//Helper methods

selectImageFromCamera(Function(PickedFile pickedFile) callback) async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
  callback(pickedFile);
}

selectImageFromGallery(Function(PickedFile pickedFile) callback) async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  callback(pickedFile);
}
