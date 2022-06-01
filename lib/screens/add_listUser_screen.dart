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
  static final GlobalKey<FormState> _lstUserFormKey = GlobalKey();

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
          key: _lstUserFormKey,
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
                                      /*border: const BorderSide(
                                          //color: CustomColors.textPrimary,
                                          width: 1),*/
                                      // dropdownButtonColor:
                                      //     CustomColors.textSecondary,
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
                                  //width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(5),
                                  child: DropdownButtonHideUnderline(
                                    child: GFDropdown(
                                      padding: const EdgeInsets.all(15),
                                      borderRadius: BorderRadius.circular(5),
                                      /* border: const BorderSide(
                                          //color: CustomColors.textPrimary,
                                          width: 1),*/
                                      // dropdownButtonColor:
                                      //     CustomColors.textSecondary,
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
                                          String mess = _guestCtl.text;
                                          if (_guestCtl.text.isEmpty) {
                                            mess =
                                                "example${taille++}@gmail.com";
                                          }
                                          //debugPrint(mess);
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
                                            //_groupListUser.add(_guestCtl.text);
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
                                          //color: CustomColors.accentDark,
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
                                                print(index);
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
                _isProcessing
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                              // valueColor: AlwaysStoppedAnimation<Color>(
                              //   CustomColors.accentLight,
                              // ),
                              ),
                        ),
                      )
                    : SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            // backgroundColor: MaterialStateProperty.all(
                            //   CustomColors.accentDark,
                            // ),
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

                            await DatabaseTest.addItem(
                              title: DatabaseTest.nameSave.toString(),
                              description: DatabaseTest.descSave.toString(),
                              address: DatabaseTest.addrSave.toString(),
                              /*start: DateTime.parse(DateTime.now().toString()),
                              end: DateTime.parse(DateTime.now().toString()),*/
                              start: DateTime(yearStart, monthStart, dayStart,
                                  hourStart, minuteStart),
                              end: DateTime(yearEnd, monthEnd, dayEnd, hourEnd,
                                  minuteEnd),
                              role: "Organisateur",
                            );
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
                                //color: CustomColors.textPrimary, width: 1
                                ),
                            // dropdownButtonColor: CustomColors.textSecondary,
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
                                //color: CustomColors.textPrimary, width: 1
                                ),
                            // dropdownButtonColor: CustomColors.textSecondary,
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
                  // side: BorderSide(
                  // color: CustomColors.textPrimary,
                  // width: 1),
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
