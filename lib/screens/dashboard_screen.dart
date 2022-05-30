import 'package:flutter/material.dart';
import 'package:izibagde/components/app_bar_title.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/item_list_test.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/add_event_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  //pour BottomBar
  int _currentIndex = 0;

  //configurer pour l'en-tete
  Icon customIcon = const Icon(Icons.search_rounded);
  Widget customWidget = AppBarTitle();
  final TextEditingController _searchCtl = TextEditingController();
  bool isFill = false;

  @override
  void initState() {
    // TODO: implement initState
    DatabaseTest.fetchNBRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: CustomColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        //backgroundColor: CustomColors.backgroundAppbar,
        //title: AppBarTitle(),
        title: customWidget,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search_rounded) {
                    customIcon = const Icon(Icons.close);
                    customWidget = ListTile(
                      leading: Icon(
                        Icons.search_rounded,
                        color: CustomColors.textIcons,
                        size: 28,
                      ),
                      title: TextFormField(
                        cursorColor: CustomColors.textIcons,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: _searchCtl,
                        decoration: InputDecoration(
                          hintText: 'Recherche par nom',
                          hintStyle: TextStyle(
                            color: CustomColors.textIcons.withOpacity(0.7),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          isDense: true,
                        ),
                        style: TextStyle(
                          color: CustomColors.textIcons,
                        ),
                        onChanged: (value) {
                          setState(() {
                            DatabaseTest.searchSave = _searchCtl.text;
                            print("search " + DatabaseTest.searchSave);
                          });
                        },
                      ),
                    );
                  } else {
                    setState(() {
                      _searchCtl.clear();
                      DatabaseTest.searchSave = _searchCtl.text;
                    });
                    customIcon = const Icon(Icons.search_rounded);
                    customWidget = AppBarTitle();
                  }
                });
              },
              icon: customIcon)
        ], //Text("Dashboard for Events") ,
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: CustomColors.accentColor,
        child: const Icon(
          Icons.add,
          // color: CustomColors.textIcons,
          size: 32,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
            // left: 16,
            // right: 16,
            // bottom: 20,
            ),
        child: ItemListTest(),
      )),
      // ),
      //Menu bottom bar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   //type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Colors.white38,
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         //title: Text('Settings'),
      //         label: 'Settings',
      //         backgroundColor: Colors.green),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //       /*  if (index == 1) {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (context) => GeneratePage(),
      //           ),
      //         );
      //       }*/
      //     });
      //   },
      // ),
    );
  }
}
