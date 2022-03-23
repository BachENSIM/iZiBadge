import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/app_bar_title.dart';

import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/item_list.dart';
import 'package:izibagde/components/item_list_test.dart';
import 'package:izibagde/components/item_list_test_v2.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/add_event_screen.dart';
import 'package:sticky_headers/sticky_headers.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  int _currentIndex = 0;
  bool _isOrganisateur = false;
  bool _isInviteur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitle() //Text("Dashboard for Events") ,
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: CustomColors.firebaseOrange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body:
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              child:
              ItemListTest(),


            ),
          ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        //type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white38,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              //title: Text('Settings'),
              label: 'Settings',
              backgroundColor: Colors.green),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            /*  if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GeneratePage(),
                ),
              );
            }*/
          });
        },
      ),
    );
  }
}
