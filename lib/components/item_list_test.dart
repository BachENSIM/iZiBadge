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
        if (snapshot.hasError || snapshot.data?.size == 0) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: CustomColors.textIcons,
                title: buildMenu(context),
              ),
              SizedBox(
                  height: (MediaQuery.of(context).size.height) / 1.5 +
                      kToolbarHeight,
                  child: ListView.separated(
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16.0),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                //color: Theme.of(context).primaryColorDark,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).indicatorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0)),
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
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
                            const SizedBox(height: 10),
                            buildListe(context, isDel, address, desc, docID,
                                dateStart, name, index, dateEnd)
                          ],
                        );
                      } else {
                        return buildListe(context, isDel, address, desc, docID,
                            dateStart, name, index, dateEnd);
                      }
                    },
                  ))
            ],
          );

          // return Container(
          //   padding: const EdgeInsets.only(
          //     left: 16,
          //     right: 16,
          //   ),
          //   child: Column(
          //     children: <Widget>[
          //       buildMenu(context),
          //       const SizedBox(height: 20),
          //       const Center(
          //         child: Text('Aucun événement trouvé...',
          //             style: TextStyle(
          //               fontSize: 22,
          //             )),
          //       )
          //     ],
          //   ),
          // );
        } else if (snapshot.hasData || snapshot.data != null) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: CustomColors.textIcons,
                title: buildMenu(context),
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
          );
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
    int groupValue = 3;
    return Column(
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       color: CustomColors.primaryColor,
        //       width: 2,
        //     ),
        //   ),
        // ),
        children: [
          Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                  ),
                ),
                Text(DatabaseTest.userUid)
              ],
            ),
          ),
          //pour le filtre par le role
          PopupMenuButton(
              icon: const Icon(
                Icons.filter_list_rounded,
                // color: CustomColors.secondaryText,
                size: 36.0,
              ),
              offset: const Offset(-40, 0),
              // color: CustomColors.lightPrimaryColor,
              elevation: 20,
              enabled: true,
              onCanceled: () {},
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
                              titleText: DatabaseTest.listNbRole.isEmpty
                                  ? "Organisateur 0"
                                  : "Organisateur " +
                                      DatabaseTest.listNbRole[0].toString(),
                              type: GFCheckboxType.basic,
                              inactiveIcon: null,
                              value: DatabaseTest.isOrgan,
                              onChanged: (bool? value) {
                                setState(() {
                                  _setState(() {
                                    DatabaseTest.fetchNBRole();
                                    DatabaseTest.isOrgan = value!;
                                  });
                                });
                              });

                        },
                      ),
                    ),
                    offset: const Offset(0, 45),
                    // color: CustomColors.lightPrimaryColor,
                    // elevation: 20,
                    enabled: true,
                    onCanceled: () {},
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: StatefulBuilder(
                              builder: (_context, _setState) {
                                return Column(
                                  children: [
                                    GFRadioListTile(
                                        titleText: "Organisateur",
                                        subTitleText:
                                            DatabaseTest.listNbRole.isEmpty
                                                ? "0"
                                                : DatabaseTest.listNbRole[0]
                                                    .toString(),
                                        margin: EdgeInsets.zero,
                                        // padding: EdgeInsets.zero,
                                        radioColor: CustomColors.primaryColor,
                                        // type: GFCheckboxType.basic,
                                        inactiveIcon: null,
                                        // value: DatabaseTest.isOrgan,
                                        value: 0,
                                        groupValue: groupValue,
                                        onChanged: (value) {
                                          // groupValue = value;
                                          setState(() {
                                            _setState(() {
                                              groupValue = value;
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isOrgan = true;
                                              DatabaseTest.isInvite = false;
                                              DatabaseTest.isScan = false;
                                            });
                                          });
                                        }),
                                    const Divider(
                                      thickness: 1,
                                      height: 5,
                                    ),
                                    GFRadioListTile(
                                        titleText: "Invité",
                                        subTitleText:
                                            DatabaseTest.listNbRole.isEmpty
                                                ? "0"
                                                : DatabaseTest.listNbRole[1]
                                                    .toString(),
                                        margin: EdgeInsets.zero,
                                        // padding: EdgeInsets.zero,
                                        radioColor: CustomColors.primaryColor,
                                        // type: GFCheckboxType.basic,
                                        inactiveIcon: null,
                                        // value: DatabaseTest.isInvite,
                                        value: 1,
                                        groupValue: groupValue,
                                        onChanged: (value) {
                                          // groupValue = value;
                                          setState(() {
                                            _setState(() {
                                              groupValue = value;
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isOrgan = false;
                                              DatabaseTest.isInvite = true;
                                              DatabaseTest.isScan = false;
                                              print("invité " +
                                                  DatabaseTest.isInvite
                                                      .toString());
                                            });
                                          });
                                        }),
                                    const Divider(
                                      thickness: 1,
                                      height: 5,
                                    ),
                                    GFRadioListTile(
                                        titleText: "Scanneur",
                                        subTitleText:
                                            DatabaseTest.listNbRole.isEmpty
                                                ? "0"
                                                : DatabaseTest.listNbRole[2]
                                                    .toString(),
                                        margin: EdgeInsets.zero,
                                        // padding: EdgeInsets.zero,
                                        radioColor: CustomColors.primaryColor,
                                        // value: DatabaseTest.isScan,
                                        value: 2,
                                        inactiveIcon: null,
                                        groupValue: groupValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _setState(() {
                                              groupValue = value;
                                              DatabaseTest.fetchNBRole();
                                              DatabaseTest.isOrgan = false;
                                              DatabaseTest.isInvite = false;
                                              DatabaseTest.isScan = true;
                                              print("scanneur " +
                                                  DatabaseTest.isScan
                                                      .toString());
                                            });
                                          });
                                        }),
                                    const Divider(
                                      thickness: 1,
                                      height: 5,
                                    ),
                                    GFRadioListTile(
                                        titleText: "Sans filtre",
                                        margin: EdgeInsets.zero,
                                        // padding: EdgeInsets.zero,
                                        radioColor: CustomColors.primaryColor,
                                        // value: DatabaseTest.isScan,
                                        value: 3,
                                        inactiveIcon: null,
                                        groupValue: groupValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _setState(() {
                                              groupValue = value;
                                              DatabaseTest.isOrgan = false;
                                              DatabaseTest.isInvite = false;
                                              DatabaseTest.isScan = false;
                                            });
                                          });
                                        }),
                                  ],
                                );
                              },
                            ),
                          )
                        ])
              ])
        ]);

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

    // const Divider(thickness: 3),
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
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Ink(
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
              title: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.textIcons,
                  fontSize: 20,
                ),
              ),
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
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: CustomColors.textIcons,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              setUp(dateStart, isDel),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: CustomColors.textIcons,
                                fontSize: 16,
                              ),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_organisateur)
                  PopupMenuButton(
                      icon: Icon(
                        Icons.edit,
                        color: CustomColors.textIcons,
                      ),
                      offset: const Offset(200, 40),
                      // color: CustomColors.textIcons,
                      elevation: 20,
                      enabled: true,
                      onCanceled: () {
                        //do something
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                height: 10,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      StatefulBuilder(
                                        builder: (_context, _setState) {
                                          return IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditScreen(
                                                      currTitle: name,
                                                      currDesc: desc,
                                                      currAddr: address,
                                                      //currStartDate: startDate.toDate(),
                                                      documentId: docID,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.event_note_sharp,
                                              ));
                                        },
                                      ),
                                      StatefulBuilder(
                                        builder: (_context, _setState) {
                                          return IconButton(
                                              onPressed: () {
                                                debugPrint(name);
                                                DatabaseTest.fetchGroupAdded(
                                                    docID);
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
                                                      documentId: docID,
                                                      nameEvent: name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.group_add_rounded,
                                              ));
                                        },
                                      ),
                                      StatefulBuilder(
                                        builder: (_context, _setState) {
                                          return IconButton(
                                              onPressed: () async {
                                                debugPrint(name);
                                                await DatabaseTest
                                                    .fetchGroupAdded(docID);
                                                await DatabaseTest
                                                    .fetchListUsers(docID);
                                                sleep(const Duration(
                                                    milliseconds: 500));
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditListUserScreen(
                                                      documentId: docID,
                                                      nameEvent: name,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.attach_email,
                                              ));
                                        },
                                      ),
                                    ]))
                          ]),
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
                        debugPrint(
                            'Size = ' + MediaQuery.of(context).size.toString());
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
                        debugPrint("${MediaQuery.of(context).padding.top}");
                        debugPrint("${kToolbarHeight}");

                        bool checked = await DatabaseTest.fetchItemClicked(
                            docId: docID, index: position, title: name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: checked
                                ? Text("Sauvegarde des données en local...")
                                : Text("Problème lors de la sauvegarde..."),
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
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            //color: Color(0xFFB38305),
            color: CustomColors.textIcons,
            fontSize: 20,
          ),
          const SizedBox(height: 5),
        ],
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
