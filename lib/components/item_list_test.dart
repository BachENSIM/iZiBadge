import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/filtre_form.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/edit_event_screen.dart';
import 'package:izibagde/screens/edit_group_screen.dart';
import 'package:izibagde/screens/edit_listUser_screen.dart';
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
          return const Text('Aucun événement trouvé...');
        } else if (snapshot.data?.size == 0) {
          return SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildMenu(context),
              const SizedBox(height: 20),
              const Center(
                child: Text('Aucun événement trouvé...',
                    style: TextStyle(
                      fontSize: 24,
                    )),
              )
            ],
          ));
        } else if (snapshot.hasData || snapshot.data != null) {
          return SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildMenu(context),
              const SizedBox(
                height: 15,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  ((context, index) {
                    // index = 1;
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
                    DateTime dateEnd =
                        (noteInfo['dateEnd'] as Timestamp).toDate();
                    //String role = noteInfo['role'];
                    int currHeader = dateStart.month;
                    int header =
                        index == 0 ? dateStart.month : _dateStart.month;
                    if (index == 0 || index == 0
                        ? true
                        : (currHeader != header)) {
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Container(
                              //color: Theme.of(context).primaryColorDark,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    // color: Theme.of(context).indicatorColor,
                                    color: CustomColors.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: Center(
                                child: Text(
                                  nameOfMonth(--currHeader) +
                                      " " +
                                      dateStart.year.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 5),
                          buildListe(context, isDel, address, desc, docID,
                              dateStart, name, index, dateEnd)
                        ],
                      );
                    } else {
                      return buildListe(context, isDel, address, desc, docID,
                          dateStart, name, index, dateEnd);
                    }
                  }),
                  childCount: snapshot.data!.docs.length,
                ),
              ),
            ],
          ));
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.accentColor,
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
    //startDate = "Date: " + startDate;
    if (!isDel) {
      return startDate;
    } else {
      return "(Annulé par l'organisateur)";
    }
  }

  void _delete(BuildContext context, String id, bool isDel) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Supprimer'),
            content: const Text("Supprimer cet événement ?"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              // The "Yes" button
              TextButton(
                onPressed: () async {
                  // Remove the box
                  isDel
                      ? await DatabaseTest.deleteItemCanceled(docId: id)
                      : await DatabaseTest.deleteItem(docId: id);
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Supprimer',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  String nameOfMonth(int position) {
    List<String> months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return months[position];
  }

  //widget pour le menu (filtrer les 3 roles)
  Widget buildMenu(BuildContext context) {
    return SizedBox(
      height: 40,
      // color: CustomColors.backgroundDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Text("User: ${DatabaseTest.userUid}"),
          SizedBox(
            width: 250,
            child: Row(
              children: [
                CircleAvatar(
                  child: const Icon(
                    Icons.person_outline_outlined,
                    size: 18,
                  ),
                  backgroundColor: CustomColors.primaryColor,
                  foregroundColor: CustomColors.textIcons,
                  radius: 18,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    DatabaseTest.userUid,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.primaryText,
                    ),
                    PopupMenuItem(
                      child: StatefulBuilder(
                        builder: (_context, _setState) {
                          return GFCheckboxListTile(
                              titleText: DatabaseTest.listNbRole.isEmpty
                                  ? "Scanneur 0"
                                  : "Scanneur " +
                                      DatabaseTest.listNbRole[2].toString(),
                              value: DatabaseTest.isScan,
                              onChanged: (bool? value) {
                                setState(() {
                                  _setState(() {
                                    DatabaseTest.fetchNBRole();
                                    DatabaseTest.isScan = value!;
                                    print("scanneur " +
                                        DatabaseTest.isScan.toString());
                                  });
                                });
                              });
                        },
                      ),
                    ),
                  ]),
        ],
      ),
    );
  }

  //widget pour le contenu de la liste
  Widget buildListe(
      BuildContext context,
      bool isDel,
      String address,
      String desc,
      String docID,
      DateTime dateStart,
      String name,
      int position,
      DateTime dateEnd) {
    return Ink(
      decoration: BoxDecoration(
        color:
            //CustomColors.firebaseGrey.withOpacity(0.1),
            !isDel
                ? CustomColors.primaryColor
                : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionTile(
        iconColor: CustomColors.textIcons,
        collapsedIconColor: CustomColors.textIcons,
        /*shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),*/
        children: <Widget>[
          ListTile(
            onTap: () {
              !isDel
                  ? _showSimpleModalDialog(
                      context, name, desc, address, dateStart, dateEnd)
                  : null;
            },
            dense: true,
            isThreeLine: true,
            title: Row(children: [
              Icon(
                Icons.location_on_outlined,
                color: CustomColors.textIcons,
                size: 18,
              ),
              const SizedBox(width: 5),
              Flexible(
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      //strutStyle: StrutStyle(fontSize: 38.0),
                      text: TextSpan(
                        text: address,
                        style: TextStyle(
                          color: CustomColors.textIcons,
                          fontSize: 15,
                        ),
                      )))
              /*Text(
                //"Adresse: " + address + "\nDescription: " + desc,
                // "Adresse: " + address,
                address,
                style: TextStyle(color: CustomColors.textIcons),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )*/
            ]),
            subtitle: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: CustomColors.textIcons,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  setUp(dateStart, isDel),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: CustomColors.textIcons, fontSize: 14),
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {
                    !isDel
                        ? _showSimpleModalDialog(
                            context, name, desc, address, dateStart, dateEnd)
                        : null;
                  },
                  // dense: true,
                  // isThreeLine: true,
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: CustomColors.textIcons,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: CustomColors.textIcons,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.photo_camera,
                        color: CustomColors.textIcons,
                      )),
                if (!isDel && !_organisateur)
                  IconButton(
                      onPressed: () {
                        print("Event id to qrcode: " + docID);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QRCodeScreen(
                              documentId: docID,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (_organisateur)
                        PopupMenuButton(
                          icon: Icon(
                            Icons.edit,
                            color: CustomColors.textIcons,
                          ),
                          offset: const Offset(160, 40),
                          // color: CustomColors.textIcons,
                          elevation: 20,
                          enabled: true,
                          onCanceled: () {
                            //do something
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  StatefulBuilder(
                                    builder: (_context, _setState) {
                                      return IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                currTitle: name,
                                                currDesc: desc,
                                                currAddr: address,
                                                //currStartDate: startDate.toDate(),
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.event_note_sharp,
                                          color: CustomColors.primaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                  StatefulBuilder(
                                    builder: (_context, _setState) {
                                      return IconButton(
                                        onPressed: () {
                                          DatabaseTest.fetchGroupAdded(docID);
                                          print("editedi " +
                                              DatabaseTest.lstGrAdded
                                                  .toString());
                                          //un astuce => mettre .5s de pause pour charger la BDD
                                          sleep(const Duration(
                                              milliseconds: 250));
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditGroupScreen(
                                                nameEvent: name,
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.group_add_rounded,
                                          color: CustomColors.primaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                  StatefulBuilder(
                                    builder: (_context, _setState) {
                                      return IconButton(
                                        onPressed: () async {
                                          await DatabaseTest.fetchListUsers(
                                              docID);
                                          await DatabaseTest.fetchGroupAdded(
                                              docID);
                                          sleep(const Duration(
                                              milliseconds: 500));
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditListUserScreen(
                                                nameEvent: name,
                                                documentId: docID,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.attach_email,
                                          color: CustomColors.primaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      if (_organisateur || isDel)
                        IconButton(
                            onPressed: () {
                              _delete(context, docID, isDel);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: CustomColors.textIcons,
                            )),
                      if ((_scanneur || _organisateur) && !isDel)
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
                            icon: Icon(
                              Icons.photo_camera,
                              color: CustomColors.textIcons,
                            )),
                      if (!isDel && !_organisateur)
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
                            icon: Icon(
                              Icons.qr_code_scanner_outlined,
                              color: CustomColors.textIcons,
                            )),
                      if (!isDel && !_isInviteur)
                        IconButton(
                            onPressed: () async {
                              debugPrint('Size = ' +
                                  MediaQuery.of(context).size.toString());
                              debugPrint('Height = ' +
                                  (MediaQuery.of(context).size.height / 1.5)
                                      .toString());
                              debugPrint('Width = ' +
                                  MediaQuery.of(context).size.width.toString());
                              debugPrint("size list = " +
                                  (MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top -
                                          kToolbarHeight)
                                      .toString());
                              debugPrint(
                                  "${MediaQuery.of(context).padding.top}");
                              debugPrint("${kToolbarHeight}");

                              bool checked =
                                  await DatabaseTest.fetchItemClicked(
                                      docId: docID,
                                      index: position,
                                      title: name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: checked
                                      ? const Text(
                                          "Données sauvegardées en local !")
                                      : const Text(
                                          "Problème lors de la sauvegarde..."),
                                  padding: const EdgeInsets.all(15.0),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.save_alt_sharp,
                              color: CustomColors.textIcons,
                            )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            //color: Color(0xFFB38305),
            color: CustomColors.textIcons,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  _showSimpleModalDialog(context, String title, String description,
      String address, DateTime dateStart, DateTime dateEnd) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 510, maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primaryColor,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.primaryColor,
                      thickness: 1.5,
                    ),
                    Row(children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: CustomColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ]),
                    Divider(
                      color: CustomColors.primaryColor,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.short_text_rounded,
                          color: CustomColors.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // RichText(
                    //   textAlign: TextAlign.justify,
                    //   text: TextSpan(
                    //       text: description,
                    //       style: const TextStyle(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 14,
                    //         color: Colors.black,
                    //         wordSpacing: 1,
                    //       )),
                    // ),
                    Divider(
                      color: CustomColors.primaryColor,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: CustomColors.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Début : ${dateStart.day}/${dateStart.month}/${dateStart.year} à ${dateStart.hour}:${dateStart.minute}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: CustomColors.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Fin : ${dateEnd.day}/${dateEnd.month}/${dateEnd.year} à ${dateEnd.hour}:${dateEnd.minute}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
