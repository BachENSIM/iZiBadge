import 'package:flutter/material.dart';

class TestLoop extends StatefulWidget {
  const TestLoop({Key? key}) : super(key: key);

  @override
  _TestLoopState createState() => _TestLoopState();
}

class _TestLoopState extends State<TestLoop> {
  List<String> _groupListUser = [];
  String _selectedUser = '';
  int count = 0;
  final TextEditingController _guestCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("test")),
      body: Padding(
          padding: const EdgeInsets.all(25),
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
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _groupListUser.length,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            child: Text(
                                _groupListUser[index]
                            ),
                          );
                        },
                      ),

                    /*Row(
                        children: <Widget>[
                          Text(_groupListUser.toString()),
                          Icon(Icons.close),

                        ]
                    )*/
                  ],
                ),
              )

            ],
          )),
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
class Content extends StatelessWidget {
  final List<String> elements = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "A Million Billion Trillion",
    "A much, much longer text that will still fit"
  ];
  @override
  Widget build(context) => GridView.builder(
      itemCount: elements.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130.0,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
      ),
      itemBuilder: (context, i) => Card(
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(elements[i])))))));
}
