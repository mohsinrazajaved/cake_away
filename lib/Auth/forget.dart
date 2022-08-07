import 'package:cake_away/Network/repository.dart';
import 'package:cake_away/Utilities/constants.dart';
import 'package:cake_away/Utilities/widgets.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  bool _saving = false;
  var _repository = Repository();
  TextEditingController emailController = TextEditingController();
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
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
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

  Widget _buildForgetBtn() {
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
          setState(() {
            _saving = true;
          });
          _repository.forgotPassword(emailController.text).then((user) {
            setState(() {
              _saving = false;
            });
            Widgets.showInSnackBar("Password verification email is send", key,
                color: Colors.green);
            emailController.clear();
          });
        },
        child: Text(
          'RESET',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Color(0xFF73AEF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
        title: Text(
          'Forget Password',
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
            child: Stack(
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
                        _buildEmailTF(),
                        _buildForgetBtn(),
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
  }
}
