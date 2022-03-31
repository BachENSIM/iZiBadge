import 'package:flutter/material.dart';
import 'package:izibagde/model/database_test.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _searchCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
          child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 16,
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        controller: _searchCtl,
                        decoration: const InputDecoration(
                          hintText: 'Search by name of event',
                          contentPadding: EdgeInsets.all(8),
                          isDense: true,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            DatabaseTest.searchSave = _searchCtl.text;
                            print(DatabaseTest.searchSave);
                            Navigator.of(context).pop();
                          });
                        },
                        child: Wrap(
                          children: const <Widget>[Text('Search')],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
