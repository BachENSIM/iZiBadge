import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/model/database_test.dart';

import 'custom_colors.dart';

class GroupForm extends StatefulWidget {
  //const GroupForm({Key? key}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _groupNameCtl =
      TextEditingController(); // un autre controller pour saisir => creer des groupe differents
  TextEditingController?
      _groupEditCtl; //un autre controller pour modifier le nom d'un groupe
  //un controller par default => afficher un groupe par default
  String initialText = "Default Group 1";
  TextEditingController? _groupInitCtl;

  bool _zero =
      true; //verifier l'indice de la liste => si = 0 => c'est le default

  //pour sauvegarder dans la BDD
  final List<String> _groupNameList = ["Default Group 1"];
  late int taille;

  @override
  void initState() {
    super.initState();
    taille = _groupNameList.length + 1;
    _groupInitCtl = TextEditingController(text: initialText);
    if (DatabaseTest.listNameGroup.isNotEmpty)
      DatabaseTest.listNameGroup.clear();
    DatabaseTest.listNameGroup.add(_groupNameList[0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _groupInitCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: _groupNameCtl,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior
                        .never, //Hides label on focus or if filled
                    labelText: "Ex: Groupe Etudiant",
                    filled: true, // Needed for adding a fill color
                    //fillColor: CustomColors.backgroundLight,
                    isDense: false, // Reduces height a bit
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft:
                              Radius.circular(12.0)), // Apply corner radius
                    ),
                    prefixIcon: const Icon(Icons.group_add, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: IconButton(
                          onPressed: () {
                            _groupNameCtl.clear();
                          },
                          icon: Icon(Icons.clear_rounded)),
                    ),
                  ),
                )),
                SizedBox(
                  height: 59,
                  /*width: 75,*/
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String mess = _groupNameCtl.text;
                          if (_groupNameCtl.text.isEmpty) {
                            mess = "Default Group " + (taille++).toString();
                            _groupNameList.add(mess);
                          } else {
                            _groupNameList.add(_groupNameCtl.text);
                          }
                          DatabaseTest.listNameGroup.add(mess);
                          _groupNameCtl.clear();
                          print(DatabaseTest.listNameGroup.toString());
                        });
                      },
                      //style:  ElevatedButton.styleFrom(side: ),
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0)))),
                      child: const Text("Ajouter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            //color: CustomColors.textSecondary,
                          ))),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ListView(shrinkWrap: true, children: <Widget>[
              const SizedBox(height: 20),
              Container(
                height: 600.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groupNameList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index != 0)
                      _zero = false;
                    else
                      _zero = true;
                    return Container(
                        child: Column(children: <Widget>[
                      const SizedBox(
                        height: 0,
                      ),
                      /*ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.brown[400],
                          child: Text(
                            index.toString(),
                            style: const TextStyle(
                                fontSize: 15, color: CustomColors.secondaryText),
                          ),
                        ),
                        title: Text(_groupNameList[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit_rounded),
                              onPressed: () {
                                _groupEditCtl = TextEditingController(
                                    text: _groupNameList[index]);
                                setState(() {
                                  _modify(context, index);
                                });
                              },
                              color: Colors.redAccent,
                            ),
                            if (index != 0)
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (index != 0)
                                      _groupNameList.removeAt(index);
                                  });
                                },
                                color: _zero ? Colors.grey : Colors.redAccent,
                              )
                          ],
                        ),
                        //iconColor: _zero ? Colors.grey : Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15)),
                      ),*/
                      GFListTile(
                        color: CustomColors.lightPrimaryColor,
                        avatar: CircleAvatar(
                            radius: 20,
                            //backgroundColor: CustomColors.accentDark,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                //color: CustomColors.textSecondary
                              ),
                            )),
                        titleText: _groupNameList[index],
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit_rounded),
                              onPressed: () {
                                _groupEditCtl = TextEditingController(
                                    text: _groupNameList[index]);
                                setState(() {
                                  _modify(context, index);
                                });
                              },
                              //color: CustomColors.accentDark,
                            ),
                            if (index != 0)
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (index != 0) {
                                      _groupNameList.removeAt(index);
                                      DatabaseTest.listNameGroup
                                          .removeAt(index);
                                    }
                                  });
                                },
                                //color: _zero
                                //     ? Colors.grey
                                //     : CustomColors.accentDark,
                              )
                          ],
                        ),
                      ),
                    ]));
                  },
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            /*title: const Text('Please Confirm'),*/
            content: const Text('Renommer'),
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    // color: CustomColors.textPrimary,
                    width: 1),
                borderRadius: BorderRadius.circular(15)),
            actions: [
              Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 250,
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      controller: _groupEditCtl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            // Remove the box
                            setState(() {
                              _groupNameList[index] = _groupEditCtl!.text;
                              DatabaseTest.listNameGroup[index] =
                                  _groupNameList[index];
                              print("list" + _groupNameList[index]);
                              print("data: " +
                                  DatabaseTest.listNameGroup.toString());
                              _groupEditCtl?.clear();
                            });

                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK')),
                      TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annuler'))
                    ],
                  ),
                ],
              )
              // The "Yes" button
            ],
          );
        });
  }
}
