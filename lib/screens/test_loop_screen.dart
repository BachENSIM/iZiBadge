import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:getwidget/getwidget.dart';


class TestLoop extends StatefulWidget {
  const TestLoop({Key? key}) : super(key: key);

  @override
  _TestLoopState createState() => _TestLoopState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class _TestLoopState extends State<TestLoop> {
  List<String> _groupListUser = [];
  final TextEditingController _guestCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test")),
      body: Padding(
          padding: const EdgeInsets.all(25),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              controller: _guestCtl,
                              decoration: InputDecoration(
                                hintText: 'Enter email of guest',
                                contentPadding: EdgeInsets.all(8),
                                isDense: true,
                                suffix: IconButton(
                                    onPressed: () {
                                      _guestCtl.clear();
                                    },
                                    icon: Icon(Icons.close)
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _groupListUser.add(_guestCtl.text);
                                _guestCtl.clear();
                                setState(() {
                                  // _selectedUser = _guestCtl.text;
                                  //_groupListUser.add(_selectedUser);
                                });
                              },
                              child: Wrap(
                                children: const <Widget>[Text('Add')],
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    //Container(
                    ListView(shrinkWrap: true, children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _groupListUser.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: Row(children: <Widget>[
                                  GFButton(
                                      icon: Icon(Icons.close),
                                      text: _groupListUser[index],
                                      onPressed: () {
                                        setState(() {
                                          print("del : " + _groupListUser[index]);
                                          print("index : " + index.toString());
                                          _groupListUser.removeAt(index);
                                        });
                                      },
                                    shape: GFButtonShape.pills ,
                                    color: Colors.orangeAccent,
                                    hoverColor: Colors.red,
                                    focusColor: Colors.red,
                                  )


                              /*Text(_groupListUser[index]),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      print("del : " + _groupListUser[index]);
                                      print("index : " + index.toString());
                                      _groupListUser.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.close)),*/
                            ]));
                          },
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 25,
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
                          //Navigator.of(context).pop();
                          for (int i = 0; i < _groupListUser.length; i++) {
                            DocumentReference documentReferencer = _mainCollection
                                .doc("test@gmail.com")
                                .collection('items')
                                .doc('DY2kddSmQGxTLMax7KNi')
                                .collection('participation')
                                .doc();
                            print("ID docs " + documentReferencer.id);
                            Map<String, dynamic> data = <String, dynamic>{
                              "role": "Invité",
                              "statutEntree": false,
                              "timestamp": DateTime.now(),
                              "email": _groupListUser[i],
                            };

                            //print(" ID " + i.toString());
                            //add invitation of every one
                            await documentReferencer.set(data).whenComplete(() {
                              print(documentReferencer.id + " ID ");
                            }).catchError((e) => print(e));
                          }
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
                  ],
                ),
              )
            ],
          ))),
    );
  }
}

/*TextFormField(
                controller: _guestCtl,

                decoration: InputDecoration(
                  suffix: IconButton(
                    onPressed: () {
                      _guestCtl.clear();

                    },
                      icon: Icon(Icons.close)
                  ),
                  suffixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.green;
                    }
                    if (states.contains(MaterialState.error)) {
                      return Colors.red;
                    }
                    return Colors.grey;
                  }),

                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )*/
