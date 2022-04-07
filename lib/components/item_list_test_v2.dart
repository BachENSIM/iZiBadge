import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/qrcode_screen.dart';
import 'package:izibagde/screens/scanner_screen.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ItemListTestV2 extends StatelessWidget {

  //static Query<Map<String, dynamic>>   map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation').snapshots() as Query<Map<String, dynamic>>;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseTest.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 15.0),
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
                return StickyHeader(
                  overlapHeaders: true,
                  header: Container(
                    color: Colors.orangeAccent,
                    child:Center (
                            child:Text(
                              currHeader.toString() +
                                  " / " +
                                  dateStart.year.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
                            ) ,
                          )
                  ),
                  content:
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
                                onPressed: () {
                                 /* Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ScannerPage(
                                        //documentId: docID,
                                      ),
                                    ),
                                  );*/
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
                                icon: Icon(Icons.qr_code_scanner_outlined)),
                          ],
                        ),
                      ),
                    ),
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
                            onPressed: () {
                             /* Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScannerPage(
                                  ),
                                ),
                              );*/
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
                            icon: Icon(Icons.qr_code_scanner_outlined)),
                      ],
                    ),
                  ),
                );
              }


               /* return StickyHeader(
                  header: Container(
                      color: Colors.orangeAccent,
                      child:Center (
                        child:Text(
                          currHeader.toString() +
                              " / " +
                              dateStart.year.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
                        ) ,
                      )
                  ),
                  content:
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
                );*/



/*              return Ink(
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
              );*/
            },
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
