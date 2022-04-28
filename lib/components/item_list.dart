import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/qrcode_screen.dart';

class ItemList extends StatelessWidget {
  /*late  List<String> newList;
  ItemList({
    required this.newList,
});*/

  //static Query<Map<String, dynamic>>   map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation').snapshots() as Query<Map<String, dynamic>>;

  /*late List<bool> _organisateur = [];
  late List<bool> _inviteur = [];
  late List<bool> _scanneur = [];*/
  bool _organisateur = false;
  bool _inviteur = false;
  bool _scanneur = false;

  @override
  Widget build(BuildContext context) {
    //getRole();
    //listRole = snapshot.data['email'] as List<String>;
    //print("List role Item : " + newList.toString());
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseTest.readItems(),
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
              String title = noteInfo['tittre'];
              String address = noteInfo['adresse'];
              String description = noteInfo['description'];
              String role = noteInfo['role'];
              DateTime dateStart =
                  (noteInfo['dateDebut'] as Timestamp).toDate();
              bool isDel = noteInfo['idDelete'];
              //Timestamp startDate = noteInfo['dateDebut'];
              //_organisateur = true;
              if (role.compareTo("Organisateur") == 0) {
                // print("index 0 " + index.toString());
                // print("role O " + DatabaseTest.listRole[index]);
                _organisateur = true;
              } else {
                _organisateur = false;
                if (role.compareTo("Invité") == 0) {
                  // print("index I " + index.toString());
                  // print("role I " + DatabaseTest.listRole[index]);
                  _inviteur = true;
                } else {
                  _inviteur = false;
                  // print("index " + index.toString());
                  // print("role " + DatabaseTest.listRole[index]);
                  if (role.compareTo("Scanneur") == 0)
                    _scanneur = true;
                  else
                    _scanneur = false;
                }
              }

              return Ink(
                //color: CustomColors.backgroundLight,
                decoration: BoxDecoration(
                  //color: !isDel ? CustomColors.primaryText.withOpacity(0.1) : Color(0xFF2E9598),

                  // gradient: !isDel
                  //     ? LinearGradient(colors: [
                  //         CustomColors.backgroundLight,
                  //         CustomColors.backgroundColorDark
                  //       ])
                  //     : const LinearGradient(colors: [
                  //         Color.fromARGB(255, 122, 146, 183),
                  //         Color.fromARGB(255, 243, 244, 246)
                  //       ]),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onTap: () {},
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        //color: CustomColors.textSecondary,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      //"Desc: " + description + "\nAdresse: " + address,
                      //"Date: " + dateStart.year.toString() + " - " + dateStart.month.toString() +" - "+ dateStart.day.toString(),
                      setUp(dateStart, isDel),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // style: TextStyle(
                      //color: CustomColors.accentDark, fontSize: 14),
                    ),
                    trailing: _organisateur
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditScreen(
                                        currTitle: title,
                                        currDesc: description,
                                        currAddr: address,
                                        //currStartDate: startDate.toDate(),
                                        documentId: docID,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  //color: CustomColors.accentDark,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _delete(context, docID);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    //color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.photo_camera,
                                    //color: CustomColors.accentDark,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    print("Event id to qrcode: " +
                                        docID +
                                        isDel.toString());
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => QRCodeScreen(
                                          documentId: docID,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.qr_code_scanner_outlined,
                                    //color: CustomColors.accentDark,
                                  )),
                            ],
                          )
                        : _inviteur
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {
                                        print("Event id to qrcode: " + docID);
                                        if (!isDel) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  QRCodeScreen(
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon:
                                          Icon(Icons.qr_code_scanner_outlined)),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
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
                                      icon:
                                          Icon(Icons.qr_code_scanner_outlined)),
                                ],
                              )),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
              // valueColor: AlwaysStoppedAnimation<Color>(
              //   CustomColors.accentLight,
              // ),
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
      return startDate;
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
