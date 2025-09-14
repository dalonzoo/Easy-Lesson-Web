import 'package:Easy_Lesson_web/pages/Favourites.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Easy_Lesson_web/pages/Contattaci.dart';
import 'package:Easy_Lesson_web/pages/Home.dart';
import 'package:Easy_Lesson_web/pages/containers/container2.dart';
import 'package:Easy_Lesson_web/utils/Ora.dart';
import 'package:Easy_Lesson_web/utils/content_view.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
import 'package:Easy_Lesson_web/utils/tab_controller_handler.dart';
import 'package:Easy_Lesson_web/utils/view_wrapper.dart';
import 'package:Easy_Lesson_web/pages/AboutUs.dart';
import 'package:Easy_Lesson_web/widgets/bottom_bar.dart';
import 'package:Easy_Lesson_web/widgets/custom_tab.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart' hide CarouselController;
import 'package:Easy_Lesson_web/widgets/custom_tab_bar.dart';
import 'package:Easy_Lesson_web/utils/my_flutter_app_icons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'dart:html' as html;
import 'package:aad_oauth/aad_oauth.dart';

final navigatorKey = GlobalKey<NavigatorState>();
class NavBar2 extends StatefulWidget {

  final List<Ora>? oreList;
  final List<String> profList;
  final List<String> studList;
  final BuildContext context;

  NavBar2(this.oreList,this.studList, this.profList,this.context,{super.key});

  @override
  _NavBar2 createState() => _NavBar2();

