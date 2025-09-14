import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:Easy_Lesson_web/pages/Favourites.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:Easy_Lesson_web/pages/Contattaci.dart';
import 'package:Easy_Lesson_web/utils/GiornoDetails.dart';
import 'package:Easy_Lesson_web/utils/MeasureSizeRenderObject.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:Easy_Lesson_web/utils/OrarioSettimanale.dart';
import 'package:Easy_Lesson_web/utils/colors.dart';
import 'package:Easy_Lesson_web/utils/constants.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
import 'package:Easy_Lesson_web/utils/responsive_widget.dart';
import 'package:Easy_Lesson_web/widgets/DayPage.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:Easy_Lesson_web/widgets/ListPage.dart';
import 'package:Easy_Lesson_web/widgets/WeekPage.dart';
import 'package:xml/xml.dart' as xml;
import 'package:Easy_Lesson_web/widgets/gradient_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:dio/dio.dart';

final navigatorKey = GlobalKey<NavigatorState>();
class LoginScreen extends StatefulWidget {
  final ItemScrollController _scrollController;
  final List<Ora>? oreList;
  final List<String> studs;
  final List<String> profs;
  final TabController tabController;
  final BuildContext context;
  final bool isIos;

  LoginScreen(this._scrollController, this.oreList,this.studs, this.profs,this.tabController,this.context,this.isIos ,{super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle ralewayStyle = GoogleFonts.raleway();
  int selectedValue = 1;
  String hint = "Inserisci la classe";
  bool prof = false;
  String giorno = "";
  List<Ora> oreList = [];
  final ScrollController scrollController = ScrollController();
  late carousel_slider.CarouselSliderController buttonCarouselController;

  String selezionato = "";

  Color color = Colors.green;

  late TextEditingController textEditingController1;
  late bool visible = false;
  OrarioSettimanale? orario;
  ButtonState stateOnlyText = ButtonState.idle;
  Color progressColor = AppColors.whiteColor;
  late Size widgetSize;
  bool keyOpen = false;
  bool loading = false;
  late double customHeight;
  late final box;


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
  void initState() {
    // TODO: implement initState
    //getListaProf();
    if(widget.isIos) {
      initStorage();
    }else{
      setState(() {
        this.visible = false;
      });
    }


  buttonCarouselController = carousel_slider.CarouselSliderController();
  textEditingController1 = TextEditingController();

  print('numero ore : ' + (widget.oreList?.length).toString());
  // Inizializzazione rimandata: `orario` verrà valorizzato da `getOrario` quando i dati reali sono disponibili
  customHeight = (h!) + ((40 * h!) / 100);


    super.initState();
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login(bool redirect) async {
    config.webUseRedirect = redirect;
    final result = await oauth.login();

    print(result.toString());
    var accessToken = await oauth.getAccessToken();

    if (accessToken != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(accessToken)));
    }
  }

  void hasCachedAccountInformation() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text('HasCachedAccountInformation: $hasCachedAccountInformation'),
      ),
    );
  }

  void logout() async {
    await oauth.logout();
    showMessage('Logged out');
  }

  void initStorage() async{
    WidgetsFlutterBinding.ensureInitialized();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OrarioAdapter());
    }// Registra l'adapter per la classe Orario

    await Hive.openBox('isNew'); // Apre una scatola Hive per memorizzare gli oggetti Orario
    this.box = Hive.box('isNew');
    if(box.length == 0){
      print('è nuovo');
      aggPref(true);
      setState(() {
        this.visible = true;
      });

    }else {
      for (var i = 0; i < box.length; i++) {
        var savedOrarioMap = box.getAt(i);
        if (savedOrarioMap != null) {
          var orarioObject = IsNew.fromJson(
              savedOrarioMap.cast<String, dynamic>());
          print(orarioObject.check);
          setState(() {
            if (orarioObject.check) {
              this.visible = true;
            }
          });

        }
      }
    }
  }


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://www.isrosselliaprilia.edu.it/sites/default/files/ore_1.xml'));

    if (response.statusCode == 200) {
      final xmlDoc = xml.XmlDocument.parse(response.body);
      final List<Ora> hoursList = xmlDoc.findAllElements('ora')
          .map((element) => Ora(element.text))
          .toList();

      setState(() {
        oreList = hoursList;
      });
    } else {
      throw Exception('Failed to load XML data');
    }
  }


  Future<List<String>> fetchProfs(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });
    debugPrint(response.body);
    debugPrint("\n\n---------------------");
    return jsonDecode(response.body).cast<String>();

  }
  List parsePhotos(String responseBody) {
    final data = json.decode(responseBody);

    return data;
  }
