import 'package:cake_away/Home/home.dart';
import 'package:cake_away/Home/terms.dart';
import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/Utilities/constants.dart';
import 'package:cake_away/Utilities/widgets.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _saving = false;
  var _repository = Repository();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  BuildContext bcontext;
  var key = GlobalKey<ScaffoldState>();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTF(String title, String hint, IconData icons,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controller,
            //keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icons,
                color: Colors.white,
              ),
              hintText: hint,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: confirmPasswordController,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: kButtonStyle,
        onPressed: () {
          if (!PicitUser.isEmailValid(emailController.text)) {
            Widgets.showInSnackBar("Enter your email", key);
            return;
          }

          if (!PicitUser.isUsernameValid(usernameController.text)) {
            Widgets.showInSnackBar("Enter your username", key);
            return;
          }

          if (!PicitUser.isPasswordValid(passwordController.text)) {
            Widgets.showInSnackBar("Enter your password", key);
            return;
          }

          if (!PicitUser.isConfirmPassword(
              passwordController.text, confirmPasswordController.text)) {
            Widgets.showInSnackBar("Password not matched", key);
            return;
          }

          if (phoneNumberController.text.isEmpty) {
            Widgets.showInSnackBar("Enter phone number", key);
            return;
          }

          if (countryController.text.isEmpty) {
            Widgets.showInSnackBar("Enter country", key);
            return;
          }

          if (cityController.text.isEmpty) {
            Widgets.showInSnackBar("Enter city", key);
            return;
          }
          setState(() {
            _saving = true;
          });
          _repository
              .registerUser(emailController.text, passwordController.text)
              .then((user) {
            if (user != null) {
              authenticateUser(user);
            } else {
              setState(() {
                _saving = false;
              });
              Widgets.showInSnackBar("Authentication Failed", key);
            }
          });
        },
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void authenticateUser(User user) {
    _repository.authenticateUser(user).then((value) {
      if (value) {
        _repository
            .addDataToDb(user, name: usernameController.text)
            .then((value) async {
          setState(() {
            _saving = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Terms(
              callback: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs?.setBool("isLoggedIn", true);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Home();
                }));
              },
            );
          }));
        });
      } else {
        setState(() {
          _saving = false;
        });
        Widgets.showInSnackBar("Authentication Failed", key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return Scaffold(
      key: key,
      backgroundColor: Color(0xFF73AEF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Builder(
              builder: (context) => (Stack(
                children: <Widget>[
                  _bgContainer(),
                  Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          _buildTF('Name', 'Enter your Name', Icons.person,
                              usernameController),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildEmailTF(),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildPasswordTF(),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildConfirmPasswordTF(),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildTF('Phone#', 'Enter your Phone', Icons.phone,
                              phoneNumberController),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildTF('Country', 'Enter your Country', Icons.flag,
                              countryController),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildTF('City', 'Enter your City',
                              Icons.circle_notifications, cityController),
                          SizedBox(
                            height: 20.0,
                          ),
                          _buildSignupBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Container _bgContainer() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController?.dispose();
    usernameController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    phoneNumberController?.dispose();
    countryController?.dispose();
    cityController?.dispose();
  }
}
