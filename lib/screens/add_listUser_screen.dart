import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/screens/autocomp_screen.dart';

class RadioUserPage extends StatefulWidget {
  const RadioUserPage({Key? key}) : super(key: key);

  @override
  _RadioUserPageState createState() => _RadioUserPageState();
}

class _RadioUserPageState extends State<RadioUserPage> {
  // The inital group value
  String _selectedOption = 'Default';
  String _selectedUser = '';
  final List<String> _groupListUser = [];
  int count =0;
  bool _selected = true;
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _guestCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const SizedBox(height: 25),
              _selected
                  ? /*TextFormField(
                      maxLines: 5,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtl,
                      decoration: const InputDecoration(
                        hintText: 'List of user',
                        contentPadding: EdgeInsets.all(8),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    )*/
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
                                    decoration: const InputDecoration(
                                      hintText: 'Enter email of guest',
                                      contentPadding: EdgeInsets.all(8),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                //const Text("data"),
                                //const SizedBox(width: 5),
                                ElevatedButton(
                                    onPressed: () {
                                      _selectedUser = _guestCtl.text;
                                      _groupListUser.add(_selectedUser);
                                      print("count:" + count.toString());
                                      count++;

                                      //_groupListUser.removeLast();
                                      _guestCtl.text = " ";
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
                            height: 30,
                          ),
                          Text(_groupListUser.isEmpty
                              ? "Nothing to show"
                              : _groupListUser.toString()),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [


                              //Text(_groupListUser[count++]),
                              Text(_groupListUser[1]),
                              Icon(Icons.close),

                            ],
                          )
                        ],
                      ),
                    )
                  : ElevatedButton(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AutoScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 24,
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
          )),
    );
  }

  void _deleteItem() {
    setState(() {
      _groupListUser.removeLast();
    });
  }
}
