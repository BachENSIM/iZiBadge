import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/filtre_form.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/qrcode_screen.dart';
import 'package:izibagde/screens/scanner_screen.dart';

class ItemListTest extends StatefulWidget {
  @override
  _ItemListTestState createState() => _ItemListTestState();
}

class _ItemListTestState extends State<ItemListTest> {
  bool _isOrganisateur = false;
  bool _isInviteur = false;

  //distinguer entre des roles
  bool _organisateur = false;
  bool _inviteur = false;
  bool _scanneur = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: DatabaseTest.readItems(),
      stream: DatabaseTest.readRoles(
          DatabaseTest.isOrgan, DatabaseTest.isInvite, DatabaseTest.isScan),
      //stream: DatabaseTest.readRoles(_isOrganisateur,_isInviteur,DatabaseTest.isScan),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.indigoAccent  ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //pour le filtre par le role
                    PopupMenuButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 32.0,
                        ),
                        offset: Offset(-40, 0),
                        color: Colors.lightBlue,
                        elevation: 20,
                        enabled: true,
                        onCanceled: () {
                          //do something
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: StatefulBuilder(
                                  builder: (_context, _setState) {
                                    // return Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: <Widget>[
                                    //     const SizedBox(
                                    //       child: Text("Organisateur "),
                                    //       width: 110,
                                    //     ),
                                    //     Text( /*DatabaseTest.listNbRole.isEmpty ? "0" :*/ DatabaseTest.listNbRole[0]
                                    //         .toString()),
                                    //     Checkbox(
                                    //         value: DatabaseTest.isOrgan,
                                    //         onChanged: (bool? value) {
                                    //           setState(() {
                                    //             _setState(() {
                                    //               DatabaseTest.fetchNBRole();
                                    //               DatabaseTest.isOrgan = value!;
                                    //               print("organisateur " +
                                    //                   DatabaseTest.isOrgan
                                    //                       .toString());
                                    //             });
                                    //           });
                                    //         }),
                                    //   ],
                                    // );
                                    return GFCheckboxListTile(
                                        titleText: DatabaseTest.listNbRole.isEmpty ? "Organisateur 0" : "Organisateur " + DatabaseTest.listNbRole[0]
                                            .toString(),
                                        type: GFCheckboxType.basic,
                                        inactiveIcon: null,
                                        value: DatabaseTest.isOrgan,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _setState(() {
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isOrgan =
                                              value!;

                                            });
                                          });
                                        }
                                    );

                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: StatefulBuilder(
                                  builder: (_context, _setState) {
                                    /*return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          child: Text("Invité"),
                                          width: 110,
                                        ),
                                        Text(DatabaseTest.listNbRole.isEmpty ? "0" : DatabaseTest.listNbRole[1]
                                            .toString()),
                                        Checkbox(
                                            value: DatabaseTest.isInvite,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _setState(() {
                                                  DatabaseTest.fetchNBRole();
                                                  DatabaseTest.isInvite =
                                                      value!;
                                                  print("invité " +
                                                      DatabaseTest.isInvite
                                                          .toString());
                                                });
                                              });
                                            }),
                                      ],
                                    );*/
                                    return GFCheckboxListTile(
                                      titleText: DatabaseTest.listNbRole.isEmpty ? "Invité 0" : "Invité " + DatabaseTest.listNbRole[1]
                                          .toString(),
                                        type: GFCheckboxType.basic,
                                        inactiveIcon: null,
                                        value: DatabaseTest.isInvite,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _setState(() {
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isInvite =
                                              value!;
                                              print("invité " +
                                                  DatabaseTest.isInvite
                                                      .toString());
                                            });
                                          });
                                        }
                                    );
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: StatefulBuilder(
                                  builder: (_context, _setState) {
                                    /*return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          child: Text("Scanneur"),
                                          width: 110,
                                        ),
                                        Text(DatabaseTest.listNbRole.isEmpty ? "0" : DatabaseTest.listNbRole[2]
                                            .toString()),
                                        Checkbox(
                                            value: DatabaseTest.isScan,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _setState(() {
                                                  DatabaseTest.fetchNBRole();
                                                  DatabaseTest.isScan =
                                                      value!;
                                                  print("scanneur " +
                                                      DatabaseTest.isScan
                                                          .toString());
                                                });
                                              });
                                            }),
                                      ],
                                    );*/
                                    return GFCheckboxListTile(
                                        titleText:  DatabaseTest.listNbRole.isEmpty ? "Scanneur 0" : "Scanneur " +DatabaseTest.listNbRole[2]
                                            .toString(),
                                        value: DatabaseTest.isScan,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _setState(() {
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isScan =
                                              value!;
                                              print("scanneur " +
                                                  DatabaseTest.isScan
                                                      .toString());
                                            });
                                          });
                                        }
                                    );
                                  },
                                ),
                              ),
                            ]),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  height: 475,
                  child: ListView.separated(
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {


                      //DocumentSnapshot _userData = index == 0 ? snapshot.data!.docs[index] : snapshot.data!.docs[index - 1];
                      //Dart doesn’t know which type of object it is getting.

                      var noteInfo = snapshot.data!.docs[index].data()!
                          as Map<String, dynamic>;
                      var _noteInfo = (index == 0
                              ? snapshot.data!.docs[index].data()!
                              : snapshot.data!.docs[index - 1].data()!)
                          as Map<String, dynamic>;

                      String docID = snapshot.data!.docs[index].id;
                      String name = noteInfo['titre'];
                      String role = noteInfo['role'];
                      String address = noteInfo['adresse'];
                      String desc = noteInfo['description'];
                      bool isDel = noteInfo['isEfface'];
                      if (role.compareTo("Organisateur") == 0) {
                        _organisateur = true;
                      } else {
                        _organisateur = false;
                        if (role.compareTo("Invité") == 0) {
                          _inviteur = true;
                        } else {
                          _inviteur = false;
                          if (role.compareTo("Scanneur") == 0) {
                            _scanneur = true;
                          } else {
                            _scanneur = false;
                          }
                        }
                      }
                      String _docID = index == 0
                          ? snapshot.data!.docs[index].id
                          : snapshot.data!.docs[index - 1].id;
                      DateTime dateStart =
                          (noteInfo['dateDebut'] as Timestamp).toDate();
                      DateTime _dateStart = index == 0
                          ? (noteInfo['dateDebut'] as Timestamp).toDate()
                          : (_noteInfo['dateDebut'] as Timestamp).toDate();
                      //String role = noteInfo['role'];
                      int currHeader = dateStart.month;
                      int header =
                          index == 0 ? dateStart.month : _dateStart.month;
                      if (index == 0 || index == 0
                          ? true
                          : (currHeader != header)) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                color: Colors.blueGrey,
                                padding: EdgeInsets.only(
                                    left: 30, top: 10, bottom: 10),
                                child: Center(
                                  child: Text(
                                    currHeader.toString() +
                                        " / " +
                                        dateStart.year.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26),
                                  ),
                                )),
                            SizedBox(height: 10),
                            Ink(
                              decoration: BoxDecoration(
                                color:
                                    //CustomColors.firebaseGrey.withOpacity(0.1),
                                    !isDel
                                        ? CustomColors.firebaseGrey
                                            .withOpacity(0.1)
                                        : Color(0xFF7EEDF3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              /*child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onTap: () {},
                                title: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //color: Color(0xFFB38305),
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  //"Desc: " + description + "\nAdresse: " + address,
                                  //"Date: " + dateStart.year.toString() + " - " + dateStart.month.toString() +" - "+ dateStart.day.toString(),
                                  setUp(dateStart, isDel),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xFF665017), fontSize: 14),
                                ),

                                //trailing: Icon(Icons.edit),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (_organisateur)
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                currTitle: "title",
                                                currDesc: "description",
                                                currAddr: "address",
                                                //currStartDate: startDate.toDate(),
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    if (_organisateur)
                                      IconButton(
                                          onPressed: () {
                                            _delete(context, docID);
                                          },
                                          icon: Icon(Icons.delete)),
                                    if (_organisateur || _scanneur)
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.photo_camera)),
                                    IconButton(
                                        onPressed: () {
                                          print("Event id to qrcode: " + docID);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QRCodeScreen(
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.qr_code_scanner_outlined)),
                                  ],
                                ),
                              ),*/
                              child: ExpansionTile(
                                /*shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),*/
                                children: <Widget>[
                                  ListTile(
                                    isThreeLine: true,
                                    title: Text("Address: " + address + "\nDescription: " + desc),
                                    subtitle: Text(
                                      //"Desc: " + description + "\nAdresse: " + address,
                                      //"Date: " + dateStart.year.toString() + " - " + dateStart.month.toString() +" - "+ dateStart.day.toString(),
                                      setUp(dateStart, isDel),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Color(0xFFEEBA46), fontSize: 14),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        if (_organisateur)
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => EditScreen(
                                                    currTitle: "title",
                                                    currDesc: "description",
                                                    currAddr: "address",
                                                    //currStartDate: startDate.toDate(),
                                                    documentId: docID,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                        if (_organisateur)
                                          IconButton(
                                              onPressed: () {
                                                _delete(context, docID);
                                              },
                                              icon: Icon(Icons.delete)),
                                        if (_organisateur || _scanneur)
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => ScannerScreen(
                                                      documentId: docID,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.photo_camera)),
                                        IconButton(
                                            onPressed: () {
                                              print("Event id to qrcode: " + docID);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => QRCodeScreen(
                                                    documentId: docID,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.qr_code_scanner_outlined)),
                                      ],
                                    ),
                                  )
                                ],

                                title: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    //color: Color(0xFFB38305),
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Ink(
                          decoration: BoxDecoration(
                            color:
                            //CustomColors.firebaseGrey.withOpacity(0.1),
                            !isDel
                                ? CustomColors.firebaseGrey
                                .withOpacity(0.1)
                                : Color(0xFF7EEDF3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ExpansionTile(
                            /*shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),*/
                            children: <Widget>[
                              ListTile(
                                isThreeLine: true,
                                title: Text("Address: " + address + "\nDescription: " + desc),
                                subtitle: Text(
                                  //"Desc: " + description + "\nAdresse: " + address,
                                  //"Date: " + dateStart.year.toString() + " - " + dateStart.month.toString() +" - "+ dateStart.day.toString(),
                                  setUp(dateStart, isDel),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xFFEEBA46), fontSize: 14),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    if (_organisateur)
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                currTitle: "title",
                                                currDesc: "description",
                                                currAddr: "address",
                                                //currStartDate: startDate.toDate(),
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    if (_organisateur)
                                      IconButton(
                                          onPressed: () {
                                            _delete(context, docID);
                                          },
                                          icon: Icon(Icons.delete)),
                                    if (_organisateur || _scanneur)
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => ScannerScreen(
                                                  documentId: docID,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.photo_camera)),
                                    IconButton(
                                        onPressed: () {
                                          print("Event id to qrcode: " + docID);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => QRCodeScreen(
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.qr_code_scanner_outlined)),
                                  ],
                                ),
                              )
                            ],

                            title: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                //color: Color(0xFFB38305),
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),

                        );
                      }
                    },
                  ))
            ],
          ));
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }

  String setUp(DateTime selectedDateStart, bool isDel) {
    String? startDate;
    if (selectedDateStart.month < 10) {
      if (selectedDateStart.day < 10) {
        startDate = selectedDateStart.year.toString() +
            "-0" +
            selectedDateStart.month.toString() +
            "-0" +
            selectedDateStart.day.toString();
      } else {
        startDate = selectedDateStart.year.toString() +
            "-0" +
            selectedDateStart.month.toString() +
            "-" +
            selectedDateStart.day.toString();
      }
    } else {
      startDate = selectedDateStart.year.toString() +
          "-" +
          selectedDateStart.month.toString() +
          "-" +
          selectedDateStart.day.toString();
    }

    if (!isDel)
      return "Time: " + startDate;
    else
      return "(Annulé par l'organisateur)";
  }

  void _delete(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove this item?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    // Remove the box
                    await DatabaseTest.deleteItem(docId: id);

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
