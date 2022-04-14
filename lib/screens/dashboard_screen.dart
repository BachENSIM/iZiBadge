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
      backgroundColor: CustomColors.backgroundDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: CustomColors.backgroundDark,
        //title: AppBarTitle(),
        title: customWidget,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search_rounded) {
                    customIcon = const Icon(Icons.close);
                    customWidget = ListTile(
                      leading: const Icon(
                        Icons.search_rounded,
                        color: CustomColors.textSecondary,
                        size: 28,
                      ),
                      title: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: _searchCtl,
                        decoration: const InputDecoration(
                          hintText: 'Search by name of event',
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                        style: const TextStyle(
                          color: CustomColors.textSecondary,
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
        backgroundColor: CustomColors.accentLight,
        child: const Icon(
          Icons.add,
          color: CustomColors.textSecondary,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: ItemListTest(),
        ),
      ),
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
