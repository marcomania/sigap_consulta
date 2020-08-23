import 'package:flutter/material.dart';

// list of colors that we use in our app
//const kBackgroundColor = Color(0xFFF5F7F1);
const kBackgroundColor = Color(0xFFE7EBEE);
const kPrimaryColor = Color(0xFF1A237E);
const kSecondaryColor = Color(0xFF2997F7);

const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const kBlueColor = Color(0xFF40BAD5);

const kDefaultPadding = 10.0;

const kDetail1 = Color(0xFFEAE7DC);
const kDetail2 = Color(0xFFD1E8E2);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
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
