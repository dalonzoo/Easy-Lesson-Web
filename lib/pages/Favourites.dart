
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart' hide CarouselController;
//
import 'package:Easy_Lesson_web/utils/GiornoDetails.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:Easy_Lesson_web/utils/OrarioSettimanale.dart';
import 'package:Easy_Lesson_web/utils/constants.dart';
import 'package:Easy_Lesson_web/widgets/DayPage.dart';
//
import 'package:Easy_Lesson_web/widgets/WeekPage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Favourites extends StatefulWidget {
  final TabController tabController;
  final double customHeight;
  final List<Ora>? oreList;

  final BuildContext context;
  Favourites(this.tabController, this.customHeight, this.oreList, this.context);

  @override
  State<Favourites> createState() => _FavouritesState();


}

class _FavouritesState extends State<Favourites> {
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];
  List array = [];
  bool visibility = false;
  late String giorno = "";
  late GiornoDetails details;
  late String name = "";
  late carousel_slider.CarouselSliderController carouselController;
  late IconData favIcon = Icons.favorite_border;
  late ScrollController scrollController = ScrollController();
  OrarioSettimanale? orario;
  late bool prof = false;
  late final box;


  @override
  Widget build(BuildContext context) {

    List<Widget> carouselItems = [
      _buildBody(),
      // Mostra la pagina dell'orario solo quando disponibile
      orario != null
          ? WeekPage(name, orario!, prof, carouselController, widget.oreList, widget.customHeight, this.scrollController, widget.context)
          : Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'Seleziona un preferito per caricare l\'orario',
                  style: TextStyle(fontFamily: 'HindSiliguri', fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    ];


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Container(
        margin: EdgeInsets.symmetric(horizontal: w! / 10, vertical: 40),
          child:SingleChildScrollView(
              controller: scrollController,
              child:
              Center(
            child:
            Column(
              children: [
                carousel_slider.CarouselSlider(items: carouselItems,
                  carouselController: carouselController,
                  options:carousel_slider.CarouselOptions(
                    viewportFraction: 1,
                    height: widget.customHeight,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                  ),)

                ,],
            )),)




    )])));



  }
  void getOrario(String target, bool prof, int ore) async{
    if(prof){
      http.Response response = await http.get(Uri.parse("https://us-central1-easy-lesson.cloudfunctions.net/getOrario?prof=$target&ore=$ore"), headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });
      String res = response.body.toString().replaceAll(r'\"', '"');
      print("risultato chiamata: \n" + res);


      Map<String, dynamic> jsonData = jsonDecode(res.substring(1, res.length - 1));

      setState(() {
        this.orario = OrarioSettimanale.fromJson(jsonData);
        this.name = target;
        this.prof = prof;
        this.visibility = false;
      });
      await carouselController.nextPage();

    }else{

      http.Response response = await http.get(Uri.parse("https://us-central1-easy-lesson.cloudfunctions.net/getOrario?classe=$target&ore=$ore"), headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      });
      String res = response.body.toString().replaceAll(r'\"', '"');


      Map<String, dynamic> jsonData = jsonDecode(res.substring(1, res.length - 1));

      setState(() {
        this.orario = OrarioSettimanale.fromJson(jsonData);
        this.name = target;
        this.prof = prof;
        this.visibility = false;
      });
      await carouselController.nextPage();

    }
  }

  void initStorage() async{
    WidgetsFlutterBinding.ensureInitialized();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OrarioAdapter());
    } // Registra l'adapter per la classe Orario
    await Hive.openBox('orarioBox'); // Apre una scatola Hive per memorizzare gli oggetti Orario
    box = Hive.box('orarioBox');
    getOrari();
  }

  void getOrari() async{

    for (var i = 0; i < box.length; i++) {
      var savedOrarioMap = box.getAt(i);
      if (savedOrarioMap != null) {
        var orarioObject = Orario.fromJson(savedOrarioMap.cast<String, dynamic>());
        setState(() {
          array.add(orarioObject);

        });
        print(orarioObject.name);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initStorage();

    carouselController = carousel_slider.CarouselSliderController();
    print("altezza in pref :" +  widget.customHeight.toString());
    // `orario` verrà caricato quando selezioni un preferito o tramite storage/API
    print('numero ore : ' + (widget.oreList?.length).toString());

  }





  Widget _buildBody() {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: w! / 10, vertical: 40),
      height: widget.customHeight,
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      child:
      new Column(
        // A column widget can have several widgets that are placed in a top down fashion
          children: <Widget>[_getAppTitleWidget(),SizedBox(height: 20,),Visibility(
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.green,
              value: null,
            ),
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: visibility,
          ),
            SizedBox(height: 60),
            _getListViewWidget(),
          ]),
    );
  }

  Widget _getAppTitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [// Icona all'estremo sinistro
        Expanded(
          // Per centrare il testo orizzontalmente
          child: Center(
            child: Text(
              'Orari preferiti',
              style: TextStyle(
                  fontFamily: 'HindSiliguri',
                  fontSize: 26
              ),
            ),
          ),
        ), // Icona all'estremo destro
      ],
    );
  }




  // _getListViewWidget2 non utilizzato: rimosso

  Widget _getListViewWidget() {
    // We want the ListView to have the flexibility to expand to fill the
    // available space in the vertical axis
    return new ListView.builder(
        physics: NoBouncingScrollPhysics(),
        // The number of items to show
        itemCount: array.length,
        shrinkWrap: true,
        // Callback that should return ListView children
        // The index parameter = 0...(itemCount-1)
        itemBuilder: (context, index) {
          // Get the currency at this position
          final String currency = array[index].name;

          // Get the icon color. Since x mod y, will always be less than y,
          // this will be within bounds
          final MaterialColor color = _colors[index % _colors.length];


          return GestureDetector(
            child: Center(
              child: _getListItemWidget(currency, color, array[index].oreTot),
            ),
            onTap: () => {

              selectDay(currency, array[index].prof)

            },
          );


        });
  }

  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color) {
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(currencyName[0]),
    );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
      currencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  void selectDay(String currency, bool prof){
    setState(() {
      visibility = true;
      this.name = currency;
      this.prof = prof;
    });
    try {
      final ore = widget.oreList?.length ?? 8; // fallback di sicurezza
      getOrario(currency, prof, ore);
    } on Exception {
      visibility = false;
    }

  }
  RichText _getSubtitleText(String priceUsd, String percentChange1h,int ore) {
    TextSpan priceTextWidget = new TextSpan(text: "", style:
    new TextStyle(color: Colors.black),);
    String percentChangeText = "ore $ore";
    TextSpan percentChangeTextWidget;


    // Currency price decreased. Color percent change text red
    percentChangeTextWidget = new TextSpan(text: percentChangeText,
      style: new TextStyle(color: Colors.black),);


    return new RichText(text: new TextSpan(
        children: [
          priceTextWidget,
          WidgetSpan(
            child: SizedBox(height: 25),
          )
          ,percentChangeTextWidget
        ]
    ),
    );
  }

  ListTile _getListTile(String currency, MaterialColor color, int ore) {
    return new ListTile(
      leading: _getLeadingWidget(currency, color),
      title: _getTitleWidget(currency),
      subtitle: _getSubtitleText(
          currency, currency, ore),
      isThreeLine: true,
    );
  }

  Container _getListItemWidget(String currency, MaterialColor color, int ore) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency, color, ore),
      ),
    );
  }

}


class OrarioAdapter extends TypeAdapter<Orario> {
  @override
  final typeId = 0; // Identificatore unico per l'oggetto Orario

  @override
  Orario read(BinaryReader reader) {
    var map = reader.readMap();
    return Orario(
      name: map['name'] ?? "",
      prof: map['prof'] ?? false,
      oreTot: map['oreTot'] ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Orario obj) {
    writer.writeMap({
      'name': obj.name,
      'prof': obj.prof,
      'oreTot': obj.oreTot,
    });
  }
}


class Orario {
  final String name;
  final bool prof;
  final oreTot;

  Orario({required this.name, required this.prof, required this.oreTot});

  factory Orario.fromJson(Map<String, dynamic> parsedJson) {
    return Orario(
      name: parsedJson['name'] ?? "",
      prof: parsedJson['prof'] ?? false,
      oreTot: parsedJson['oreTot'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "prof" : this.prof,
      "oreTot" : this.oreTot
    };
  }
}
