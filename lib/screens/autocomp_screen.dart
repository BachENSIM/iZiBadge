import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AutoScreen extends StatefulWidget {
  const AutoScreen({Key? key}) : super(key: key);

  @override
  _AutoScreenState createState() => _AutoScreenState();
}

class _AutoScreenState extends State<AutoScreen> {

  //Cette page pour automatique remplir le champ quand on saisit un email (autocomplete form)
  //Mais je n'ai pas le temps pour finir cette partie donc cette page n'est jamais utilisé

  CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('evenements')
      .doc('test@gmail.com')
      .collection('emails');
  DocumentReference _documentReference = FirebaseFirestore.instance
      .collection('evenements')
      .doc('test@gmail.com')
      .collection('emails')
      .doc('test@gmail.com');

  /*Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionReference.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }*/

  /*static Query<Map<String, dynamic>> emailCollection =
  FirebaseFirestore.instance.collection('evenements').doc('test@gmail.com').collection('emails');
  static Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = emailCollection.snapshots();
  //print(querySnapshot);
  final  List<String> _listEmail =  querySnapshot.toList() as List<String>;*/

  /*Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('evenements').doc('test@gmail.com').collection('emails').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.data());
    }
  }*/
  //QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('evenements').doc('test@gmail.com').collection('emails').get();

  String? _email;
  final List<String> _lstEmail = [];
  final List<String> _suggestions = [
    'Alligator',
    'Buffalo',
    'Chicken',
    'Dog',
    'Eagle',
    'Frog'
  ];
  final TextEditingValue valueEdit = TextEditingValue();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: Column(
        children: [
          Autocomplete<String>(
            //optionsBuilder: (TextEditingValue value) {
            optionsBuilder: (valueEdit) {
              // When the field is empty
              if (valueEdit.text.isEmpty) {
                return [];
              }

              // The logic to find out which ones should appear
              return _suggestions.where((suggestion) => suggestion
                  .toLowerCase()
                  .contains(valueEdit.text.toLowerCase()));
            },
            onSelected: (valueEdit) {
              setState(() {
                //_email =  _email! + value;
                _lstEmail.add(valueEdit);
              });
            },
          ),
          ElevatedButton(
              onPressed: () {},
              child: Wrap(
                children: const <Widget>[Text('Add')],
              )),
          const SizedBox(
            height: 30,
          ),
          //Text(_email ?? 'Type something (a, b, c, etc)'),
          Text(_lstEmail.isEmpty
              ? 'Type something (a, b, c, etc)'
              : _lstEmail.toString()),
          //Text(_listEmail.toString()),
        ],
      ),
    );
  }
}