  static void _launchURL(String _url) async {
    print(_url);
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}

class _NavBar2 extends State<NavBar2>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ItemScrollController itemScrollController;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  late double screenHeight;
  late double screenWidth;
  late double topPadding;
  late double bottomPadding;
  late double customHeight;
  late double sidePadding;
  late carousel_slider.CarouselSliderController buttonCarouselController;
  final ScrollController _scrollController = ScrollController();

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
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
    ));
    tabController = TabController(length: 4, vsync: this);
    itemScrollController = ItemScrollController();
    buttonCarouselController = carousel_slider.CarouselSliderController();


  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    topPadding = screenHeight * 0.02;
    print("altezza " + screenHeight.toString());
    bottomPadding = screenHeight * 0.03;
    sidePadding = screenWidth * 0.05;
    customHeight = (screenHeight) + ((40 * screenHeight) / 100)!;
    print('Width: $screenWidth');
    print('Height: $screenHeight');
    return OKToast(child: Scaffold(
      bottomNavigationBar: SafeArea( child: Container(
        height: (screenHeight * 6.5) / 100,
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Optional
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Change to your own spacing
          children: [
        RichText(
        text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          decorationStyle: TextDecorationStyle.solid,
        ),
          children: <TextSpan>[
            TextSpan(
                text: 'Sign out     •    ',
                style: TextStyle(
                    fontSize: 12,
                    decorationStyle: TextDecorationStyle.solid,
                    color: Colors.green
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                   logout();
                  }),
            TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,
                ),
                text: 'Made with ❤ and Flutter     •    '),
            TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  decorationStyle: TextDecorationStyle.solid,
                  color: Colors.green
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavBar2._launchURL("https://easy-lesson.web.app/EasyLesson_PrivacyPolicy.html");
                  }),


          ],
        ),
      )
          ],
        ),
      )),
      backgroundColor: Color(0x00ffffff),
      key: scaffoldKey, // Status bar color
      endDrawer: drawer(),
      extendBody: true, // very important as noted
      body: SafeArea(
    child: Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        child:
        ViewWrapper(desktopView: desktopView(), mobileView: mobileView(),),
      )),
    ));
  }

  void logout() async {
    await oauth.logout();

  }

  Widget desktopView() {
    List<ContentView> contentViews = [
      ContentView(
        tab: CustomTab(title: 'Home'),
        content: LoginScreen(itemScrollController, widget.oreList, widget.studList, widget.profList, this.tabController,widget.context, Theme.of(context).platform == TargetPlatform.iOS),
      ),
      ContentView(
        tab: CustomTab(title: 'Favourites'),
        content: Favourites(this.tabController,this.customHeight, widget.oreList, widget.context),
      ),
      ContentView(
        tab: CustomTab(title: 'Contact us'),
        content: Contattaci(),
      ),
      ContentView(
        tab: CustomTab(title: 'About us'),
        content: AboutUs(),
      )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// Tab Bar
        IconButton(
              iconSize: screenWidth * 0.06,
              icon: Icon(MyFlutterApp.easy_icon),
              splashColor: Colors.transparent,
              onPressed: () => Navigator. of(context). push(MaterialPageRoute(builder: (BuildContext context) => Home())))
        ,
    Expanded(
    child: Align(
    alignment: Alignment.centerRight,
        child:
        Container(
          width: screenWidth * 0.7,
          height: screenHeight * 0.05,
          child: CustomTabBar(
              controller: tabController,
              tabs: contentViews.map((e) => e.tab).toList()),
        )))]),

        /// Tab Bar View
        Flexible(
        child: Container(
          height: screenHeight * 0.9,
          child: TabControllerHandler(
            tabController: tabController,
            child: TabBarView(
              controller: tabController,
              children: contentViews?.map((e) => e.content).toList() ?? [Container()], // Se è null, usa una lista con un Container vuoto
            ),

          ),
        )),

        /// Bottom Ba
      ],
    );
  }



  Widget mobileView() {


    List<Widget> carouselItems = [


     LoginScreen(this.itemScrollController,widget.oreList, widget.studList, widget.profList, this.tabController, widget.context, Theme.of(context).platform == TargetPlatform.iOS),
      Contattaci(),AboutUs(),Favourites(this.tabController,this.customHeight,widget.oreList, widget.context)
    ];









    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Container(
        color: Colors.white,
        width: screenWidth,
        height: screenHeight,
        child: Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: screenWidth * 0.14),
            IconButton(
                iconSize: screenWidth * 0.14,
                icon: Icon(
                  MyFlutterApp.easy_icon,
                  shadows: <Shadow>[Shadow(color: Colors.black26, blurRadius: 10.0)],
                  size: 60,
                ),
                splashColor: Colors.transparent,
                onPressed: () => Navigator. of(context). push(MaterialPageRoute(builder: (BuildContext context) => Home()))),
            IconButton(
                iconSize: screenWidth * 0.12,
                icon: Icon(Icons.menu_rounded),
                color: Colors.black,
                splashColor: Colors.black,
                onPressed: () => scaffoldKey.currentState?.openEndDrawer())
          ]
      ),
        Container(
            color: Colors.white,
            height: customHeight,
            width: screenWidth,
            child: Center(
                  child: Column(
                    children: [
                      carousel_slider.CarouselSlider(items: carouselItems,
                        carouselController: buttonCarouselController,
                        options:carousel_slider.CarouselOptions(
                          viewportFraction: 1,
                          height: customHeight,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: false,

                          scrollPhysics: NeverScrollableScrollPhysics(),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                        ),


                      )

                      ,],
                  )

          )


  ,  ),
            BottomAppBar()

         ],
        ))),
      ),
    );
  }

  Widget drawer() {

    List<ContentView> contentViews = [
      ContentView(
        tab: CustomTab(title: 'Home'),
        content: LoginScreen(itemScrollController,widget.oreList, widget.studList, widget.studList, this.tabController, widget.context, Theme.of(context).platform == TargetPlatform.iOS),
      ),
      ContentView(
        tab: CustomTab(title: 'Favourites'),
        content: Favourites(this.tabController,customHeight, widget.oreList, widget.context),
      ),
      ContentView(
        tab: CustomTab(title: 'Contact us'),
        content: Contattaci(),
      ),
      ContentView(
        tab: CustomTab(title: 'About us'),
        content: AboutUs(),
      ),
    ];

    return Container(
      width: screenWidth * 0.5,
      child: Drawer(

        child: ListView(
          children: [Container(
              child: Center( child: Icon(
                MyFlutterApp.easy_icon,
                shadows: <Shadow>[Shadow(color: Colors.black26, blurRadius: 10.0)],
                size: 80,
              )),
              height: screenHeight * 0.1),
            Container(
              height: screenHeight * 0.03)] +
              contentViews
                  .map((e) => Container(
                child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Allinea l'icona a destra
                      children: [
                        Text(
                          e.tab.title,
                          style: TextStyle(
                              fontFamily: 'HindSiliguri',
                              fontSize: 15
                          ),
                        ),setIcon(e.tab.title),
                      ],
                    ),
                  onTap: () {
                    setState(() {
                      switch( e.tab.title.toString()){
                        case "Home":
                          buttonCarouselController.animateToPage(0, duration: Duration(microseconds: 600));
                          break;
                        case "Favourites":
                          buttonCarouselController.animateToPage(3, duration: Duration(microseconds: 600));
                        case "Contact us":
                          buttonCarouselController.animateToPage(1, duration: Duration(microseconds: 600));
                          break;
                        case "About us":
                          buttonCarouselController.animateToPage(2, duration: Duration(microseconds: 600));
                          break;
                        default:
                          break;
                      };
                      Navigator.pop(context);
                    });

                  },
                ),
              ))
                  .toList(),
        ),
      ),
    );
  }

  Widget setIcon(String title){
    print("setto per :" + title.toString());

      if (title == 'Home') {
        return Icon(
          Icons.home_outlined, // Puoi sostituire con l'icona desiderata
          color: Colors.black,
        );
      } else if (title == 'Contact us') {
        return Icon(
          Icons.mail_outline, // Puoi sostituire con l'icona desiderata
          color: Colors.black,
        );
      } else if (title == 'Favourites') {
        return Icon(
          Icons.star_border_outlined, // Puoi sostituire con l'icona desiderata
          color: Colors.black,
        );
      } else if (title == 'About us') {
        return Icon(
          Icons.info_outline, // Puoi sostituire con l'icona desiderata
          color: Colors.black,
        );
      } else {
        return Icon(
          Icons.arrow_forward, // Puoi sostituire con l'icona desiderata
          color: Colors.black,
        );
      }




  }
}