import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/qrcode_screen.dart';

/*class ItemListTest extends StatelessWidget {
  bool _isOrganisateur = false;
  bool _isInviteur = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseTest.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GFCard(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Organisateur : "),
                    GFCheckbox(
                      size: GFSize.SMALL,
                      activeBgColor: GFColors.DANGER,
                      type: GFCheckboxType.circle,
                      onChanged: (value) {
                        _isOrganisateur = value;
                        print("organisateur " + _isOrganisateur.toString());
                      },
                      value: _isOrganisateur,
                      inactiveIcon: null,
                    ),
                    Text("Invité : "),
                    GFCheckbox(
                      type: GFCheckboxType.circle,
                      activeBgColor: GFColors.SECONDARY,
                      onChanged: (value) {
                        _isInviteur = value;
                        print("inviteur " + _isInviteur.toString());
                      },
                      value: _isInviteur,
                    ),
                  ],
                ),
              ),
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
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
                  String name = noteInfo['tittre'];
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
                  int header = index == 0 ? dateStart.month : _dateStart.month;
                  if (index == 0 || index == 0
                      ? true
                      : (currHeader != header)) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            color: Colors.blueGrey,
                            padding:
                                EdgeInsets.only(left: 30, top: 10, bottom: 10),
                            child: Center(
                              child: Text(
                                currHeader.toString() +
                                    " / " +
                                    dateStart.year.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 26),
                              ),
                            )),
                        Ink(
                          decoration: BoxDecoration(
                            color: CustomColors.firebaseGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  currTitle: "title",
                                  currDesc: "description",
                                  currAddr: "address",
                                  //currStartDate: startDate.toDate(),
                                  documentId: docID,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            //trailing: Icon(Icons.edit),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                IconButton(
                                    onPressed: () {
                                      _delete(context, docID);
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {},
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
                                    icon: Icon(Icons.qr_code_scanner_outlined)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Ink(
                      decoration: BoxDecoration(
                        color: CustomColors.firebaseGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditScreen(
                              currTitle: "title",
                              currDesc: "description",
                              currAddr: "address",
                              //currStartDate: startDate.toDate(),
                              documentId: docID,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                            IconButton(
                                onPressed: () {
                                  _delete(context, docID);
                                },
                                icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {},
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
                                icon: Icon(Icons.qr_code_scanner_outlined)),
                          ],
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          );

          */
/*ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              //DocumentSnapshot _userData = index == 0 ? snapshot.data!.docs[index] : snapshot.data!.docs[index - 1];
              //Dart doesn’t know which type of object it is getting.
              var noteInfo =
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>;
              var _noteInfo = (index == 0
                      ? snapshot.data!.docs[index].data()!
                      : snapshot.data!.docs[index - 1].data()!)
                  as Map<String, dynamic>;

              String docID = snapshot.data!.docs[index].id;
              String name = noteInfo['tittre'];
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
              int header = index == 0 ? dateStart.month : _dateStart.month;
              if (index == 0 || index == 0 ? true : (currHeader != header)) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.blueGrey,
                        padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                        child: Center (
                          child:Text(
                        currHeader.toString() +
                        " / " +
                        dateStart.year.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
                        ) ,
                        )),
                    Ink(
                      decoration: BoxDecoration(
                        color: CustomColors.firebaseGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditScreen(
                              currTitle: "title",
                              currDesc: "description",
                              currAddr: "address",
                              //currStartDate: startDate.toDate(),
                              documentId: docID,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        //trailing: Icon(Icons.edit),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                            IconButton(
                                onPressed: () {
                                  _delete(context, docID);
                                },
                                icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () {},
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
                                icon: Icon(Icons.qr_code_scanner_outlined)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return  Ink(
                  decoration: BoxDecoration(
                    color: CustomColors.firebaseGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditScreen(
                          currTitle: "title",
                          currDesc: "description",
                          currAddr: "address",
                          //currStartDate: startDate.toDate(),
                          documentId: docID,
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    //trailing: Icon(Icons.edit),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                        IconButton(
                            onPressed: () {
                              _delete(context, docID);
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {},
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
                            icon: Icon(Icons.qr_code_scanner_outlined)),
                      ],
                    ),
                  ),
                );
              }

*/ /*
*/
/* return Ink(
                decoration: BoxDecoration(
                  color: CustomColors.firebaseGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () =>
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
                  ),
                  title: Text(
                    role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  //trailing: Icon(Icons.edit),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                      IconButton(
                          onPressed: () {
                            _delete(context, docID);
                          },
                          icon: Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {},
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
                          icon: Icon(Icons.qr_code_scanner_outlined)),
                    ],
                  ),
                ),
              );*/ /* */ /*
            },
          );*/ /*
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

  String setUp(DateTime selectedDateStart) {
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
    return startDate;
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
}*/

class ItemListTest extends StatefulWidget {
  @override
  _ItemListTestState createState() => _ItemListTestState();
}

class _ItemListTestState extends State<ItemListTest> {
  bool _isOrganisateur = false;
  bool _isInviteur = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: DatabaseTest.readItems(),
      stream: DatabaseTest.readRoles(_isOrganisateur, _isInviteur),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.deepPurpleAccent,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Organisateur : "),
                    Checkbox(
                        value: _isOrganisateur,
                        onChanged: (bool? value) {
                          setState(() {
                            _isOrganisateur = value!;
                            print("organisateur " + _isOrganisateur.toString());
                          });
                        }),
                    Text("Invité : "),
                    Checkbox(
                        value: _isInviteur,
                        onChanged: (bool? value) {
                          setState(() {
                            _isInviteur = value!;
                            print("invité " + _isInviteur.toString());
                          });
                        }),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(
                  height: 425,
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
                      String name = noteInfo['tittre'];
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
                            Ink(
                              decoration: BoxDecoration(
                                color:
                                    CustomColors.firebaseGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditScreen(
                                      currTitle: "title",
                                      currDesc: "description",
                                      currAddr: "address",
                                      //currStartDate: startDate.toDate(),
                                      documentId: docID,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                //trailing: Icon(Icons.edit),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                      IconButton(
                                          onPressed: () {
                                            _delete(context, docID);
                                          },
                                          icon: Icon(Icons.delete)),
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
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Ink(
                          decoration: BoxDecoration(
                            color: CustomColors.firebaseGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  currTitle: "title",
                                  currDesc: "description",
                                  currAddr: "address",
                                  //currStartDate: startDate.toDate(),
                                  documentId: docID,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                IconButton(
                                    onPressed: () {
                                      _delete(context, docID);
                                    },
                                    icon: Icon(Icons.delete)),
                                IconButton(
                                    onPressed: () {},
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
                                    icon: Icon(Icons.qr_code_scanner_outlined)),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ))
            ],
          );
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

  String setUp(DateTime selectedDateStart) {
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
    return startDate;
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
