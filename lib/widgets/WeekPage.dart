
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:convert';
import 'dart:ui';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Easy_Lesson_web/utils/GiornoDetails.dart';
import 'package:Easy_Lesson_web/utils/MeasureSizeRenderObject.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:Easy_Lesson_web/utils/OrarioSettimanale.dart';
import 'package:Easy_Lesson_web/utils/colors.dart';
import 'package:Easy_Lesson_web/utils/constants.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
import 'package:Easy_Lesson_web/utils/responsive_widget.dart';
import 'package:Easy_Lesson_web/widgets/DayPage.dart';
import 'package:Easy_Lesson_web/widgets/ListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import 'package:Easy_Lesson_web/widgets/WeekPage.dart';
import 'package:Easy_Lesson_web/widgets/gradient_button.dart';

import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

class WeekPage extends StatefulWidget {

  final String _name;
  final OrarioSettimanale orarioSettimanale;
  final bool prof;
  final CarouselController controller;
  final List<Ora>? listaOre;
  final ScrollController scrollController;
  final double customHeight;


  final BuildContext context;

  WeekPage(this._name, this.orarioSettimanale, this.prof, this.controller, this.listaOre, this.customHeight, this.scrollController,
      this.context);

  @override
  State<WeekPage> createState() => _WeekPageState();


}

