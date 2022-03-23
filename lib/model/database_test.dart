import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class DatabaseTest {
  static String userUid = "test14@gmail.com";
  static String? docIdAdd;
  static String? addrSave;
  static String? nameSave;
  static String? descSave;
  static DateTime? startSave;
  static DateTime? endSave;
  static bool isDel = false;
  static List<String>? listInvite;
  static List<String> listRole = [];

  /*static Map<String, dynamic> map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation') as Map<String, dynamic>;
  static List<String> listRole = map['email'];*/

  static Future<void> addItem({
    required String title,
    required String description,
    required String address,
    required DateTime start,
    required DateTime end,
    required String role,
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
      "role": role,
      "idDelete": isDel,
    };
    print("In Database_test : " + userUid);
    docIdAdd = documentReferencer.id;
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Event " +
            title +
            " have been added into database avec id " +
            docIdAdd!))
        .catchError((e) => print("Error " + e));
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
      "tittre": title,
      "description": description,
      "adresse": address,
      "role": isDel
    };

    await documentReferencer
        .update(data)
        .whenComplete(
            () => print("Event of this account updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    /*if(listRole.isEmpty) {
      fetchDataID();
    }
    else {
      listRole.clear();
      fetchDataID();
    }*/
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection("items")
        .orderBy("dateDebut", descending: true);
    //_mainCollection.doc("test@gmail.com").collection('items');

    return notesItemCollection.snapshots();
  }

  static Stream<QuerySnapshot> readRoles(bool isRoleOrganisateur, bool isRoleInviteur) {
    print("or : " +isRoleOrganisateur.toString() + " invi : " + isRoleInviteur.toString());
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection("items");
        //.orderBy("dateDebut", descending: true);
    if(isRoleOrganisateur && !isRoleInviteur)  return notesItemCollection.where("role",isEqualTo: "Organisateur").orderBy("dateDebut", descending: true).snapshots();
    else if(isRoleInviteur && !isRoleOrganisateur)  return notesItemCollection.where("role",isEqualTo: "Invité").orderBy("dateDebut", descending: true).snapshots();
    else   return notesItemCollection.orderBy("dateDebut", descending: true).snapshots();


    /*if(isRoleOrganisateur && !isRoleInviteur) {
      print("or : " +isRoleOrganisateur.toString() + " invi : " + isRoleInviteur.toString());
      Query<Map<String, dynamic>> notesItemCollection = _mainCollection
          .doc(userUid)
          .collection("items")
          .orderBy("dateDebut", descending: true).where("role",isEqualTo: "Organisateur");
          //.where("role",isEqualTo: "Organisateur");
      return notesItemCollection.snapshots();
    }
    else if(isRoleInviteur && !isRoleOrganisateur) {
      print("or : " +isRoleOrganisateur.toString() + " invi : " + isRoleInviteur.toString());

      Query<Map<String, dynamic>> notesItemCollection = _mainCollection
          .doc(userUid)
          .collection("items")
          //.orderBy("dateDebut", descending: true).where("role",isEqualTo: "Invité");
          .where("role",isEqualTo: "Invité");
      return notesItemCollection.snapshots();
    }
    else {
      print("or : " +isRoleOrganisateur.toString() + " invi : " + isRoleInviteur.toString());

      Query<Map<String, dynamic>> notesItemCollection = _mainCollection
          .doc(userUid)
          .collection("items")
          .orderBy("dateDebut", descending: true);
      return notesItemCollection.snapshots();
    }*/
    



  }

  static Stream<QuerySnapshot> readEmails() {
    Query<Map<String, dynamic>> itemsEmailCollection =
        _mainCollection.doc(userUid).collection("emails");
    //_mainCollection.doc("test@gmail.com").collection('items');

    return itemsEmailCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    //Step 1: need to update another events - put an attribute isDel = true to know this event has been deleted (synchronization)
    var data = await FirebaseFirestore.instance
        .collection('evenements')
        .doc(userUid)
        .collection('items')
        .doc(docId)
        .collection('participation')
        .get();
    isDel = true;
    for (int j = 0; j < data.docs.length; j++) {
      /*DocumentReference documentReferencer = _mainCollection
          .doc()
          .collection('items')
          .doc(docId);*/
      var update = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(data.docs[j].data()['email'])
          .collection('items')
          .get();
      updateItem(
          title: update.docs[j].data()['tittre'],
          description: update.docs[j].data()['description'],
          address: update.docs[j].data()['adresse'],
          docId: docId);
    }

    //Step 2 : delete list of user (participation) of this event
    final documentRefList = _mainCollection
        .doc(userUid)
        .collection('items')
        .doc(docId)
        .collection('participation')
        .get();
    await documentRefList.then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));

    //Step 3 : delete this event from DB
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);
    //_mainCollection.doc("test@gmail.com").collection('items').doc(docId);
    await documentReferencer
        .delete()
        .whenComplete(() => print('Event with id ' +
            docId +
            ' have been deleted from the database!!!'))
        .catchError((e) => print(e));
  }

  //how to add a list of mail into firebase in the same event
  static Future<void> addInviteList({
    required List<String> list,
  }) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection('items')
        .doc(docIdAdd)
        .collection('participation')
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      "role": "Organisateur",
      "statutEntree": true,
      "timestamp": DateTime.now(),
      "email": userUid,
    };

    await documentReferencer
        .set(data)
        .whenComplete(
            () => print("Add Organisateur : id " + documentReferencer.id))
        .catchError((e) => print(e));

    for (int i = 0; i < list.length; i++) {
      DocumentReference documentReferencer = _mainCollection
          .doc(userUid)
          .collection('items')
          .doc(docIdAdd)
          .collection('participation')
          .doc();

      Map<String, dynamic> data = <String, dynamic>{
        "role": "Invité",
        "statutEntree": false,
        "timestamp": DateTime.now(),
        "email": list[i],
      };

      await documentReferencer
          .set(data)
          .whenComplete(() => print("Add Invité[" +
              i.toString() +
              "] avec id: " +
              documentReferencer.id))
          .catchError((e) => print(e));

      syncItems(
          email: list[i],
          title: nameSave!,
          description: descSave!,
          address: addrSave!,
          start: startSave!,
          end: endSave!,
          role: "Invité");
      await _mainCollection
          .doc(list[i])
          .collection('items')
          .doc(docIdAdd)
          .collection('participation')
          .doc(documentReferencer.id)
          .set(data)
          .whenComplete(() => print("Add this event into email : " +
              list[i] +
              " with id: " +
              documentReferencer.id))
          .catchError((e) => print(e));
    }
  }

  //return id of an event for the QRCode => create QRCode with the id client in the list of invite
  static Stream<QuerySnapshot> readListInvite(String docID) {
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection("items")
        .doc(docID)
        .collection("participation")
        .where("email", isEqualTo: userUid);
    return notesItemCollection.snapshots();
  }

  static Future<void> syncItems({
    required String email,
    required String title,
    required String description,
    required String address,
    required DateTime start,
    required DateTime end,
    required String role,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(email).collection('items').doc(docIdAdd);

    Map<String, dynamic> data = <String, dynamic>{
      "tittre": title,
      "description": description,
      "adresse": address,
      "dateDebut": start,
      "dateEnd": end,
      "role": role,
      "isDelete": isDel,
    };
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Account added to the database: " + email))
        .catchError((e) => print("Error " + e));
  }

  //static late List<String> listID = [];

  static void fetchDataID() async {
    var dataID = await FirebaseFirestore.instance
        .collection('evenements')
        .doc(userUid)
        .collection('items')
        .get();
    for (int i = 0; i < dataID.docs.length; i++) {
      //listID.add(dataID.docs[i].id);
      var data = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(userUid)
          .collection('items')
          .doc(dataID.docs[i].id)
          .collection('participation')
          .get();
      for (int j = 0; j < data.docs.length; j++) {
        if (data.docs[j].data()['email'] == userUid) {
          listRole.add(data.docs[j].data()['role']);
        }
      }
    }
    //print("length : " + listID.length.toString() + " " + listID.toString());
    print("length : " + listRole.length.toString() + " " + listRole.toString());
  }
}