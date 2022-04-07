import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  // The inital group value
  String _selectedOption = 'Default';
  String _selectedUser = '';
  final List<String> _groupListUser = [];
  final List<String> _groupDropdownValue = [];
  int count = 0;
  bool _selected = true;
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _guestCtl = TextEditingController();

  String? _dropdownValue = DatabaseTest.listNameGroup[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.blueJeans,
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
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please chose which option you want:'),
              ListTile(
                leading: Radio<String>(
                  value: 'Default',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                      _selected = true;
                    });
                  },
                ),
                title: const Text('Default'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'Option',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value!;
                      _selected = false;
                    });
                  },
                ),
                title: const Text('Option'),
              ),
              //const SizedBox(height: 5),
              _selected ?
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
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
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
                                      ),
                                      Container(
                                        height: 50,
                                        //width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(5),
                                        child: DropdownButtonHideUnderline(
                                          child: GFDropdown(
                                            padding: const EdgeInsets.all(15),
                                            borderRadius: BorderRadius.circular(5),
                                            border: const BorderSide(
                                                color: Colors.black12, width: 1),
                                            dropdownButtonColor: Colors.white,
                                            value: _dropdownValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _dropdownValue = newValue as String?;
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
                                      )
                                     /* ElevatedButton(
                                          onPressed: () {
                                            _groupListUser.add(_guestCtl.text);
                                            _guestCtl.text = "";
                                            setState(() {
                                              // _selectedUser = _guestCtl.text;
                                              //_groupListUser.add(_selectedUser);
                                            });
                                          },
                                          child: Wrap(
                                            children: const <Widget>[
                                              Text('ADD')
                                            ],
                                          ))*/
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _groupListUser.add(_guestCtl.text);
                                      _groupDropdownValue.add(_dropdownValue!);
                                      _guestCtl.text = "";
                                      setState(() {
                                        // _selectedUser = _guestCtl.text;
                                        //_groupListUser.add(_selectedUser);
                                      });
                                    },
                                    child: Wrap(
                                      children: const <Widget>[
                                        Text('ADD')
                                      ],
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                //Container(
                                //afficher la liste d'invitation afin de consulter avant de sauvegarder dans la BDD
                                ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(height: 15),
                                  Container(
                                    height: 200.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _groupListUser.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            child: Row(children: <Widget>[
                                          GFButton(
                                            icon: Icon(Icons.close),
                                            text: "Email: " + _groupListUser[index] + " - Group: " + _groupDropdownValue[index],
                                            onPressed: () {
                                              setState(() {
                                                print("del : " +
                                                    _groupListUser[index]);
                                                print("index : " +
                                                    index.toString());
                                                _groupListUser.removeAt(index);
                                                DatabaseTest.listInvite =
                                                    _groupListUser;
                                                print("Data save : " +
                                                    DatabaseTest.listInvite
                                                        .toString());
                                              });
                                            },
                                            shape: GFButtonShape.pills,
                                            color: Colors.orangeAccent,

                                          )
                                        ]));
                                      },
                                    ),
                                  )
                                ]),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          )
                        ],
                      )))
                  :
                  //ajouter d'un groupe avec des personnes et chaque possède un QRCode
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 16,
                              child: Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    const SizedBox(height: 20),
                                    const Center(
                                        child: const Text('Add something')),
                                    const SizedBox(height: 20),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                              maxLines: 1,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              controller: _guestCtl,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter email of guest',
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                          //const Text("data"),
                                          //const SizedBox(width: 5),
                                          ElevatedButton(
                                              onPressed: () {
                                                _selectedUser = _guestCtl.text;
                                                _groupListUser
                                                    .add(_selectedUser);
                                                setState(() {
                                                  // _selectedUser = _guestCtl.text;
                                                  //_groupListUser.add(_selectedUser);
                                                });
                                              },
                                              child: Wrap(
                                                children: const <Widget>[
                                                  Text('Add')
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(_groupListUser.isEmpty
                                        ? "Nothing to show"
                                        : _groupListUser.toString()),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        setState(() {});
                      },
                      child: Wrap(
                        children: const <Widget>[Text('Add')],
                      )),
              _selected
                  ? const Text("")
                  : TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtl,
                    ),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      CustomColors.firebaseOrange,
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
                    await DatabaseTest.addInviteList(listEmail: _groupListUser, listGroup: _groupDropdownValue);
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
                        color: CustomColors.firebaseGrey,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              )

              //Text(_selectedOption == 'Option' ? 'You can create a group of user' : 'Add list of user you want to invite' )
            ],
          ))),
    );
  }

  void _deleteItem() {
    setState(() {
      _groupListUser.removeLast();
    });
  }
}
