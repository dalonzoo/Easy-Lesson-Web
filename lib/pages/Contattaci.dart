import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:Easy_Lesson_web/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
class Contattaci extends StatefulWidget {
  @override
  State<Contattaci> createState() => _ContattaciState();
}

class _ContattaciState extends State<Contattaci> {

  TextEditingController textEditingController1 = TextEditingController(),textEditingController2 = TextEditingController();
  bool validate = true,validate2 = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    //drawer: NavigationDrawerWidget(),
    body: Container(
      margin: EdgeInsets.symmetric(vertical: 40),
  child: Column(
      children: [
        Text("Contattaci", style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
            fontFamily: 'HindSiliguri'

        ),),
        Text("Hai problemi nel trovare il tuo orario? Scrivici qui." ,style: TextStyle(
            fontFamily: 'HindSiliguri'
        ))
      ,Padding(padding: const EdgeInsets.symmetric(
        horizontal: 30
      ),
        child: Column(
          children: [
            SizedBox(height: 25,),
            TextField(

              controller: textEditingController1,
              style: TextStyle(
                  fontFamily: 'HindSiliguri'
              ),
              decoration: InputDecoration(
                errorText: validate ? null : "Non può essere vuoto",
                filled: true,
                fillColor: Colors.white60,
                hintText: "Classe o insegnante",
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 8,),
            TextFormField(
              controller: textEditingController2,
              maxLines: 7,
              style: TextStyle(
                  fontFamily: 'HindSiliguri'
              ) ,
              decoration: InputDecoration(
                errorText: validate2 ?  null : "Non può essere vuoto",
                filled: true,
                fillColor: Colors.white60,
                hintText: "Non riesco a trovare il mio orario...",
                border: InputBorder.none,

              ),
            ),
            SizedBox(height: 16,),
            Container(
              width: double.infinity,
              height: (7 * h!)/100,
              child:   OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1.0, color: Colors.green),
                ),
                child:  Text("Invia", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'HindSiliguri'
                )),
                  onPressed: ()async{
                  if(textEditingController1.text != '' && textEditingController2.text != '') {
                    setState(() {
                      validate = true;
                      validate2 = true;
                    });
                    String email = Uri.encodeComponent(
                        "danieledalonzon03@gmail.com");
                    String subject = Uri.encodeComponent(
                        "Problema nell'App EasyLesson - web");
                    String body = Uri.encodeComponent("Sono : " +
                        textEditingController1.text + textEditingController2
                        .text);
                    print(subject); //output: Hello%20Flutter
                    Uri mail = Uri.parse(
                        "mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  }else{
                    if(textEditingController1.text ==  '')
                    setState(() {
                      validate = false;
                    });
                    else
                      setState(() {
                        validate = true;
                      });

                    if(textEditingController2.text ==  '')
                      setState(() {
                        validate2 = false;
                      });
                    else
                      setState(() {
                        validate2 = true;
                      });


                  }
                  },


        ))]),)
    ,
      ],
    ),
  ));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1?.dispose();
  }
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}