/*
  Widget page1(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: w! / 10, vertical: 150),
        child:SingleChildScrollView(
            child:
            Center(
                child: Column(
                  children: [
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('Trova il tuo orario',
                            style: TextStyle(
                                fontFamily: 'HindSiliguri',
                                fontSize: 50
                            ))
                    ),
                    SizedBox(height: 60,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          activeColor: Colors.green,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              hint = 'Inserisci la classe';
                              prof = false;
                              selectedValue = value as int;
                              this.selezionato = "";
                              textEditingController1.value = TextEditingValue(
                                text: "",
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: "".length),
                                ),
                              );
                            });
                          },
                        ),
                        Image.asset('assets/images/stud2.png',width: 50,height: 50,),
                        SizedBox(width: 100),
                        Radio(
                          activeColor: Colors.green,
                          value: 2,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              hint = 'Inserisci l\'insegnante';
                              prof = true;
                              selectedValue = value as int;
                              this.selezionato = "";
                              textEditingController1.value = TextEditingValue(
                                text: "",
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: "".length),
                                ),
                              );
                            });
                          },
                        ),
                        Image.asset('assets/images/teacher.png',width: 50,height: 50,), // Icona per la checkbox selezionata
                      ],
                    ),
                    SizedBox(height: 40,),
                    Center(
                        child: Column(
                            children: [

                              ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400,
                                  ),
                                  child:

                                  Autocomplete<String>(


                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        color = AppColors.gradient1;
                                        return const Iterable<String>.empty();
                                      }
                                      if( prof){
                                        return profs.where((String option) {
                                          debugPrint('genero per prof');
                                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                        });
                                      }else{
                                        debugPrint('genero per stud');
                                        return studs.where((String option) {
                                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                        });
                                      }

                                    },
                                    optionsViewBuilder: (context, AutocompleteOnSelected<String> onSelected,Iterable <String> options){
                                      return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                              elevation: 4.0,
                                              child: ConstrainedBox(
                                                  constraints:
                                                  const BoxConstraints(maxHeight: 200, maxWidth: 400),
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      itemCount: options.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        final String option = options.elementAt(index);
                                                        return InkWell(
                                                          onTap: () {
                                                            debugPrint('Cliccato ');



                                                            onSelected(option);
                                                          },
                                                          child: Container(
                                                            color: Colors.white,
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Text(option),
                                                          ),
                                                        );
                                                      }
                                                  ))));
                                    }
                                    ,
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      textEditingController1 = textEditingController;
                                      textEditingController1.text = '';
                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        onFieldSubmitted: (str) => onFieldSubmitted(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(27),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.greyColor,
                                                width: 1
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: AppColors.gradient1,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),

                                          hintText: hint,

                                        ),
                                      );
                                    },
                                    onSelected: (String selection) {
                                      debugPrint('You just selected $selection');
                                      selezionato = selection;
                                    },



                                  )
                              ),
                              SizedBox(height: 80,),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      color,
                                      color,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(395,55),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: (){

                                    buttonCarouselController.nextPage();

                                  },
                                  child: const Text('Trova orario',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      )),



                                )
                                ,


                              )
                            ]
                        )),

                  ],
                )
            )
        )

    );
  }
*/




  @override
  Widget build(BuildContext context) {

    List<Widget> carouselItems = [
      Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body:
      Center(
          child: Column(
            children: [
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('Trova il tuo orario',
                      style: TextStyle(
                          fontFamily: 'HindSiliguri',
                          fontSize: 32
                      ))
              ),
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 1,
                    activeColor: Colors.green,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        stateOnlyText = ButtonState.idle;

                        hint = 'Inserisci la classe';
                        prof = false;
                        selectedValue = value as int;
                        textEditingController1.text = '';
                        selezionato = '';
                      });
                    },
                  ),
                  Image.asset('assets/images/stud_icon.png',width: 50,height: 50,),
                  SizedBox(width: 80),
                  Radio(
                    activeColor: Colors.green,
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        stateOnlyText = ButtonState.idle;

                        hint = 'Inserisci l\'insegnante';
                        prof = true;
                        selectedValue = value as int;
                        textEditingController1.text = '';
                        selezionato = '';
                      });
                    },
                  ),
                  Image.asset('assets/images/prof_icon.png',width: 50,height: 50,), // Icona per la checkbox selezionata
                ],
              ),
              SizedBox(height: 40,),
              Center(
                  child: Column(
                      children: [

                        ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child:
                          Autocomplete<String>(

                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {

                                  return const Iterable<String>.empty();
                                }
                                if( prof){
                                  return widget.profs.where((String option) {
                                    debugPrint('genero per prof');
                                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                  });
                                }else{
                                  debugPrint('genero per stud');
                                  return widget.studs.where((String option) {
                                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                  });
                                }

                              },
                              optionsViewBuilder: (context, AutocompleteOnSelected<String> onSelected,Iterable <String> options){
                                return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                        elevation: 4.0,
                                        child: ConstrainedBox(
                                            constraints:
                                            const BoxConstraints(maxHeight: 180, maxWidth: 400),
                                            child: ListView.builder(
                                                physics: NoBouncingScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: options.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final String option = options.elementAt(index);
                                                  return InkWell(
                                                    onTap: () {
                                                      debugPrint('Cliccato ');



                                                      onSelected(option);
                                                    },
                                                    child: Container(
                                                      color: Colors.white,
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Text(option),
                                                    ),
                                                  );
                                                }
                                            ))

                                        ));
                              }
                              ,
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                textEditingController1 = textEditingController;
                                return TextFormField(
                                  scrollPadding: EdgeInsets.only(bottom:40),
                                  controller: textEditingController1,
                                  focusNode: focusNode,
                                  onFieldSubmitted: (str) => onFieldSubmitted(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(22),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.greyColor,
                                          width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.gradient1,
                                          width: 2
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    hintText: hint,

                                  ),
                                );
                              },

                              onSelected: (String selection) {
                                debugPrint('You just selected $selection');

                                setState(() {
                                  this.selezionato = selection;
                                  textEditingController1.text = this.selezionato;
                                  color = Colors.green;
                                });
                              },



                            ),

                        ),
                        SizedBox(height: 80,),
                        Stack(children: [SlideInRight(child:
                        Container(
                          child: ProgressButton.icon(iconedButtons: {
                            ButtonState.idle:
                            IconedButton(
                                text: "Trova orario",
                                icon: Icon(Icons.search,color: Colors.white),
                                color: Colors.green),
                            ButtonState.loading:
                            IconedButton(
                                text: "Loading",
                                color: Colors.green),
                            ButtonState.fail:
                            IconedButton(
                                text: "Orario non presente",
                                icon: Icon(Icons.cancel,color: Colors.white),
                                color: Colors.red.shade300),
                            ButtonState.success:
                            IconedButton(
                                text: "Success",
                                icon: Icon(Icons.check_circle,color: Colors.white,),
                                color: Colors.green.shade400)
                          },
                              onPressed: (){
                                this.selezionato = textEditingController1.text;
                                print(this.selezionato);
                                if(prof){
                                  if(widget.profs.contains(selezionato)) {
                                    setState(() {
                                      stateOnlyText = ButtonState.loading;
                                    });
                                    if(loading == false) {
                                      loading = true;
                                      try {
                                        getOrario(
                                            textEditingController1.text, prof,
                                            widget.oreList!.length);
                                      } on Exception catch (err) {
                                        debugPrint('getOrario error (prof): $err');
                                        stateOnlyText = ButtonState.fail;
                                      }
                                    }
                                  }else {
                                    setState(() {
                                      stateOnlyText = ButtonState.fail;
                                    });
                                    Future.delayed(Duration(milliseconds: 1000), () {
                                      // Il tuo codice da eseguire dopo 500 ms
                                      setState(() {
                                        stateOnlyText = ButtonState.idle;
                                      });
                                    });
                                  }
                                }else{
                                      if(widget.studs.contains(selezionato)) {
                                        setState(() {
                                          stateOnlyText = ButtonState.loading;
                                        });
                                        if(loading == false) {
                                          loading = true;
                                          try {
                                            getOrario(
                                                textEditingController1.text, prof,
                                                widget.oreList!.length);
                                          } on Exception catch (err) {
                                            debugPrint('getOrario error (classe): $err');
                                            stateOnlyText = ButtonState.fail;
                                          }
                                        }
                                      }else{
                                        setState(() {
                                          stateOnlyText = ButtonState.fail;
                                        });

                                        Future.delayed(Duration(milliseconds: 1000), () {
                                          // Il tuo codice da eseguire dopo 500 ms
                                          setState(() {
                                            stateOnlyText = ButtonState.idle;
                                          });
                                        });
                                }


                                }
                              },
                              state: stateOnlyText),


                        ))],),

                      ]
                  )),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: LoadingIndicator(
                    indicatorType: Indicator.lineScale, /// Required, The loading type of the widget
                    colors: [progressColor],       /// Optional, The color collections
                    strokeWidth: 1,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                    backgroundColor: Colors.white,      /// Optional, Background of the widget
                    pathBackgroundColor: Colors.green   /// Optional, the stroke backgroundColor
                ),
              )


            ],
          )



      )),
      // Mostra la pagina dell'orario solo quando `orario` è disponibile
      orario != null
          ? WeekPage(textEditingController1.text, orario!, this.prof, buttonCarouselController, widget.oreList, this.customHeight, this.scrollController, widget.context)
          : Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Text(
                  'Seleziona una classe o un docente per caricare l\'orario',
                  style: TextStyle(fontFamily: 'HindSiliguri', fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      Favourites(widget.tabController,this.customHeight, widget.oreList,widget.context ),
      Contattaci(),

    ];

    print("heright ott" + h.toString());


return Container(
        margin: EdgeInsets.symmetric(horizontal: w! / 10, vertical: 40),
        child:SingleChildScrollView(
            controller: scrollController,
            child:
            Center(
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Visibility(
                            visible: !this.visible,
                            child: carousel_slider.CarouselSlider(items: carouselItems,
                              carouselController: buttonCarouselController,

                              options:carousel_slider.CarouselOptions(
                                height: this.customHeight,
                                viewportFraction: 1,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: false,
                                scrollPhysics: NeverScrollableScrollPhysics(),
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                              ),))
                        // Widget principale
                        ,
                        // Widget sovrapposto (visibile solo quando _isOverlayVisible è true)
                        Visibility(
                            visible: this.visible,
                            child: Center(
                              child: Container(
                                color: Colors.white,
                                width: w!,
                                height: 0.50 * h!,
                                margin: const EdgeInsets.all(10.0),
                                child: ClipRect(
                                  /** Banner Widget **/
                                  child: Banner(
                                    message: "",
                                    location: BannerLocation.bottomStart,
                                    color: Colors.green,
                                    child: Center(
                                      child: Container(
                                        color: Colors.white,
                                        width: w!,
                                        height: 0.50 * h!,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                                            crossAxisAlignment: CrossAxisAlignment.center, // Centra orizzontalmente
                                            children: <Widget>[
                                              const SizedBox(height: 10),
                                              Text(
                                                'Aggiungi l\'App alla home!',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 26,
                                                  fontFamily: 'HindSiliguri',
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Center(
                                                child: Container(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      RichText(

                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontSize: 16, // Imposta la grandezza del testo
                                                            color: Colors.black,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: "Clicca su ",
                                                            ),
                                                            WidgetSpan(
                                                              child: Image.asset(
                                                                'assets/images/share_ios.png',
                                                                width: 25,
                                                                height: 25,
                                                              ), // Icona per la checkbox selezionata
                                                            ),
                                                            TextSpan(
                                                              text: '  poi clicca su "aggiungi a schermata home".',
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      // Altri widget al centro
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Altri widget allineati al centro
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Banner
                                ), //ClipRect
                              ), //container
                            )

                        ),
                        // Usa SizedBox per mantenere la dimensione anche quando il widget è invisibile
                        Visibility(
                            visible: this.visible,
                            child: Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: (){
                                  // Aggiungi qui la logica per chiudere il widget
                                  print('Widget chiuso!');


                                  setState(() {
                                    aggPref(false);
                                    this.visible = false;
                                  });
                                },
                              ),
                            ))
                        ,],
                    ),






                  ],
                )
            )


        ));



  }

  String getSelezionato(){
    return this.selezionato;
  }

  void getListaProf() async {
  // NOTE: Se servirà accumulare i docenti, reinserire una lista qui.
    try {
      // Effettua una richiesta HTTP per ottenere il contenuto del file Excel

      http.Response response = await http.get(Uri.parse("https://www.isrosselliaprilia.edu.it/sites/default/files/orario_dal_15_gennaio.xlsx"));

      if (response.statusCode == 200) {
        // Ottieni il contenuto del file Excel
        var bytes = response.bodyBytes;
        var excel = Excel.decodeBytes(bytes);
        print("sono i lettura");
        // Estrai i dati dall'excel
        for (var table in excel.tables.keys) {
          print(table); // nome del foglio di lavoro
          print(excel.tables[table]!.maxColumns);
          print(excel.tables[table]!.maxRows);
          for (var _ in excel.tables[table]!.rows) {

            // Itera su tutte le colonne della riga corrente

          }
        }

        // Aggiorna lo stato con i dati dell'excel
        setState(() {});

      } else {
        // Gestisci gli errori di richiesta HTTP
        print('Failed to load Excel file. Status code: ${response.statusCode}');
      }
    } catch (e) {

      // Gestisci altri tipi di errori
      print('Error: $e');
    }
  }
  // Metodo di debug rimosso perché non utilizzato: _readExcelFromUrl()

Future<void> getOrario(String target, bool prof, int ore) async {
  print("cerco orario\n");
  setState(() => stateOnlyText = ButtonState.loading);

  final String baseUrl = "https://us-central1-easy-lesson.cloudfunctions.net/getOrario";
  final String query = prof ? "prof=$target" : "classe=${Uri.encodeComponent(target)}";
  final String url = "$baseUrl?$query&ore=$ore";

  int retries = 3;
  while (retries > 0) {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {

        String res = response.body.toString().replaceAll(r'\"', '"');



        Map<String, dynamic> jsonData = jsonDecode(res.substring(1, res.length - 1));

        setState(() {
          orario = OrarioSettimanale.fromJson(jsonData);
          stateOnlyText = ButtonState.idle;
          loading = false;
        });

        buttonCarouselController.nextPage();
        return;
      } else {
        throw Exception('Errore nel caricamento dell\'orario: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('Timeout durante il recupero dell\'orario. Tentativi rimanenti: ${retries - 1}');
    } catch (e) {
      print('Errore durante il recupero dell\'orario: $e');
      break; // Esci dal ciclo per errori non di timeout
    }

    retries--;
    await Future.delayed(Duration(seconds: 2)); // Breve pausa prima del retry
  }

  setState(() {
    stateOnlyText = ButtonState.fail;
    loading = false;
  });
}

  Future<List<String>> fetchXMLAndConvertToList() async {
    String url = 'https://www.isrosselliaprilia.edu.it/sites/default/files/ore_0.xml';
    List<String> timeList = [];

    try {

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Il documento XML è stato recuperato con successo, effettua il parsing
        xml.XmlDocument xmlDocument = xml.XmlDocument.parse(response.body);

        // Estrai i valori all'interno degli elementi <lab> e aggiungili alla lista
        Iterable<xml.XmlElement> labElements = xmlDocument.findAllElements('lab');
        for (var element in labElements) {
          timeList.add(element.text);
        }
      } else {
        // La richiesta non è andata a buon fine, gestisci l'errore qui
        print('Errore nella richiesta HTTPS: ${response.statusCode}');
      }
    } catch (e) {
      // Gestisci eventuali eccezioni
      print('Errore durante la richiesta HTTPS: $e');
    }

    return timeList;
  }
  void aggPref(bool check) async{

// Salva un orario con una chiave unica (ad esempio, il nome dell'orario come chiave)
    IsNew ogg = new IsNew(check: check);
    try {
      box.put("isNew", ogg.toJson());

    }catch(exception){
      print(exception.toString());
    }
  }


}

class OrarioAdapter extends TypeAdapter<IsNew> {
  @override
  final typeId = 0; // Identificatore unico per l'oggetto Orario

  @override
  IsNew read(BinaryReader reader) {
    var map = reader.readMap();
    return map['isNew'];
  }

  @override
  void write(BinaryWriter writer,IsNew value) {
    writer.writeMap({
      'isNew': value
    });
  }
}

class IsNew {
  final bool check;

  IsNew({required this.check});

  factory IsNew.fromJson(Map<String, dynamic> parsedJson) {
    return IsNew(
      check: parsedJson['isNew'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isNew": this.check,
    };
  }
}


