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

  //final TextEditingController _guestEditCtl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (DatabaseTest.lstPersonScanned.isNotEmpty)
      DatabaseTest.lstPersonScanned.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.backgroundColorDark,
          centerTitle: true,
          title: const Text(
            'Add list of invite',
          ),
          leadingWidth: 100,
          leading: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_left_sharp),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
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
                          Container(
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                TextFormField(
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _guestCtl,
                                  validator: (value) => value!.isEmpty
                                      ? 'Email cannot be blank'
                                      : null,
                                  decoration: const InputDecoration(
                                    hintText: 'Example: tom@gmail.com',
                                    contentPadding: EdgeInsets.all(8),
                                    isDense: true,
                                  ),
                                ),
                                /*Expanded(
                                  child: TextFormField(
                                    maxLines: 1,
                                    keyboardType:
                                    TextInputType.emailAddress,
                                    controller: _guestCtl,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter email of guest',
                                      contentPadding: EdgeInsets.all(8),
                                      isDense: true,
                                    ),
                                  ),
                                ),*/
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //Pour le groupe
                                      Container(
                                        height: 50,
                                        //width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(5),
                                        child: DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            padding: const EdgeInsets.all(15),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: const BorderSide(
                                                color: CustomColors.textPrimary,
                                                width: 1),
                                            dropdownButtonColor:
                                                CustomColors.textSecondary,
                                            value: _dropdownGroup,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _dropdownGroup =
                                                    newValue as String?;
                                              });
                                            },
                                            items: DatabaseTest.listNameGroup
                                                .map(
                                                    (value) => DropdownMenuItem(
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
                                        margin: EdgeInsets.all(5),
                                        child: DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            padding: const EdgeInsets.all(15),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: const BorderSide(
                                                color: CustomColors.textPrimary,
                                                width: 1),
                                            dropdownButtonColor:
                                                CustomColors.textSecondary,
                                            value: _dropdownRole,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _dropdownRole =
                                                    newValue as String?;
                                                print(_dropdownRole);
                                              });
                                            },
                                            items: _roleDropDown
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value),
                                                        ))
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        String mess = _guestCtl.text;
                                        if (_guestCtl.text.isEmpty) {
                                          int size = _groupListUser.length + 1;
                                          mess = "example" +
                                              size.toString() +
                                              "@gmail.com";
                                          _groupListUser.add(mess);
                                        } else {
                                          _groupListUser.add(_guestCtl.text);
                                        }

                                        //_groupListUser.add(_guestCtl.text);
                                        _groupDropdownGroup
                                            .add(_dropdownGroup!);
                                        _groupDropdownRole.add(_dropdownRole!);
                                        _guestCtl.clear();
                                      });
                                    },
                                    child: Wrap(
                                      children: const <Widget>[Text('ADD')],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                //afficher la liste d'invitation afin de consulter avant de sauvegarder dans la BDD
                                ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(height: 15),
                                  Container(
                                    height: 275.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
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
                                              color: CustomColors.accentDark,
                                              titleText: "Email: " +
                                                  _groupListUser[index],
                                              subTitleText: "Group: " +
                                                  _groupDropdownGroup[index] +
                                                  " - Role: " +
                                                  _groupDropdownRole[index],
                                              icon: IconButton(
                                                icon:
                                                    Icon(Icons.cancel_outlined),
                                                onPressed: () {
                                                  setState(() {
                                                    _groupListUser
                                                        .removeAt(index);
                                                    _groupDropdownGroup
                                                        .removeAt(index);
                                                    _groupDropdownRole
                                                        .removeAt(index);
                                                    DatabaseTest.listInvite =
                                                        _groupListUser;
                                                    print(index);
                                                  });
                                                },
                                                color: CustomColors.textPrimary,
                                              )),
                                        ]));
                                      },
                                    ),
                                  )
                                ]),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomColors.accentDark,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        //print(DatabaseTest.nameSave.toString());
                        //print(DatabaseTest.descSave.toString());
                        //print(DatabaseTest.addrSave.toString());

                        await DatabaseTest.addItem(
                          title: DatabaseTest.nameSave.toString(),
                          description: DatabaseTest.descSave.toString(),
                          address: DatabaseTest.addrSave.toString(),
                          start: DateTime.parse(DateTime.now().toString()),
                          end: DateTime.parse(DateTime.now().toString()),
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
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.textSecondary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))),
        ));
  }

  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            /*title: const Text('Please Confirm'),*/
            content: const Text('Edit your information?'),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: CustomColors.textPrimary, width: 1),
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
                      controller: _editGuestCtl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                      ),
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
                        margin: EdgeInsets.all(5),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            border: const BorderSide(
                                color: CustomColors.textPrimary, width: 1),
                            dropdownButtonColor: CustomColors.textSecondary,
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
                        margin: EdgeInsets.all(5),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(5),
                            border: const BorderSide(
                                color: CustomColors.textPrimary, width: 1),
                            dropdownButtonColor: CustomColors.textSecondary,
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
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            // Remove the box
                            setState(() {
                              _groupListUser[index] = _editGuestCtl!.text;
                              _groupDropdownGroup[index] = _dropdownGroup!;
                              _groupDropdownRole[index] = _dropdownRole!;
                            });

                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Edit')),
                      TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'))
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
