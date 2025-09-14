import 'package:flutter/material.dart';

class ThemeSelector{
  static TextStyle? selectHeadline(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth > 950 && screenHeight > 550){
      return Theme.of(context).textTheme.displayLarge;
    } else if (screenWidth > 650 && screenHeight > 550){
      return Theme.of(context).textTheme.displayMedium;
    } else {
      return Theme.of(context).textTheme.displaySmall;
    }
  }

  static TextStyle? selectSubHeadline(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth > 715 && screenHeight > 350){
      return Theme.of(context).textTheme.titleMedium;
    } else {
      return Theme.of(context).textTheme.titleSmall;
    }
  }
  static TextStyle? selectBodyText(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth > 1050 && screenHeight > 850){
      return Theme.of(context).textTheme.bodyLarge;
    } else if(screenWidth > 850 && screenHeight > 700){
      return Theme.of(context).textTheme.bodyMedium;
    } else {
      return Theme.of(context).textTheme.bodySmall;
    }
  }

}