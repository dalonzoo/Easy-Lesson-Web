import 'dart:convert';

import 'package:Easy_Lesson_web/utils/DataFetcher.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:dio/dio.dart';

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
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // Initial state with a Text widget
  Widget _currentWidget = SlideInUp(
      duration: Duration(milliseconds: 500),
      child: Center( child: Icon(
        MyFlutterApp.easy_icon,
        shadows: <Shadow>[Shadow(color: Colors.black26, blurRadius: 10.0)],
        size: 180,
      )));
  List<Ora> _schedule = [];
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

  Future<void> _fetchData() async {
    try {
      login(true);
      
      final dio = Dio(BaseOptions(
        baseUrl: "your base url",
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30)
      ));

      final futures = await Future.wait([
        fetchProfs('https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=profs', dio),
        fetchProfs('https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=studs', dio),
        fetchData(http.Client()),
      ]);

      profs = futures[0] as List<String>;
      studs = futures[1] as List<String>;
      _schedule = futures[2] as List<Ora>;

      // Update the displayed widget based on data availability
      if (profs.isNotEmpty && studs.isNotEmpty && _schedule.isNotEmpty) {
        setState(() {
          _currentWidget = NavBar2(_schedule, studs, profs, context);
        });
      }else{
        await _fetchData();
      }
    } catch (error) {
      print('Errore nel recupero dei dati: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    //hasCachedAccountInformation();
    //DataFetcher().fetchClassi("https://divine-cell-21ef.danieledalonzon03.workers.dev/?https://www.isrosselliaprilia.edu.it/sites/default/files/orario_dal_18_febbraio.xlsx");
    _fetchData(); // Fetch data on page initialization
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: _currentWidget,
      ),
    );
  }

/*
  Future<StatefulWidget> hasCachedAccountInformation() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    logged = hasCachedAccountInformation;
    return logged ? FutureBuilder(
        future:  Future.wait([fetchData(), fetchProfs("https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=studs"),
          fetchProfs("https://us-central1-easy-lesson.cloudfunctions.net/getListe?lista=profs")]),
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
*/
  Future<http.Response> fetchAlbum() async{
    var uri = Uri.https('us-central1-easy-lesson.cloudfunctions.net', 'getProfs');
    var response = await http.Client().get(uri);
    return response;
  }
  Future<List<String>> fetchProfs(String url, Dio dio) async {
    try {
      final response = await dio.get(url, options: Options(responseType: ResponseType.json));
      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        throw Exception('Errore nel recupero dei dati: Codice stato ${response.statusCode}');
      }
    } catch (e) {
      print("Errore in fetchProfs: $e");
      rethrow;
    }
  }
  List<String> parsePhotos(String responseBody) {
    final data = json.decode(responseBody);
    print(data);

    return data;
  }

  void login(bool redirect) async{
    config.webUseRedirect = redirect;
    final result = await oauth.login();


  }

  Future<List<Ora>> fetchData(http.Client client) async {
    try {
      final response = await client.get(Uri.parse(
          'https://us-central1-easy-lesson.cloudfunctions.net/getXmlOre'));

      if (response.statusCode == 200) {
        return compute(parseXml, response.body);
      } else {
        throw Exception('Errore nel recupero dei dati XML');
      }
    } catch (e) {
      print("Errore in fetchData: $e");
      return [];
    }
  }

  List<Ora> parseXml(String xmlString) {
    final xmlDoc = xml.XmlDocument.parse(xmlString);
    return xmlDoc.findAllElements('ora')
        .map((element) => Ora(element.text))
        .toList();
  }

}
