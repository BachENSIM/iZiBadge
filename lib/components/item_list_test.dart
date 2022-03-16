import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/qrcode_screen.dart';


class ItemListTest extends StatelessWidget {
  late  List<String> newList;
  ItemListTest({
    required this.newList,
});

  //static Query<Map<String, dynamic>>   map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation').snapshots() as Query<Map<String, dynamic>>;


  @override
  Widget build(BuildContext context) {
    //getRole();
    //listRole = snapshot.data['email'] as List<String>;
    print("List role Item : " + newList.toString());
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseTest.readRoles(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index].data()! as Map<String,
                  dynamic>; //Dart doesn’t know which type of object it is getting.
              String docID = snapshot.data!.docs[index].id;
              String role = noteInfo['role'];


              return Ink(
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
              );
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
