import 'package:cake_away/Auth/forget.dart';
import 'package:cake_away/Auth/signup.dart';
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _saving = false;
  var key = GlobalKey<ScaffoldState>();
  User user;

  var _repository = Repository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Forget()));
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildSkipBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0),
      width: double.infinity,
      child: ElevatedButton(
        style: skipkButtonStyle,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs?.setBool("isLoggedIn", true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Home();
          }));
        },
        child: Text(
          'SKIP',
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

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        style: kButtonStyle,
        onPressed: () {
          if (!PicitUser.isEmailValid(emailController.text)) {
            Widgets.showInSnackBar("Enter your email", key);
            return;
          }

          if (!PicitUser.isPasswordValid(passwordController.text)) {
            Widgets.showInSnackBar("Enter your password", key);
            return;
          }

          setState(() {
            _saving = true;
          });

          _repository
              .signIn(emailController.text, passwordController.text)
              .then((value) async {
            if (value == null) {
              setState(() {
                _saving = false;
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs?.setBool("isLoggedIn", true);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return Home();
              }));
            } else {
              setState(() {
                _saving = false;
              });
              Widgets.showInSnackBar(value, key);
            }
          });
        },
        child: Text(
          'LOGIN',
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
    setState(() {
      _saving = true;
    });
    _repository.authenticateUser(user).then((value) {
      if (value) {
        _repository.addDataToDb(user).then((value) {
          setState(() {
            _saving = false;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Terms(
              callback: () {
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Home();
        }));
      }
    });
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Signup()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Color(0xFF73AEF5),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
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
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 60.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        _buildLoginBtn(),
                        _buildSkipBtn(),
                        _buildSignInWithText(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController?.dispose();
    passwordController?.dispose();
  }
}
