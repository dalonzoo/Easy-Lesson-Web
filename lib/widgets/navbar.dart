import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:Easy_Lesson_web/pages/Home.dart';
import 'package:Easy_Lesson_web/utils/colors.dart';
import 'package:Easy_Lesson_web/utils/styles.dart';
import 'package:Easy_Lesson_web/widgets/Navigation_drawer_widget.dart';
    
    class NavBar extends StatefulWidget {
      const NavBar({Key? key}) : super(key: key);
    
      @override
      State<NavBar> createState() => _NavBarState();
    }
    
    class _NavBarState extends State<NavBar> {
      late BuildContext context;
      late double screenHeight;
      late double screenWidth;
      late double topPadding;
      late double bottomPadding;
      late double sidePadding;

      @override
      Widget build(BuildContext context) {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
        topPadding = screenHeight * 0.05;
        bottomPadding = screenHeight * 0.03;
        sidePadding = screenWidth * 0.05;
        this.context = context;
        return ScreenTypeLayout(
          desktop: DesktopNavBar(),
          mobile: MobileNavBar(),
        );
      }


      /////////// Mobile ///////////////




      Widget MobileNavBar() {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Navigation Drawer',
            ),
            backgroundColor: const Color(0xff764abc),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Page 1'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.train,
                  ),
                  title: const Text('Page 2'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      }
/////////// Desktop ///////////////
      Widget DesktopNavBar(){

        return Container(
            margin : EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                navLogo(),
                Row(
                    children:[
                      navButton("Opzioni"),
                      navButton("About us"),
                      navButton("Prezzo"),
                      navButton("Contattaci"),
                    ]
                ),
                Container(
                    height: 45,
                    child: ElevatedButton(
                      style: borderedButtonStyle,
                      onPressed: (){},
                      child: Text('Prova',
                        style: TextStyle(color: AppColors.primary),),
                    )
                )
              ],
            )
        );

      }

      Widget navButton(String text){
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(onPressed: (){},
                child: Text(text, style :
                TextStyle(
                    color:Colors.black,
                    fontSize: 18
                )))
        );
      }
      Widget navLogo() {
        return
          GestureDetector(
              onTap: () {
                print('cliccato');
                makeRoutePage(context: context, pageRef: Home());
              }, // Image tapped
              child:
              Container(
                width: 110,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/easy_icon.png'), fit: BoxFit.contain)),
              ));
      }

      void makeRoutePage({required BuildContext context, required Widget pageRef}) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => pageRef),
                (Route<dynamic> route) => false);
      }


    }

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: const Text('Page 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Page 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}


    