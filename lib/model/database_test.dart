import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class DatabaseTest {
  //définir le nom de personne qui se connecte
  static String userUid = "test14@gmail.com";
  //des variables pour les sauvegarder dans la BDD (les mettre en variable pour les déplacer étape par étape)
  static String? docIdAdd; //renvoyer ID d'un event spécifique
  static String? addrSave; //Adresses
  static String? nameSave; //titre
  static String? descSave; //description
  static DateTime? startSave; //date commencé
  static DateTime? endSave; //date fin

  static String searchSave = ""; //pour la barre de recherche
  //pour savoir si cet events est supprimé ou pas
  static bool isDel = false;
  //pour filtrer entre des roles
  static bool isOrgan = false;
  static bool isInvite = false;
  static bool isScan = false;
  //pour cette fonction fetchID => ne pas utiliser
  static List<String>? listInvite; // pas besoin pour l'instant
  static List<String> listRole = [];// pas besoin pour l'instant

  //pour save d'un nom de chaque groupe
  static List<String> listNameGroup = [];


  /*static Map<String, dynamic> map =  _mainCollection.doc(userUid).collection('items').doc().collection('participation') as Map<String, dynamic>;
  static List<String> listRole = map['email'];*/

  //pour ajouter un events dans la BDD avec des attributs
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
      "isDelete": isDel,
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

  //pour modifier un events
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
      "isDelete": isDel
    };

    await documentReferencer
        .update(data)
        .whenComplete(
            () => print("Event of this account updated in the database"))
        .catchError((e) => print(e));
  }

  //pour récupérer tous les events dans la BDD et les metrre dans un listview
  static Stream<QuerySnapshot> readItems() {
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection("items")
        .orderBy("dateDebut", descending: true);
    //_mainCollection.doc("test@gmail.com").collection('items');

    return notesItemCollection.snapshots();
  }

  ////pour récupérer tous les events dans la BDD mais trier par "role"
  static Stream<QuerySnapshot> readRoles(
      bool _isOrganisateur, bool _isInviteur, bool _isScanneur) {
    /*  print("or : " +
        isOrgan.toString() +
        " invi : " +
        isInvite.toString()+ " name : " + searchSave);*/
    Query<Map<String, dynamic>> notesItemCollection =
        _mainCollection.doc(userUid).collection("items");
    //.orderBy("dateDebut", descending: true);
    //Filtrer par Organisateur
    if (_isOrganisateur && !_isInviteur) {
      return notesItemCollection
          .where("role", isEqualTo: "Organisateur")
          .orderBy("dateDebut", descending: false)
          .snapshots();
    }
    //Filtrer par Invité
    else if (!_isOrganisateur && _isInviteur) {
      return notesItemCollection
          .where("role", isEqualTo: "Invité")
          .orderBy("dateDebut", descending: false)
          .snapshots();
    }
    //Faire la recherche par le nom de titre
    else if (searchSave.isNotEmpty) {
      return notesItemCollection
          .where("tittre",
              isGreaterThanOrEqualTo: searchSave, isLessThan: searchSave + 'z')
          /*.startAt([searchSave]).endAt([searchSave + '\uf8ff'])*/
          .orderBy("tittre", descending: true)
          .orderBy("dateDebut", descending: false)
          .snapshots();
    }
    //Revoyer toutes les infos dans la BDD
    else {
      return notesItemCollection
          /*.where("tittre",
          isGreaterThanOrEqualTo: searchSave,
          isLessThan: searchSave + 'z')
          .orderBy("tittre", descending: true)*/
          .orderBy("dateDebut", descending: false)
          .snapshots();
    }
  }

  static Stream<QuerySnapshot> readEmails() {
    Query<Map<String, dynamic>> itemsEmailCollection =
        _mainCollection.doc(userUid).collection("emails");
    //_mainCollection.doc("test@gmail.com").collection('items');

    return itemsEmailCollection.snapshots();
  }

  //pour effacer un events
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
      /*var update = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(data.docs[j].data()['email'])
          .collection('items')
          .get();*/
      await _mainCollection
          .doc(data.docs[j].data()['email'])
          .collection('items')
          .doc(docId).update({"isDelete" : false}).whenComplete(
              () => print("Event of this account :" + data.docs[j].data()['email']+   "has been updated in the database"))
          .catchError((e) => print(e));

      /*updateAttribute(
          email: data.docs[j].data()['email'],
          docId: docId);*/
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
    required List<String> listEmail,
    required List<String> listGroup,
  }) async {
    //Step 1: add host to the list of invite
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
      "group" : "HOST"
    };

    await documentReferencer
        .set(data)
        .whenComplete(
            () => print("Add Organisateur : id " + documentReferencer.id))
        .catchError((e) => print(e));

    //Step 2: Save the list into database
    for (int i = 0; i < listEmail.length; i++) {
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
        "email": listEmail[i],
        "group" : listGroup[i]
      };

      await documentReferencer
          .set(data)
          .whenComplete(() => print("Add Invité[" +
              i.toString() +
              "] avec id: " +
              documentReferencer.id))
          .catchError((e) => print(e));
      //Step 3: in the same time, create an event with each of email in the list
      syncItems(
          email: listEmail[i],
          title: nameSave!,
          description: descSave!,
          address: addrSave!,
          start: startSave!,
          end: endSave!,
          role: "Invité");
      //Step 4: in this event of this client, creat too an email in the collection "participation" for the content of QRCode
      await _mainCollection
          .doc(listEmail[i])
          .collection('items')
          .doc(docIdAdd)
          .collection('participation')
          .doc(documentReferencer.id)
          .set(data)
          .whenComplete(() => print("Add this event into email : " +
          listEmail[i] +
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

  //essayer d'ajouter en meme temps un events pour tous les personnes qui ont été invitées par organisateur => synchroniser
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
  //cette methode n'a pas besoin d'utiliser
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

  //create
  static List<int> listNbRole = [0,0,0];

  static void fetchNBRole() async {
    int nbOgani = 0;
    int nbInv = 0;
    int nbScan = 0;
    var dataID = await FirebaseFirestore.instance
        .collection('evenements')
        .doc(userUid)
        .collection('items')
        .get();
    for (int i = 0; i < dataID.docs.length; i++) {
      if (dataID.docs[i].data()['role'] == "Organisateur") {
        nbOgani++;
      } else if (dataID.docs[i].data()['role'] == "Invité") {
        nbInv++;
      } else
        nbScan++;
    }

    //print("length : " + listID.length.toString() + " " + listID.toString());
    print("O : " +
        nbOgani.toString() +
        " I : " +
        nbInv.toString() +
        " S : " +
        nbScan.toString());
    listNbRole[0] = nbOgani;
    listNbRole[1] = nbInv;
    listNbRole[2] = nbScan;
  }

  //check status de QRCode
  static bool status = false;
  static String emailClient = "";
  //fonction pour verifier le status du client
  static void fetchDataCheck(String idParticipation,String contentQRCode) async {
    var dataID = await FirebaseFirestore.instance
        .collection('evenements')
        .doc(userUid)
        .collection('items')
        .doc(idParticipation)
        .collection('participation')
        .get();
    for (int i = 0; i < dataID.docs.length; i++) {
      if (contentQRCode.compareTo(dataID.docs[i].id) == 0) {
        status = true;
        emailClient = dataID.docs[i].data()['email'];
      }
      else
        status = false;
      }
    }
}
