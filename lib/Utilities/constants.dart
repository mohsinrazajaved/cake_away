import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
  elevation: MaterialStateProperty.all(5.0),
  foregroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

final skipkButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
  elevation: MaterialStateProperty.all(0),
  foregroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  backgroundColor: MaterialStateProperty.resolveWith<Color>(
    (Set<MaterialState> states) =>
        states.contains(MaterialState.disabled) ? Colors.white : Colors.white,
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
