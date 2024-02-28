import 'dart:ui';

import 'package:Easy_Lesson_web/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Easy_Lesson_web/utils/GiornoDetails.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:Easy_Lesson_web/utils/OrarioSettimanale.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
class DayPage extends StatefulWidget {

  final String giorno;
  final GiornoDetails details;
  final bool prof;
  final CarouselController controller;
  final ScrollController scrollController;

  final List<Ora>? listaOre;
  DayPage(this.giorno, this.details, this.prof, this.controller,this.listaOre, this.scrollController);

  @override
  State<DayPage> createState() => _DayPageState();


}

class _DayPageState extends State<DayPage> {
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red, Colors.deepOrange];
  final List<String> array = ["Lunedi","Martedi","Mercoledi","Giovedi","Venerdi"];
  late final GiornoDetails giornoDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {
          setState(() {
              widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
          })

    });

  }


  Widget _buildBody() {
    return new Container(

      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      child:
      new Column(
        // A column widget can have several widgets that are placed in a top down fashion
          children: <Widget>[_getAppTitleWidget(),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildColoredSquare(Colors.grey, 'laboratorio'),
                SizedBox(width: 16), // Aggiungi uno spazio tra i quadratini
                _buildColoredSquare(AppColors.lightBlueColor, 'sostegno'),
              ],
            ),
            SizedBox(height: 60),
            _getListViewWidget(),
          ]),
    );
  }

  Widget _buildColoredSquare(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 8), // Aggiungi uno spazio tra il quadratino e l'etichetta
        Text(label),
      ],
    );
  }

  Widget _getAppTitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(MyFlutterApp.left_open_big),
          onPressed: (){_onSearchButtonPressedLeft();},
        ), // Icona all'estremo sinistro
    Expanded(
    // Per centrare il testo orizzontalmente
          child: Center(
          child: Text(
          widget.giorno,
            style: TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 23
          ),
          ),
          ),
          ),
        SizedBox()// Icona all'estremo destro
      ],
    );

  }

  void _onSearchButtonPressedLeft(){
    widget.controller.jumpToPage(0);
  }

  void _onSearchButtonPressedRight(){
    widget.controller.nextPage();
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
    int nOre = 0;
    if(widget.prof){
      nOre = int.parse(widget.details.oreGiorno);
    }else{
      nOre = (widget.details.nOre);
    }

    return new SingleChildScrollView(
        child :  ListView.builder(
            physics: NoBouncingScrollPhysics(),
          // The number of items to show
            itemCount: nOre,
            shrinkWrap: true,
            // Callback that should return ListView children
            // The index parameter = 0...(itemCount-1)
            itemBuilder: (context, index) {
              print("ora $index +  :" + widget.details!.sostegno[index]);
              // Get the currency at this position
              final String currency = widget.details.getOra(index);

              // Get the icon color. Since x mod y, will always be less than y,
              // this will be within bounds
              final MaterialColor color = _colors[index % _colors.length];


              int numero;
              return
                  GestureDetector(
              child: Center(
              child: _getListItemWidget(currency, color, index + 1,widget.details!.getLab(index) != "" ? widget.details!.getLab(index) : "",
                  widget.details!.sostegno[index] != "" ? widget.details!.sostegno[index] : ""),
              ),
              );



            }));
  }


  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color, int index) {
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text("$index"),
    );
  }

  Text _getTitleWidget(String currencyName) {
    return new Text(
      currencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }


  RichText _getSubtitleText(String priceUsd, String percentChange1h, String lab, int index) {
    TextSpan det;
    if(lab != "") {
      det = new TextSpan(text: lab, style:
      new TextStyle(color: Colors.black),);
    }else{
      det = new TextSpan(text: "", style:
      new TextStyle(color: Colors.black),);
    }
    String percentChangeText = "ore ";
    TextSpan percentChangeTextWidget;


    // Currency price decreased. Color percent change text red
    percentChangeTextWidget = new TextSpan(text:  "",
      style: new TextStyle(color: Colors.black),);


    return new RichText(text: new TextSpan(
        children: [
    WidgetSpan(
    child: SizedBox(height: 5),
    ),
          det,
        ]
    ),
    );
  }

  RichText _getSubtitleText2(int index) {

    String? percentChangeText = widget.listaOre?[index - 1].getOra().toString();
    TextSpan percentChangeTextWidget;


    // Currency price decreased. Color percent change text red
    percentChangeTextWidget = new TextSpan(text: percentChangeText,
      style: new TextStyle(color: Colors.black),);


    return new RichText(text: new TextSpan(
        children: [
          WidgetSpan(
            child: SizedBox(height: 25),
          ),
          percentChangeTextWidget,
        ]
    ),
    );
  }

  ListTile _getListTile(String currency, MaterialColor color, int index, String lab,String sost) {
    List<String> sosts = sost.split(",");
    List<Widget> sostWidgets = [];
    for (String sostItem in sosts) {
      if (sostItem.isNotEmpty) {
        sostWidgets.add(
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue, // Usa lightbluecolor
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: _getSubtitleText(currency, currency, sostItem, index),
          ),
        );
        sostWidgets.add(SizedBox(width: 3)); // Spazio tra i container
      }
    }



    return ListTile(
      leading: _getLeadingWidget(currency, color, index),
      title: _getTitleWidget(currency),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            child: Wrap(
              spacing: 8.0, // Spazio tra gli elementi nella stessa riga
              runSpacing: 8.0, // Spazio tra le righe quando la riga va a capo
              children: [
                if (lab.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: _getSubtitleText(currency, currency, lab, index),
                  ),
                if (lab.isNotEmpty) SizedBox(width: 3),
                ...sostWidgets,
              ],
            ),
          ),
          // Aggiungi un Container per il SubtitleText2
          Container(
            alignment: Alignment.centerRight,
            child: _getSubtitleText2(index),
          ),
        ],
      ),
      isThreeLine: true,
    );


  }

  Container _getListItemWidget(String currency, MaterialColor color, int index, String lab,String sost) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        child: _getListTile(currency, color, index , lab,sost),
      ),
    );
  }

}

class NoBouncingScrollPhysics extends ClampingScrollPhysics {
  /// Creates scroll physics that does not allow the scroll view to bounce.
  const NoBouncingScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  NoBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Questo metodo evita il rimbalzo quando si scorre verso il basso
    return offset;
  }
}
