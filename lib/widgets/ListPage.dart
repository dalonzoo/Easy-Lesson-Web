import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async {
  // Bad practice alert :). You should ideally show the UI, and probably a progress view,
  // then when the requests completes, update the UI to show the data.
  List currencies = await getCurrencies();
  print(currencies);

  runApp(new MaterialApp(
    home: new Center(
      child: new ListPage(currencies),
    ),
  ));
}



Future<List> getCurrencies() async {
  String apiUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
  http.Response response = await http.get(Uri.parse(apiUrl));
  return json.decode(response.body);
}

class ListPage extends StatefulWidget {
  final List _currencies;

  ListPage(this._currencies);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.white,
      floatingActionButton: new FloatingActionButton(onPressed: () {
        // Do something when FAB is pressed
      },
        child: new Icon(Icons.add_alert),
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
      // A top margin of 56.0. A left and right margin of 8.0. And a bottom margin of 0.0.
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: new Column(
        // A column widget can have several widgets that are placed in a top down fashion
        children: <Widget>[_getAppTitleWidget(), _getListViewWidget()],
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      'Cryptocurrencies',
      style: new TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }

  Widget _getListViewWidget() {
    // We want the ListView to have the flexibility to expand to fill the
    // available space in the vertical axis
    return new Flexible(
        child: new ListView.builder(
          // The number of items to show
            itemCount: widget._currencies.length,
            // Callback that should return ListView children
            // The index parameter = 0...(itemCount-1)
            itemBuilder: (context, index) {
              // Get the currency at this position
              final String currency = widget._currencies[index];

              // Get the icon color. Since x mod y, will always be less than y,
              // this will be within bounds
              final MaterialColor color = _colors[index % _colors.length];

              return _getListItemWidget(currency, color);
            }));
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

  RichText _getSubtitleText(String priceUsd, String percentChange1h) {
    TextSpan priceTextWidget = new TextSpan(text: "\$$priceUsd\n", style:
    new TextStyle(color: Colors.black),);
    String percentChangeText = "1 hour: $percentChange1h%";
    TextSpan percentChangeTextWidget;


      // Currency price decreased. Color percent change text red
      percentChangeTextWidget = new TextSpan(text: percentChangeText,
        style: new TextStyle(color: Colors.red),);


    return new RichText(text: new TextSpan(
        children: [
          priceTextWidget,
          percentChangeTextWidget
        ]
    ),);
  }

  ListTile _getListTile(String currency, MaterialColor color) {
    return new ListTile(
      leading: _getLeadingWidget(currency, color),
      title: _getTitleWidget(currency),
      subtitle: _getSubtitleText(
          currency, currency),
      isThreeLine: true,
    );
  }

  Container _getListItemWidget(String currency, MaterialColor color) {
    // Returns a container widget that has a card child and a top margin of 5.0
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency, color),
      ),
    );
  }
}