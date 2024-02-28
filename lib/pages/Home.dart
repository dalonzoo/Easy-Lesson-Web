import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Easy_Lesson_web/pages/containers/container1.dart';
import 'package:Easy_Lesson_web/pages/containers/container2.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
import 'package:Easy_Lesson_web/widgets/NavBar2.dart';
import 'package:xml/xml.dart' as xml;

import 'package:Easy_Lesson_web/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import 'package:progress_state_button/iconed_button.dart';
import '../utils/constants.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:aad_oauth/aad_oauth.dart';

final navigatorKey = GlobalKey<NavigatorState>();
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}


class _HomeState extends State<Home> {

  List<String> profs = [],studs = [];
  bool logged = true;
  late List<Ora> oreList;
  static final Config config = Config(
    tenant: 'd7947d64-f95a-4cf8-b023-8b90fd64d749',
    clientId: '0087c99c-a5e1-41ad-93ac-9c105efe12e4',
    scope: 'openid profile offline_access',
    navigatorKey: navigatorKey,
    redirectUri: '',
    loader: SizedBox(),
  );
  final AadOAuth oauth = AadOAuth(config);
  @override
  Widget build(BuildContext context) {


    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    hasCachedAccountInformation();
    return FutureBuilder(
        future:  Future.wait([login(true),fetchData(), fetchProfs("https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=studs"),
        fetchProfs("https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=profs")]),
        builder:
        (context, AsyncSnapshot<List<dynamic>> snapshot){

          if(snapshot.hasData && snapshot.data![0].toString() == "true"){
            print("loggato :" + snapshot.data![0].toString());
            return NavBar2(snapshot.data![1], snapshot.data![2] , snapshot.data![3], context);
          }else if(snapshot.hasData && snapshot.data![0].toString() == "false"){
            return Material(
                type: MaterialType.transparency,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.security,
                          size: 100.0,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'Abbiamo bisogno di autenticarti con l\'account della scuola per garantire la privacy di ogni utente, grazie.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontFamily: 'HindSiliguri',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        ElevatedButton(
                          onPressed: () {
                            // Aggiungi qui la logica per gestire il clic sul pulsante "Accedi"
                            login(true);
                          },
                          child: Text(
                            'Accedi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: 'HindSiliguri',
                              fontWeight: FontWeight.normal,
                            ),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    )));
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString()); // display error
          }
          else{
            return SlideInUp(
                duration: Duration(milliseconds: 500),
                child: Center( child: Icon(
              MyFlutterApp.easy_icon,
              shadows: <Shadow>[Shadow(color: Colors.black26, blurRadius: 10.0)],
              size: 180,
            )));
          }
        });
  }


  Future<StatefulWidget> hasCachedAccountInformation() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    logged = hasCachedAccountInformation;
    return logged ? FutureBuilder(
        future:  Future.wait([fetchData(), fetchProfs("http://127.0.0.1:5001/easy-lesson/us-central1/getListe?lista=studs"),
          fetchProfs("http://127.0.0.1:5001/easy-lesson/us-central1/getListe?lista=profs")]),
        builder:
            (context, AsyncSnapshot<List<dynamic>> snapshot){

          if(snapshot.hasData){
            print("sono in home :" + snapshot.data!.length.toString());

            return NavBar2(snapshot.data![0], snapshot.data![1] , snapshot.data![2], context);
          }else if (snapshot.hasError) {
            return Text(snapshot.error.toString()); // display error
          }
          else{
            return SlideInUp(
                duration: Duration(milliseconds: 500),
                child: Center( child: Icon(
                  MyFlutterApp.easy_icon,
                  shadows: <Shadow>[Shadow(color: Colors.black26, blurRadius: 10.0)],
                  size: 180,
                )));
          }
        }) :
    Material(
        type: MaterialType.transparency,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 100.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 40.0),
                Text(
                  'Abbiamo bisogno di autenticarti con l\'account della scuola per garantire la privacy di ogni utente, grazie.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'HindSiliguri',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    // Aggiungi qui la logica per gestire il clic sul pulsante "Accedi"
                    login(true);
                  },
                  child: Text(
                    'Accedi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: 'HindSiliguri',
                      fontWeight: FontWeight.normal,
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            )));

  }

  Future<http.Response> fetchAlbum() async{
    var uri = Uri.https('us-central1-easy-lesson.cloudfunctions.net', 'getProfs');
    var response = await http.Client().get(uri);
    return response;
  }
  Future<List<String>> fetchProfs(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });

    return await jsonDecode(response.body).cast<String>();
  }
  List<String> parsePhotos(String responseBody) {
    final data = json.decode(responseBody);
    print(data);

    return data;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();

  }

  void initFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


  Future<List<Ora>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://us-central1-easy-lesson.cloudfunctions.net/getXmlOre'));

      if (response.statusCode == 200) {
        final xmlDoc = xml.XmlDocument.parse(response.body);
        return await xmlDoc.findAllElements('ora')
            .map((element) => Ora(element.text))
            .toList();
      } else {
        return [];
      }
    }on Exception catch(_err){
      return [];
    }
  }

  Future<bool> login(bool redirect) async{
    config.webUseRedirect = redirect;
    final result = await oauth.login();

    print(result.toString());
    var accessToken = await oauth.getAccessToken();

    if (accessToken != null) {

      print("lgin :" + accessToken);
      return true;
    }else{
      print("not logged");
      return false;
    }
  }


}
