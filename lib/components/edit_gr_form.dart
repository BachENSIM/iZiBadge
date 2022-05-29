import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class EditGroupForm extends StatefulWidget {
  //const EditGroupForm({Key? key}) : super(key: key);
  late final String documentId;
  late final String nameEvent;

  EditGroupForm({
    required this.documentId,
    required this.nameEvent,
  });

  @override
  _EditGroupFormState createState() => _EditGroupFormState();
}

class _EditGroupFormState extends State<EditGroupForm> {
  // un autre controller pour saisir => creer des groupe differents
  final _groupNameCtl = TextEditingController();

  //un autre controller pour modifier le nom d'un groupe
  TextEditingController? _groupEditCtl;

  //un controller par default => afficher un groupe par default
  String initialText = "Groupe 2";
  TextEditingController? _groupInitCtl;

  //verifier l'indice de la liste => si = 0 => c'est le default
  bool _one = false;
  bool _isProcessing = false;

  //pour sauvegarder dans la BDD

  late int taille = 2;

  @override
  void initState() {
    super.initState();
    _groupInitCtl = TextEditingController(text: initialText);
    //_groupNameList = DatabaseTest.lstGrAdded;
    //print("qdqsd" + DatabaseTest.lstGrAdded.length.toString());
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
            Text(
              "Titre : ${widget.nameEvent}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: _groupNameCtl,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    //Hides label on focus or if filled
                    labelText: "Ex: Groupe Etudiant",
                    filled: true,
                    // Needed for adding a fill color
                    // fillColor: CustomColors.backgroundLight,
                    isDense: false,
                    // Reduces height a bit
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0)),
                    ),
                    prefixIcon: const Icon(Icons.group_add, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: IconButton(
                          onPressed: () {
                            _groupNameCtl.clear();
                          },
                          icon: const Icon(Icons.clear_rounded)),
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
                            mess = "Groupe " + (taille++).toString();
                          }
                          if (DatabaseTest.lstGrAdded.contains(mess)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$mess est déjà créé ..."),
                                padding: const EdgeInsets.all(15.0),
                              ),
                            );
                          } else {
                            //_groupNameList.add(mess);
                            DatabaseTest.lstGrAdded.add(mess);
                            _groupNameCtl.clear();
                          }
                          //print(DatabaseTest.listNameGroup.toString());
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
                            // color: CustomColors.textSecondary,
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
                height: MediaQuery.of(context).size.height / 1.7,
                child: ListView.builder(
                  shrinkWrap: true,
                  //itemCount: _groupNameList.length,
                  itemCount: DatabaseTest.lstGrAdded.length,
                  itemBuilder: (BuildContext context, int index) {
                    //if (_groupNameList.length == 1)
                    (DatabaseTest.lstGrAdded.length == 1)
                        ? _one = true
                        : _one = false;
                    return Column(children: <Widget>[
                      GFListTile(
                        color: index.isEven
                            ? CustomColors.lightPrimaryColor
                            : CustomColors.lightPrimaryColor.withOpacity(0.6),
                        avatar: CircleAvatar(
                            radius: 20,
                            // backgroundColor: CustomColors.accentDark,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                // color: CustomColors.textSecondary
                              ),
                            )),
                        //titleText: _groupNameList[index],
                        titleText: DatabaseTest.lstGrAdded[index],
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit_rounded),
                              onPressed: () {
                                _groupEditCtl = TextEditingController(
                                    //text: _groupNameList[index]);
                                    text: DatabaseTest.lstGrAdded[index]);
                                setState(() {
                                  _modify(context, index);
                                });
                              },
                              // color: CustomColors.accentDark,
                            ),
                            if (!_one)
                              IconButton(
                                icon: const Icon(Icons.delete_forever_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (!_one) {
                                      //_groupNameList.removeAt(index);
                                      DatabaseTest.lstGrAdded.removeAt(index);
                                      //DatabaseTest.listNameGroup.removeAt(index);
                                    }
                                  });
                                },
                                // color: _one
                                //     ? Colors.grey
                                //     : CustomColors.accentDark,
                              )
                          ],
                        ),
                      ),
                    ]);
                  },
                ),
              )
            ]),
            const SizedBox(
              height: 15,
            ),
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
                : Container(
                    width: double.maxFinite,
                    // alignment: Alignment.center,
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
                          _isProcessing = false;
                        });
                        await DatabaseTest.updateGroup(
                            docId: widget.documentId,
                            lstGroupUpdate: DatabaseTest.lstGrAdded);
                        setState(() {
                          _isProcessing = true;
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
        ),
      ),
    );
  }

  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Modifier le nom du groupe'),
            content: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              controller: _groupEditCtl,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
              ),
            ),
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
              TextButton(
                onPressed: () {
                  // Remove the box
                  setState(() {
                    DatabaseTest.lstGrAdded[index] = _groupEditCtl!.text;
                    // DatabaseTest.listNameGroup[index] =
                    // _groupNameList[index];
                    //print("list" +  DatabaseTest.lstGrAdded[index]);
                    // print("data: " +
                    //     DatabaseTest.listNameGroup.toString());
                    _groupEditCtl?.clear();
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
  }
}
