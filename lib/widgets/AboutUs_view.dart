import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Easy_Lesson_web/utils/Values.dart';

class AboutUs_view extends StatefulWidget {
  AboutUs_view({Key? key}) : super(key: key);

  static void _launchURL(String _url) async {
    print(_url);
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  static List<Widget> _createButtons(int len) {
    List<Widget> btns = [];
    var names = Values.links.keys.toList();
    for (int i = 0; i < len; i++) {
      btns.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text(
              names[i],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ), backgroundColor: Colors.white,
              shadowColor: Colors.green,
              fixedSize: const Size(550, 50),
            ),
            onPressed: () => _launchURL(Values.links.values.toList()[i]),
          ),
        ),
      );
    }
    return btns;
  }

  @override
  State<AboutUs_view> createState() => _AboutUs_viewState();
}

class _AboutUs_viewState extends State<AboutUs_view> {
  final List<Widget> buttons = AboutUs_view._createButtons(
    Values.links.keys.length,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //avatar
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: SizedBox(),
            ),
            //name
            SelectableText(
              Values.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            //description
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SelectableText(
                Values.description,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            //buttons
            ...buttons,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                child: const Text(
                  'Powered by Daniele D\'Alonzo',
                  style: TextStyle(
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
            ),],
        ),
      ),

    );
  }
}