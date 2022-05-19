import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class Database {
  static String? userUid = "test@gmail.com";
  static List<String> listRole = [];
  DocumentSnapshot? snapshot;
  //static Query<Map<String, dynamic>> map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation').snapshots() as Query<Map<String, dynamic>>;

  void getRole() async {
    final data = await FirebaseFirestore.instance.collection('evenements').doc(userUid).collection('items').doc().collection('participation').get();
    //listRole = (data as DocumentSnapshot).data['email'].toString() as List<String>;
    snapshot = data as DocumentSnapshot<Object?>?;
  }



  static Future<void> addItem({
    required String title,
    required String description,
    required String address,
    required DateTime start,
    required DateTime end,

  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc();
    //_mainCollection.doc("test@gmail.com").collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "tittre": title,
      "description": description,
      "adresse": address,
      "dateDebut": start,
      "dateEnd": end,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print(userUid! + "Event of this account added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String address,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc(docId);
    //_mainCollection.doc("test@gmail.com").collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "titre": title,
      "description": description,
      "adresse": address,
    };
    debugPrint("$title $description $address");
    await documentReferencer
        .update(data)
        .whenComplete(() => print("Event of this account updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    //code source pour recuperer touts les evenements
    Query<Map<String, dynamic>> notesItemCollection =
    _mainCollection.doc(userUid).collection("items")
        .orderBy("dateDebut", descending: true);

    //modifier pour comparer des emails qui existent dans la liste d'invitation vont afficher sur l'ecran

    /*Query<Map<String, dynamic>> notesItemCollection =
    _mainCollection.doc(userUid).collection("items").doc().collection("participation").where("email",isEqualTo: userUid);*/
    //_mainCollection.doc("test@gmail.com").collection('items');

    return notesItemCollection.snapshots();
  }


  static Stream<QuerySnapshot> readEmails() {
    Query<Map<String, dynamic>> itemsEmailCollection =
    _mainCollection.doc(userUid).collection("emails");
    //_mainCollection.doc("test@gmail.com").collection('items');

    return itemsEmailCollection .snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc(docId);
    //_mainCollection.doc("test@gmail.com").collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Event of this account deleted from the database'))
        .catchError((e) => print(e));
  }
}