class _WeekPageState extends State<WeekPage> {
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red, Colors.deepOrange];
  final List<String> array = ["Lunedi","Martedi","Mercoledi","Giovedi","Venerdi"];
  late String giorno = "";
  late GiornoDetails details;
  late CarouselController carouselController;
  late IconData favIcon = Icons.favorite_border;
  late int oreTot = 0;
  late final box;


  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      _buildBody(),
      DayPage('Lunedi',widget.orarioSettimanale.giorni["giorno0"]!, widget.prof, carouselController, widget.listaOre, widget.scrollController),
      DayPage('Martedi',widget.orarioSettimanale.giorni["giorno1"]!, widget.prof, carouselController, widget.listaOre, widget.scrollController),
      DayPage('Mercoledi',widget.orarioSettimanale.giorni["giorno2"]!, widget.prof, carouselController, widget.listaOre, widget.scrollController),
      DayPage('Giovedi',widget.orarioSettimanale.giorni["giorno3"]!, widget.prof, carouselController, widget.listaOre, widget.scrollController),
      DayPage('Venerdi',widget.orarioSettimanale.giorni["giorno4"]!, widget.prof, carouselController, widget.listaOre, widget.scrollController),

    ];

    print("in week custom height :"  +widget.customHeight.toString());
    return Container(
            child:
            Center(
                child: Column(
                  children: [
                    CarouselSlider(items: carouselItems,
                      carouselController: carouselController,
                      options:CarouselOptions(
                        height: widget.customHeight,
                        viewportFraction: 1,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                      ),)

                    ,],
                )
            )


    );



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    carouselController = CarouselController();

    initStorage();
    details = widget.orarioSettimanale.giorni["giorno0"]!;
    print(widget.orarioSettimanale.giorni["giorno0"]!);

   for(int i = 0;i < widget.orarioSettimanale.giorni.length;i++){
     if(widget.prof) {
       oreTot +=
           widget.orarioSettimanale.giorni["giorno" + i.toString()]!.nOreProf;
     }else{
       oreTot +=
           widget.orarioSettimanale.giorni["giorno" + i.toString()]!.nOre;
     }
     }
  }

  Widget _buildBody() {
    return new Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      child:
      new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[_getAppTitleWidget(),
          SizedBox(height: 60),
       _getListViewWidget(),
      ]),
    );
  }

  Widget _getAppTitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(MyFlutterApp.left_open_big),
          onPressed: (){
            widget.controller.previousPage();
          },
        ), // Icona all'estremo sinistro
        Expanded(
          // Per centrare il testo orizzontalmente
          child: Center(
            child: Text(
              'Orario di ' + widget._name,
              style: TextStyle(
    fontFamily: 'HindSiliguri',
    fontSize: 26
    ),
            ),
          ),
        ),
        GestureDetector(
          child: IconButton(
            icon: Icon(favIcon),
            onPressed: (){
              setState(() {
                if(favIcon == Icons.favorite_border){
                  aggPref(widget.orarioSettimanale,widget._name);
                }else{
                  rimuoviPref(widget._name);
                }
              });
            },
          ),
          onTap: (){

          },
        )
        // Icona all'estremo destro
      ],
    );
  }


  void aggPref(OrarioSettimanale orario, String name) async{

// Salva un orario con una chiave unica (ad esempio, il nome dell'orario come chiave)
    Orario orario1 = Orario(name: name, prof: widget.prof, oreTot: this.oreTot);
    try {
      box.put('' + name, orario1.toJson());
      setState(() {
        if(favIcon == Icons.favorite_border){
          favIcon = Icons.favorite;

        }else{
          favIcon = Icons.favorite_border;
        }
      });
      await showToast(name + " aggiunto ai preferiti", context: widget.context);
    }catch(exception){
      print(exception.toString());
    }
  }

  void rimuoviPref(String name) async{

// Rimuovere un oggetto dallo storage
    try{
    box.delete(name);
    setState(() {
      if(favIcon == Icons.favorite_border){
        favIcon = Icons.favorite;

      }else{
        favIcon = Icons.favorite_border;
      }
    });
    await showToast(name + " rimosso dai preferiti", context: widget.context);
  }catch(exception){
  print(exception.toString());
  }
  }

  void initStorage() async{
    WidgetsFlutterBinding.ensureInitialized();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OrarioAdapter());
    }// Registra l'adapter per la classe Orario
    await Hive.openBox('orarioBox'); // Apre una scatola Hive per memorizzare gli oggetti Orario
    this.box = Hive.box('orarioBox');
    checkIfExists(widget._name);
  }

  Future<void> checkIfExists(String key) async {


    if (box.containsKey(key)) {
      setState(() {
        favIcon = Icons.favorite;
      });
    } else {
      setState(() {
        favIcon = Icons.favorite_border;
      });

    }
  }

  Widget _getListViewWidget2() {
    // We want the ListView to have the flexibility to expand to fill the
    // available space in the vertical axis
    return new Flexible(
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: array.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                height: 50,
                margin: EdgeInsets.all(2),
                color: Colors.white,
                child: Center(
                    child: Text('${array[index]} (${array[index]})',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    )
                ),
              );
            }
        ));
  }

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
              final String currency = array[index];

              // Get the icon color. Since x mod y, will always be less than y,
              // this will be within bounds
              final MaterialColor color = _colors[index % _colors.length];

              return GestureDetector(
                child: Center(
                  child: _getListItemWidget(currency, color, getOre(widget.prof, index)),
                ),
                onTap: () => {

                  selectDay(index)

            },
              );


            });
  }
  
  int getOre(bool prof, int index){
    if(prof){
      return widget.orarioSettimanale.giorni["giorno$index"]!.nOreProf as int;
    }else{
      return widget.orarioSettimanale.giorni["giorno$index"]!.nOre as int;
    }
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

  void selectDay(int index){
    setState(() {
      switch (index) {
        case 0:
          details = widget.orarioSettimanale.giorni["giorno0"]!;

          giorno = array[index];
          break;
        case 1:
          details = widget.orarioSettimanale.giorni["giorno1"]!;

          giorno = array[index];
          break;

        case 2:

          details = widget.orarioSettimanale.giorni["giorno2"]!;

          giorno = array[index];
          break;
          break;
        case 3:
          details = widget.orarioSettimanale.giorni["giorno3"]!;

          giorno = array[index];

          break;
        case 4:
          details = widget.orarioSettimanale.giorni["giorno4"]!;
          giorno = array[index];
          break;
        default:
          print("Il numero non corrisponde a nessuno dei casi specificati.");
          break;
      }

      carouselController.jumpToPage(index + 1);
    });


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




