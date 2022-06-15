import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class ListUserScreen extends StatefulWidget {
  //const ListUserScreen({Key? key}) : super(key: key);

  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  // The inital group value
  //static final GlobalKey<FormState> _lstUserFormKey = GlobalKey();
  //un combo de List<> pour stocker d'une infor: une personne avec un rôle et appartient à une groupe
  final List<String> _groupListUser = [];
  final List<String> _groupDropdownGroup = [];
  final List<String> _groupDropdownRole = [];
  final TextEditingController _guestCtl = TextEditingController();
  TextEditingController? _editGuestCtl;

  //dropDown pour le group
  String? _dropdownGroup = DatabaseTest.listNameGroup[0];

  //dropDown pour le role
  static final List<String> _roleDropDown = ["Invité", "Scanneur"];
  String? _dropdownRole = _roleDropDown[0];
  late int taille;

  //pour éviter appuyer plusieurs fois
  bool _isProcessing = false;

  //final TextEditingController _guestEditCtl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taille = _groupListUser.length + 1;
    if (DatabaseTest.lstPersonScanned.isNotEmpty)
      DatabaseTest.lstPersonScanned.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: CustomColors.backgroundColorDark,
        centerTitle: true,
        title: const Text(
          "Ajout d'invités",
        ),
        leadingWidth: 100,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_left_sharp),
            label: const Text("Back"),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                // primary: Colors.transparent,
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          //key: _lstUserFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //ajouter d'une liste d'invitation (1 QRCode pour toute la durée)
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Titre : ${DatabaseTest.nameSave!}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              controller: _guestCtl,
                              validator: (value) => value!.isEmpty
                                  ? "L'email ne peut pas être vide"
                                  : null,
                              decoration: const InputDecoration(
                                hintText: 'Ex: email@gmail.com',
                                contentPadding: EdgeInsets.all(8),
                                isDense: false,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Pour le groupe
                                Container(
                                  height: 50,
                                  //width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(5),
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      padding: const EdgeInsets.all(15),
                                      borderRadius: BorderRadius.circular(5),
                                      value: _dropdownGroup,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dropdownGroup = newValue as String?;
                                        });
                                      },
                                      items: DatabaseTest.listNameGroup
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                //Pour le role
                                Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      padding: const EdgeInsets.all(15),
                                      borderRadius: BorderRadius.circular(5),
                                      value: _dropdownRole,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dropdownRole = newValue as String?;
                                          print(_dropdownRole);
                                        });
                                      },
                                      items: _roleDropDown
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(value),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          //vérifier si le champ est vide => créer automatique un email
                                          String mess = _guestCtl.text;
                                          if (_guestCtl.text.isEmpty) {
                                            mess =
                                                "example${taille++}@gmail.com";
                                          }
                                          bool userExist =
                                              _groupListUser.contains(mess);
                                          bool uIdExist = DatabaseTest.userUid
                                              .contains(mess);
                                          String snackBar = userExist
                                              ? "$mess est déjà dans la liste..."
                                              : (uIdExist
                                                  ? "$mess : Vous êtes déjà invité !"
                                                  : "Ajout réussi...");
                                          if (userExist || uIdExist) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(snackBar),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                              ),
                                            );
                                          } else {
                                            _groupListUser.add(mess);
                                            _groupDropdownGroup
                                                .add(_dropdownGroup!);
                                            _groupDropdownRole
                                                .add(_dropdownRole!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(snackBar),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                              ),
                                            );
                                          }
                                          _guestCtl.clear();
                                        });
                                      },
                                      child: Wrap(
                                        children: const <Widget>[
                                          Text("Inviter")
                                        ],
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //afficher la liste d'invitation afin de consulter avant de sauvegarder dans la BDD
                            ListView(shrinkWrap: true, children: <Widget>[
                              SizedBox(height: 15),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.7,
                                child: ListView.builder(
                                  //shrinkWrap: true,
                                  itemCount: _groupListUser.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        child: Column(children: <Widget>[
                                      GFListTile(
                                          onTap: () {
                                            setState(() {
                                              _editGuestCtl =
                                                  TextEditingController(
                                                      text: _groupListUser[
                                                          index]);
                                              _modify(context, index);
                                            });
                                          },
                                          titleText: _groupListUser[index],
                                          subTitleText: "Groupe: " +
                                              _groupDropdownGroup[index] +
                                              " - Role: " +
                                              _groupDropdownRole[index],
                                          icon: IconButton(
                                            icon: Icon(Icons.cancel_outlined),
                                            onPressed: () {
                                              setState(() {
                                                _groupListUser.removeAt(index);
                                                _groupDropdownGroup
                                                    .removeAt(index);
                                                _groupDropdownRole
                                                    .removeAt(index);
                                                DatabaseTest.listInvite =
                                                    _groupListUser;
                                              });
                                            },
                                            color: index.isEven
                                                ? CustomColors.accentColor
                                                : CustomColors.darkPrimaryColor,
                                          )),
                                    ]));
                                  },
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      ],
                    ))),
                //pour voir le truc tournant
                _isProcessing
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                              ),
                        ),
                      )
                    : SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isProcessing = true;
                            });
                            int? yearStart = DatabaseTest.startSave!.year;
                            int? yearEnd = DatabaseTest.endSave!.year;
                            int? monthStart = DatabaseTest.startSave!.month;
                            int? monthEnd = DatabaseTest.endSave!.month;
                            int? dayStart = DatabaseTest.startSave!.day;
                            int? dayEnd = DatabaseTest.endSave!.day;
                            int? hourStart = DatabaseTest.timeStartSave!.hour;
                            int? hourEnd = DatabaseTest.timeEndSave!.hour;
                            int? minuteStart =
                                DatabaseTest.timeStartSave!.minute;
                            int? minuteEnd = DatabaseTest.timeEndSave!.minute;
                            //Save les DB sur Firebase
                            await DatabaseTest.addItem(
                              title: DatabaseTest.nameSave.toString(),
                              description: DatabaseTest.descSave.toString(),
                              address: DatabaseTest.addrSave.toString(),
                              start: DateTime(yearStart, monthStart, dayStart,
                                  hourStart, minuteStart),
                              end: DateTime(yearEnd, monthEnd, dayEnd, hourEnd,
                                  minuteEnd),
                              role: "Organisateur",
                            );
                            //synchroniser cet événement sur leurs compte
                            await DatabaseTest.addInviteList(
                                listEmail: _groupListUser,
                                listGroup: _groupDropdownGroup,
                                listRole: _groupDropdownRole);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ),
                            );

                            setState(() {
                              _isProcessing = false;
                            });

                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                            child: Text(
                              "Valider",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
  //le modal pour modifier
  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext _context, StateSetter _setState) {
            return AlertDialog(
              title: const Text("Modifier les informations de l'invité"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: _editGuestCtl,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      isDense: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Pour le groupe
                      Container(
                        height: 50,
                        //width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 15),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            border: const BorderSide(
                                ),
                            value: _dropdownGroup,
                            onChanged: (newValue) {
                              _setState(() {
                                _dropdownGroup = newValue as String?;
                              });
                            },
                            items: DatabaseTest.listNameGroup
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      //Pour le role
                      Container(
                        height: 50,
                        //width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 15),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            border: const BorderSide(
                                ),
                            value: _dropdownRole,
                            onChanged: (newValue) {
                              _setState(() {
                                _dropdownRole = newValue as String?;
                                debugPrint(_dropdownRole);
                              });
                            },
                            items: _roleDropDown
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler"),
                ),
                TextButton(
                    onPressed: () {
                      // Remove the box
                      setState(() {
                        String mess = _editGuestCtl!.text;
                        bool diff = mess.contains(_groupListUser[index]);
                        bool userExist = _groupListUser.contains(mess);
                        bool uIdExist = DatabaseTest.userUid.contains(mess);
                        String snackBar = diff
                            ? "Modification réussie..."
                            : userExist
                                ? "$mess est déjà dans la liste..."
                                : (uIdExist
                                    ? "$mess : Vous êtes déjà invité !"
                                    : "Modification réussie...");
                        if (!diff && (userExist || uIdExist)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackBar),
                              padding: const EdgeInsets.all(15.0),
                            ),
                          );
                        } else {
                          _groupListUser[index] = _editGuestCtl!.text;
                          _groupDropdownGroup[index] = _dropdownGroup!;
                          _groupDropdownRole[index] = _dropdownRole!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackBar),
                              padding: const EdgeInsets.all(15.0),
                            ),
                          );
                        }
                      });

                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Modifier",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            );
          });
        });
  }
}
