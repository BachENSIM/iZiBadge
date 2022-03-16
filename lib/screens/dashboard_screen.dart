import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/app_bar_title.dart';

import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/item_list.dart';
import 'package:izibagde/components/item_list_test.dart';
import 'package:izibagde/model/database.dart';
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
  int _currentIndex = 0;

/*  List<String> listID = [];
  List<String> listRole = [];
*//*
  dynamic data;
  Future<dynamic> getData() async {
    final DocumentReference document = FirebaseFirestore.instance.collection('evenements').doc(Database.userUid).collection('items').doc().collection('participation').doc();

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data = snapshot.data;

      });
    });
  }*//*

  void fetchDataID() async {
    var dataID = await FirebaseFirestore.instance
        .collection('evenements')
        .doc(Database.userUid)
        .collection('items')
        .get();
    for (int i = 0; i < dataID.docs.length; i++) {
      listID.add(dataID.docs[i].id);
      var data = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(Database.userUid)
          .collection('items')
          .doc(listID[i])
          .collection('participation')
          .get();
      for (int j = 0; j < data.docs.length; j++) {
        if(data.docs[j].data()['email'] == Database.userUid) {
          listRole.add(data.docs[j].data()['role']);

        }

      }
    }
    //print("length : " + listID.length.toString() + " " + listID.toString());
    print("length : " + listRole.length.toString() + " " + listRole.toString());

  }*/

/*  void fetchData() async {
    for (int i = 0; i < listID.length; i++) {
      var data = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(Database.userUid)
          .collection('items')
          .doc(listID[i])
          .collection('participation')
          .get();
      for (int i = 0; i < data.docs.length; i++) {
        //Model model=Model(data.docs[i].data()['title'], data.docs[i].data()['price'],data.docs[i].data()['imageURL'],data.docs[i].data()['desc'], data.docs[i].data()['seller']);
        listRole.add(data.docs[i].data()['role']);
        //print(data.docs[i].data()['role']);
      }
    }

  }*/

 @override
  void initState()  {
    super.initState();
    //getData();
    if(DatabaseTest.listRole.isEmpty) {
      DatabaseTest.fetchDataID();
    }
    else {
      DatabaseTest.listRole.clear();
      DatabaseTest.fetchDataID();
    }

    //fetchData();
    // print("listID dashboard after: " + listID.toString());
    // print("listRole dashboard after: " + listRole.toString());
    //listRole = data['email'];

  }

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
      body: SafeArea(
        //bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: ItemList(
            //newList: listRole,
          ),
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
