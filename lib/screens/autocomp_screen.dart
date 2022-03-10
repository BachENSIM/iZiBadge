import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database.dart';

class AutoScreen extends StatefulWidget {
  const AutoScreen({Key? key}) : super(key: key);

  @override
  _AutoScreenState createState() => _AutoScreenState();
}

class _AutoScreenState extends State<AutoScreen> {
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
    /*return StreamBuilder<QuerySnapshot>(
      stream: Database.readEmails(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index].data()! as Map<String, dynamic>;//Dart doesn’t know which type of object it is getting.
              String docID = snapshot.data!.docs[index].id;
              List<dynamic> _listEmail = noteInfo['email'];

             _lstEmail = _listEmail.toString().split(",");
              /*for(int i = 0;i < _listEmail.length;i ++) {
                _email = _email +  _listEmail[i] + "\n";
              }*/

              //_lstEmail = _listEmail as List<String>;
              return Autocomplete<String>(
                optionsBuilder: (TextEditingValue value) {
                  // When the field is empty
                  if (value.text.isEmpty) {
                    return [];
                  }

                  // The logic to find out which ones should appear
                  return _suggestions.where((suggestion) =>
                      suggestion.toLowerCase().contains(value.text.toLowerCase()));
                },
                onSelected: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              );
              return const SizedBox(
                height: 30,
              );
              return Text(_email ?? 'Type something (a, b, c, etc)') ;
              //return Text(_suggestions.toString());
              /*return Autocomplete<String>(
                optionsBuilder: (TextEditingValue value) {
                  // When the field is empty
                  if (value.text.isEmpty) {
                    return [];
                  }

                  // The logic to find out which ones should appear
                  return _lstEmail.where((suggestion) =>
                      suggestion.toLowerCase().contains(value.text.toLowerCase()));
                },
                onSelected: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              );*/

              /*return Ink(
                decoration: BoxDecoration(
                  color: CustomColors.firebaseGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).pop(context),
    /*Navigator.of(context).push(context)
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        currTitle: title,
                        currDesc: description,
                        currAddr: address,
                        //currStartDate: startDate.toDate(),
                        documentId: docID,
                      ),
                    ),
                  )*/
                  title: Text(
                    "Email: " + _email,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  /*subtitle: Text(
                    "Desc: " + description + "\nAdresse: " + address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),*/
                ),
              );*/
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
*/

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
              onPressed: () {

              },
              child: Wrap(
                children: const <Widget>[Text('Add')],
              )
          ),
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
