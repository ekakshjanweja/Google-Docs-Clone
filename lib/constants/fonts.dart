import 'package:flutter/material.dart';
import 'package:google_docs_clone/constants/colors.dart';

class Fonts {
  //H1 Bold

  static TextStyle h1Bold(BuildContext context) {
    return TextStyle(
      color: kBlackColor,
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.height * 0.035,
    );
  }

  //Button Text

  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      color: kBlackColor,
      fontWeight: FontWeight.normal,
      fontSize: MediaQuery.of(context).size.height * 0.02,
    );
  }
}
