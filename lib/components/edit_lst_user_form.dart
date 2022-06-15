import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class EditListUserForm extends StatefulWidget {
  //const EditListUserForm({Key? key}) : super(key: key);
  late final String documentId;
  late final String nameEvent;

  EditListUserForm({
    required this.documentId,
    required this.nameEvent,
  });

  @override
  _EditListUserFormState createState() => _EditListUserFormState();
}

class _EditListUserFormState extends State<EditListUserForm> {
  //Cette page est le contenu de la page de modification la liste d'invitation
  // The inital group value
  //static final GlobalKey<FormState> _lstUserFormKey = GlobalKey();

  final TextEditingController _guestCtl = TextEditingController();
  TextEditingController? _editGuestCtl;

  //dropDown pour le group
  String? _dropdownGroup = DatabaseTest.lstGrAdded[0];

  //dropDown pour le role
  static final List<String> _roleDropDown = ["Invité", "Scanneur"];
  String? _dropdownRole = _roleDropDown[0];

  late int taille = 1;

  //pour éviter appuyer plusieurs fois
  bool _isProcessing = false;

  //final TextEditingController _guestEditCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Form(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //ajouter d'une liste d'invitation (1 QRCode pour toute la durée)
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Titre : ${widget.nameEvent}",
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
                                  hintText: 'Ex: tom@gmail.com',
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //Pour dropdown le groupe
                                  Container(
                                    height: 50,
                                    child: DropdownButtonHideUnderline(
                                      child: GFDropdown(
                                        borderRadius: BorderRadius.circular(5),
                                        value: _dropdownGroup,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _dropdownGroup =
                                                newValue as String?;
                                          });
                                        },
                                        items: DatabaseTest.lstGrAdded
                                            .map((value) => DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  //Pour dropdown le role
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
                                              bool userExist = DatabaseTest
                                                  .lstUserAdded
                                                  .contains(mess);
                                              bool uIdExist = DatabaseTest
                                                  .userUid
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
                                                        const EdgeInsets.all(
                                                            15.0),
                                                  ),
                                                );
                                              } else {
                                                DatabaseTest.lstUserAdded
                                                    .add(mess);
                                                DatabaseTest.lstGroupAdded
                                                    .add(_dropdownGroup!);
                                                DatabaseTest.lstRoleAdded
                                                    .add(_dropdownRole!);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(snackBar),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                  ),
                                                );
                                              }
                                              _guestCtl.clear();
                                            });
                                          },
                                          child: Wrap(
                                            children: const <Widget>[
                                              Text('Inviter')
                                            ],
                                          ))),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //afficher la liste d'invitation afin de consulter avant de sauvegarder dans la BDD
                              ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: DatabaseTest.lstUserAdded.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GFListTile(
                                          //appuyer dessous pour consulter cette personne
                                          onTap: () {
                                            setState(() {
                                              _editGuestCtl =
                                                  TextEditingController(
                                                      text: DatabaseTest
                                                          .lstUserAdded[index]);
                                              _modify(context, index);
                                            });
                                          },
                                          color: index.isEven
                                              ? CustomColors.lightPrimaryColor
                                              : CustomColors.lightPrimaryColor
                                                  .withOpacity(0.6),
                                          titleText:
                                              DatabaseTest.lstUserAdded[index],
                                          subTitleText: "Groupe: " +
                                              DatabaseTest
                                                  .lstGroupAdded[index] +
                                              " - Role: " +
                                              DatabaseTest.lstRoleAdded[index],
                                          icon: IconButton(
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                            onPressed: () {
                                              setState(() {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Supprimé ${DatabaseTest.lstUserAdded[index]} ..."),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                  ),
                                                );
                                                DatabaseTest.lstUserAdded
                                                    .removeAt(index);
                                                DatabaseTest.lstGroupAdded
                                                    .removeAt(index);
                                                DatabaseTest.lstRoleAdded
                                                    .removeAt(index);
                                              });
                                            },
                                          ));
                                    },
                                  ),
                                )
                              ]),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          )
                        ],
                      ))),
                  _isProcessing
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
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
                              //un HashMap
                              HashMap<int, String> checkLstMail = HashMap<int, String>();
                              for (int i = 0; i < DatabaseTest.lstUserAdded.length; i++) {
                                checkLstMail.putIfAbsent(i, () => DatabaseTest.lstUserAdded[i]);
                              }
                              debugPrint(checkLstMail.toString());
                              //Cette commande permet de mettre à jour la liste d'invitation (changer le role, le groupe, supprimer ou ajouter une autre personne,..)
                              await DatabaseTest.updateListUser(
                                  docId: widget.documentId,
                                  lstGroupUpdate: DatabaseTest.lstGroupAdded,
                                  lstEmailUpdate: DatabaseTest.lstUserAdded,
                                  lstRoleUpdate: DatabaseTest.lstRoleAdded);

                              setState(() {
                                _isProcessing = false;
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                "Sauvegarder",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ))),
        ));
  }
  //modal pour modification
  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext _context, StateSetter _setState) {
            return AlertDialog(
              title: Text("Modifier les informations de l'invité ${DatabaseTest.lstUserAdded[index]}"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  maxLines: 1,
                  readOnly: true,
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
                      margin: const EdgeInsets.only(top: 15),
                      child: DropdownButtonHideUnderline(
                        child: GFDropdown(
                          padding: const EdgeInsets.all(15),
                          borderRadius: BorderRadius.circular(5),
                          border: BorderSide(
                              color: CustomColors.primaryText, width: 1),
                          // dropdownButtonColor: CustomColors.secondaryText,
                          value: DatabaseTest.lstGroupAdded[index],
                          onChanged: (newValue) {
                            _setState(() {
                              DatabaseTest.lstGroupAdded[index] =
                                  newValue as String;
                            });
                          },
                          items: DatabaseTest.lstGrAdded
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
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
                          border: BorderSide(
                              color: CustomColors.primaryText, width: 1),
                          value: _dropdownRole,
                          onChanged: (newValue) {
                            _setState(() {
                              _dropdownRole = newValue as String?;
                              debugPrint(_dropdownRole);
                            });
                          },
                          items: _roleDropDown
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      String mess = _editGuestCtl!.text;
                      bool diff =
                          mess.contains(DatabaseTest.lstUserAdded[index]);
                      bool userExist = DatabaseTest.lstUserAdded.contains(mess);
                      bool uIdExist = DatabaseTest.userUid.contains(mess);
                      String snackBar = diff
                          ? " Modification réussie..."
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
                        DatabaseTest.lstUserAdded[index] = _editGuestCtl!.text;
                        DatabaseTest.lstRoleAdded[index] = _dropdownRole!;
                        debugPrint( DatabaseTest.lstGroupAdded[index]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(snackBar),
                            padding: const EdgeInsets.all(15.0),
                          ),
                        );
                      }
                      _editGuestCtl!.clear();
                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Modifier',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
