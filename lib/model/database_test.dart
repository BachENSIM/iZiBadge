import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class DatabaseTest {
  //définir le nom de personne qui se connecte
  //static String userUid = "test14@gmail.com";
  static String userUid = "ensim@univ-lemans.fr";
  //static String userUid = "example5@gmail.com";

  /*---------------------------------------*/
  //variable globale pour changer la BDD
  static String nameDB = "evenements"; //nom de bdd
  static String eventRelated = "items"; //nom de la premiere collection
  static String participants = "participation"; //nom de la 2eme collection
  static String participantsGr =
      "groupe"; //nom de la collection qui sauvegarde les groupes dans un event
  static String listOfGroup =
      "listeGroupe"; //nom du document concernant Groupe de la collection "groupe"
  static String listOfHours =
      "listeHeure"; //nom du document concernant Heure de la collection "groupe"
  /*---------------------------------------*/
  //des variables pour les sauvegarder dans la BDD (les mettre en variable pour les déplacer étape par étape)
  static String? docIdAdd; //renvoyer ID d'un event spécifique
  static String? addrSave; //Adresses
  static String? nameSave; //titre
  static String? descSave; //description
  static DateTime? startSave; //date début
  static DateTime? endSave; //date fin
  static TimeOfDay? timeStartSave; //heure début
  static TimeOfDay? timeEndSave; //heure fin
  /*---------------------------------------*/
  static String searchSave = ""; //pour la barre de recherche
  //pour savoir si cet events est supprimé ou pas
  static bool isDel = false;

  /*---------------------------------------*/
  //pour filtrer entre des roles
  static bool isOrgan = false;
  static bool isInvite = false;
  static bool isScan = false;

  /*---------------------------------------*/
  //pour cette fonction fetchID => ne pas utiliser
  static List<String>? listInvite; // pas besoin pour l'instant
  static List<String> listRole = []; // pas besoin pour l'instant
  /*---------------------------------------*/
  //pour save d'un nom de chaque groupe - heure début & fin
  static List<String> listNameGroup = [];
  static List<DateTime> listHoursStart = [];
  static List<DateTime> listHoursEnd = [];

  /*static Map<String, dynamic> map =  _mainCollection.doc(userUid).collection(eventRelated).doc().collection(participants) as Map<String, dynamic>;
  static List<String> listRole = map['email'];*/
  /*---------------------------------------*/
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
        _mainCollection.doc(userUid).collection(eventRelated).doc();
    //_mainCollection.doc("test@gmail.com").collection(eventRelated).doc();

    Map<String, dynamic> data = <String, dynamic>{
      "titre": title,
      "description": description,
      "adresse": address,
      "dateDebut": start,
      "dateEnd": end,
      "role": role,
      "isEfface": isDel,
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

  /*---------------------------------------*/
  //pour modifier un events
  //faut aussi synchroniser tous les personnes
  static Future<void> updateItem({
    required String title,
    required String description,
    required String address,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection(eventRelated).doc(docId);
    //_mainCollection.doc("test@gmail.com").collection(eventRelated).doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "titre": title,
      "description": description,
      "adresse": address,
      "isEfface": isDel
    };

    await documentReferencer
        .update(data)
        .whenComplete(
            () => debugPrint("DB changed $userUid"))
        .catchError((e) => debugPrint(e));
    //récupérer la liste d'invitation
    var dataSync = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    for (var i = 0; i < dataSync.size; i++) {
      String email = dataSync.docs[i].data()['email'];
      await _mainCollection
          .doc(email)
          .collection(eventRelated)
          .doc(docId)
          .update(data)
          .whenComplete(() => debugPrint(
          "DB changed $email"))
          .catchError((e) => debugPrint(e));
    }

  }

  /*---------------------------------------*/
  //pour récupérer tous les events dans la BDD et les metrre dans un listview
  static Stream<QuerySnapshot> readItems() {
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .orderBy("dateDebut", descending: true);
    //_mainCollection.doc("test@gmail.com").collection(eventRelated);

    return notesItemCollection.snapshots();
  }

  /*---------------------------------------*/
  //pour récupérer tous les events dans la BDD mais trier par "role"
  static Stream<QuerySnapshot> readRoles(
      bool _isOrganisateur, bool _isInviteur, bool _isScanneur) {
    Query<Map<String, dynamic>> notesItemCollection =
        _mainCollection.doc(userUid).collection(eventRelated);
    //.orderBy("dateDebut", descending: true);
    //Filtrer par Organisateur
    if (_isOrganisateur && !_isInviteur && !_isScanneur) {
      return notesItemCollection
          .where("role", isEqualTo: "Organisateur")
          .orderBy("dateDebut", descending: true)
          .snapshots();
    }
    //Filtrer par Invité
    else if (!_isOrganisateur && _isInviteur && !_isScanneur) {
      return notesItemCollection
          .where("role", isEqualTo: "Invité")
          .orderBy("dateDebut", descending: true)
          .snapshots();
    } else if (!_isOrganisateur && !_isInviteur && _isScanneur) {
      return notesItemCollection
          .where("role", isEqualTo: "Scanneur")
          .orderBy("dateDebut", descending: true)
          .snapshots();
    }
    //Faire la recherche par le nom de titre
    else if (searchSave.isNotEmpty) {
      return notesItemCollection
          .where("titre",
              /* isGreaterThanOrEqualTo: searchSave, isLessThan: searchSave+ 'z')*/
              //Same as below
              isGreaterThanOrEqualTo: searchSave,
              isLessThan: searchSave.substring(0, searchSave.length - 1) +
                  String.fromCharCode(
                      searchSave.codeUnitAt(searchSave.length - 1) + 1))
          //.startAt([searchSave]).endAt([searchSave + '\uf8ff'])
          .orderBy("titre", descending: true)
          .orderBy("dateDebut", descending: false)
          .snapshots();
    }
    //Revoyer toutes les infos dans la BDD
    else {
      return notesItemCollection
          /*.where("titre",
          isGreaterThanOrEqualTo: searchSave,
          isLessThan: searchSave + 'z')
          .orderBy("titre", descending: true)*/
          .orderBy("dateDebut", descending: true)
          .snapshots();
    }
  }

  /*---------------------------------------*/
  static Stream<QuerySnapshot> readEmails() {
    Query<Map<String, dynamic>> itemsEmailCollection =
        _mainCollection.doc(userUid).collection("emails");
    //_mainCollection.doc("test@gmail.com").collection(eventRelated);

    return itemsEmailCollection.snapshots();
  }

  /*---------------------------------------*/
  //pour effacer un events
  static Future<void> deleteItem({
    required String docId,
  }) async {
    //Step 1: need to update another events - put an attribute isDel = true to know this event has been deleted (synchronization)
    var data = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    isDel = true;
    for (int j = 0; j < data.docs.length; j++) {
      /*DocumentReference documentReferencer = _mainCollection
          .doc()
          .collection(eventRelated)
          .doc(docId);*/
      /*var update = await FirebaseFirestore.instance
          .collection('evenements')
          .doc(data.docs[j].data()['email'])
          .collection(eventRelated)
          .get();*/
      await _mainCollection
          .doc(data.docs[j].data()['email'])
          .collection(eventRelated)
          .doc(docId)
          .update({"isEfface": true})
          .whenComplete(() => print("Event of this account :" +
              data.docs[j].data()['email'] +
              "has been updated in the database"))
          .catchError((e) => print(e));
    }
    //Step 2 : delete list of user (participation) of this event
    final documentRefList = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    await documentRefList.then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));
    //Step 2bis : delete list of group (participation) of this event (list of group and list of time)
    final documentRefGroup = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participantsGr)
        .get();
    await documentRefGroup.then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));

    //Step 3 : delete this event from DB
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection(eventRelated).doc(docId);
    //_mainCollection.doc("test@gmail.com").collection(eventRelated).doc(docId);
    await documentReferencer
        .delete()
        .whenComplete(() => print('Event with id ' +
            docId +
            ' have been deleted from the database!!!'))
        .catchError((e) => print(e));
    isDel = false;
  }

  /*---------------------------------------*/
  //pour effacer un events quand cet event est supprimé par l'organisateur => l'inviteur n'a pas envie de garder
  static Future<void> deleteItemCanceled({
    required String docId,
  }) async {
    //Step 2 : delete list of user (participation) of this event
    final documentRefList = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    await documentRefList.then((value) => value.docs.forEach((element) {
          element.reference.delete();
        }));

    //Step 3 : delete this event from DB
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection(eventRelated).doc(docId);
    //_mainCollection.doc("test@gmail.com").collection(eventRelated).doc(docId);
    await documentReferencer
        .delete()
        .whenComplete(() => print('Event with id ' +
            docId +
            ' have been deleted from the database!!!'))
        .catchError((e) => print(e));
  }

  /*---------------------------------------*/
  //how to add a list of mail into firebase in the same event
  static Future<void> addInviteList({
    required List<String> listEmail,
    required List<String> listGroup,
    required List<String> listRole,
  }) async {
    //Step 1: add host to the list of invite
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docIdAdd)
        .collection(participants)
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      "role": "Organisateur",
      "statutEntree": true,
      "timestamp": DateTime.now(),
      "email": userUid,
      "group": "HOST",
      "nbEntree": 1
    };

    await documentReferencer
        .set(data)
        .whenComplete(
            () => print("Add Organisateur : id " + documentReferencer.id))
        .catchError((e) => print(e));
    //sauvegarder docID de HOST
    String idHOST = documentReferencer.id;
    //Step 2bis: Need to also save the list of group for modify after
    DocumentReference documentRefGr = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docIdAdd)
        .collection(participantsGr)
        .doc(listOfGroup);
    //utiliser hashmap pour éviter les duplicatas (dans le cas l'utilisateur choisit un groupe pour une personne, sinon la liste de groupe est vide)
    /*HashMap<String, int> hashMapGr = HashMap<String, int>();
    for (int i = 0; i < listGroup.length; i++) {
      hashMapGr.putIfAbsent(listGroup[i], () => i);
    }*/
    /*print(hashMapGr.toString());
    print(hashMapGr.keys.toList(growable: false));*/
    Map<String, dynamic> dataGr = <String, dynamic>{
      //"nomListeGroupe": hashMapGr.keys.toList(growable: false)
      "nomListeGroupe": listNameGroup
    };
    await documentRefGr
        .set(dataGr)
        .whenComplete(() => print("Updated group for event $docIdAdd"))
        .catchError((e) => print(e));

    //Step 2bisbis: one list for saving hours of entering and another list for exiting
    await addListeOfTimes(lstStart: listHoursStart, lstEnd: listHoursEnd);

    //Step 2: Save the list into database
    List<String> listOfID = [];
    List<String> listOfRoleScan = [];

    for (int i = 0; i < listEmail.length; i++) {
      //Save en tant qu'organisateur/
      DocumentReference documentReferencer = _mainCollection
          .doc(userUid)
          .collection(eventRelated)
          .doc(docIdAdd)
          .collection(participants)
          .doc();

      Map<String, dynamic> data = <String, dynamic>{
        "role": listRole[i],
        "statutEntree": false,
        "timestamp": DateTime.now(),
        "email": listEmail[i],
        "group": listGroup[i],
        "nbEntree": 0
      };

      await documentReferencer
          .set(data)
          .whenComplete(() => print("Add Invité[" +
              i.toString() +
              "] avec id: " +
              documentReferencer.id))
          .catchError((e) => print(e));

      //syncItemsOfInvitation(email: listEmail[i], role: listRole[i], emailUid: userUid, docID: docIdAdd!, group: listGroup[i]);

      //Step 3: At the same time, create an event with each email in the list (but need to verify the time of this person on this group)
      //return index of this group in the list of group
      int position = listNameGroup.indexOf(listGroup[i]);
      //with this position, i can have access to the date list and return the date/time corresponding to this person
      syncItems(
          email: listEmail[i],
          title: nameSave!,
          description: descSave!,
          address: addrSave!,
          start: listHoursStart[position],
          end: listHoursEnd[position],
          role: listRole[i], id: docIdAdd!);

      //Step 4: in this event of this client, create too an email in the collection "participation" for the content of QRCode (just for clients not scanners)
      if (listRole[i].compareTo("Invité") == 0) {
        await _mainCollection
            .doc(listEmail[i])
            .collection(eventRelated)
            .doc(docIdAdd)
            .collection(participants)
            .doc(documentReferencer.id)
            .set(data)
            .whenComplete(() => print("Add this event into email : " +
                listEmail[i] +
                " with id: " +
                documentReferencer.id))
            .catchError((e) => print(e));
      } else {
        listOfRoleScan.add(listEmail[i]); //combien de scanneur
        debugPrint(listEmail[i]);
      }
      //avoir une autre list pour sauvegarder les ID pour qu'on puisse mettre à jour les scanneurs
      listOfID.add(documentReferencer.id);
    }
    //Step 5: Le scanneur va synchroniser la liste pour qu'il puisse avoir BDD
    for (int j = 0; j < listOfRoleScan.length; j++) {
      for (int i = 0; i < listOfID.length; i++) {
        Map<String, dynamic> data = <String, dynamic>{
          "role": listRole[i],
          "statutEntree": false,
          "timestamp": DateTime.now(),
          "email": listEmail[i],
          "group": listGroup[i],
          "nbEntree": 0
        };
        await _mainCollection
            .doc(listOfRoleScan[j])
            .collection(eventRelated)
            .doc(docIdAdd)
            .collection(participants)
            .doc(listOfID[i])
            .set(data)
            .whenComplete(
                () => debugPrint("${listOfRoleScan[j]} update ${listEmail[i]}"))
            .catchError((e) => debugPrint(e));
      }
      Map<String, dynamic> data = <String, dynamic>{
        "role": "Organisateur",
        "statutEntree": true,
        "timestamp": DateTime.now(),
        "email": userUid,
        "group": "HOST",
        "nbEntree": 1
      };
      await  _mainCollection
          .doc(listOfRoleScan[j])
          .collection(eventRelated)
          .doc(docIdAdd)
          .collection(participants)
          .doc(idHOST)
          .set(data)
          .whenComplete(
              () => debugPrint("${listOfRoleScan[j]} update $userUid"))
          .catchError((e) => debugPrint(e));
    }
  }

  /*---------------------------------------*/
  //chaque groupe qui possède les heure rentrées et sorties différente
  //les mettre dans une litste et sauvegarder sur BDD dans une collection s'appelant "listeHeure"
  static Future<void> addListeOfTimes({
    required List<DateTime> lstStart,
    required List<DateTime> lstEnd,
  }) async {
    DocumentReference documentRefGr = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docIdAdd)
        .collection(participantsGr)
        .doc(listOfHours);
    /*Map<String, dynamic> dataStart = <String, dynamic>{
      "listeHeureCommencee": lstStart
    };
    Map<String, dynamic> dataEnd = <String, dynamic>{
      "listeHeureTerminee": lstEnd
    };*/
    Map<String, dynamic> data = <String, dynamic>{
      "listeHeureCommencee": lstStart,
      "listeHeureTerminee": lstEnd
    };
    await documentRefGr
        .set(data)
        .whenComplete(() => print("Updated group for event $docIdAdd"))
        .catchError((e) => print(e));
  }

  /*---------------------------------------*/
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

  /*---------------------------------------*/
  static Future<void> syncItemsOfInvitation({
    required String email,
    required String emailUid,
    required String role,
    required String group,
    required String docID,
  }) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(emailUid)
        .collection(eventRelated)
        .doc(docID)
        .collection(participants)
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      "role": role,
      "statutEntree": false,
      "timestamp": DateTime.now(),
      "email": email,
      "group": group
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Add ${documentReferencer.id}"))
        .catchError((e) => print(e));
  }

  /*---------------------------------------*/
  //essayer d'ajouter en meme temps un events pour tous les personnes qui ont été invitées par organisateur => synchroniser
  static Future<void> syncItems({
    required String email,
    required String title,
    required String description,
    required String address,
    required DateTime start,
    required DateTime end,
    required String role,
    required String id,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(email).collection(eventRelated).doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "titre": title,
      "description": description,
      "adresse": address,
      "dateDebut": start,
      "dateEnd": end,
      "role": role,
      "isEfface": false,
    };
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Account added to the database: " + email))
        .catchError((e) => print("Error " + e));
  }

  /*---------------------------------------*/
  //static late List<String> listID = [];
  //cette methode n'a pas besoin d'utiliser
  static void fetchDataID() async {
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .get();
    for (int i = 0; i < dataID.docs.length; i++) {
      //listID.add(dataID.docs[i].id);
      var data = await FirebaseFirestore.instance
          .collection(nameDB)
          .doc(userUid)
          .collection(eventRelated)
          .doc(dataID.docs[i].id)
          .collection(participants)
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

  /*---------------------------------------*/
  //create
  static List<int> listNbRole = [0, 0, 0];

  static void fetchNBRole() async {
    int nbOgani = 0;
    int nbInv = 0;
    int nbScan = 0;
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
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
  /*---------------------------------------*/
  //une méthode pour voir la liste d'invitation de cet événement
  //toujours la même liste d'invitation (avec l'email d'organisateur et l'email de scanneur)
  //2 HashMap pour stocker email - status - nbEntrer (putIfAbsent qui ne respecte pas l'ordre dans la BDD)
  static HashMap<String, bool> lstInviteChecked = HashMap<String, bool>();
  static HashMap<String, int> lstSizeInvite = HashMap<String, int>();

  //static List<int> lstSizeInvite = [];

  static Future<void> fetchListInvite({
    required String docId,
  }) async {
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .orderBy("email", descending: true)
        .get();
    int sizeList = dataID.docs.length;
    if (lstInviteChecked.isNotEmpty) lstInviteChecked.clear();
    if (lstSizeInvite.isNotEmpty) lstSizeInvite.clear();
    //méthode pour remplir une liste avec les données par défault
    //lstSizeInvite = List.generate(sizeList, (index) => 0);
    //lstSizeInvite = List.filled (sizeList, 0,growable: false);
    for (int i = 0; i < sizeList; i++) {
      String role = dataID.docs[i].data()['role'];
      String key = "";
      role.contains("Organisateur") ?
        key = dataID.docs[i].data()['email'] + " (HOST)" :
        role.contains("Scanneur") ?
        key = dataID.docs[i].data()['email'] + " (Scanneur)" :
        key = dataID.docs[i].data()['email'];

      bool value = dataID.docs[i].data()['statutEntree'];
      int nbTimeEnter = dataID.docs[i].data()['nbEntree'];
      lstInviteChecked.putIfAbsent(key, () => value);
      lstSizeInvite.putIfAbsent(key, () => nbTimeEnter);
      /* if (!key.contains(userUid) || !role.contains("Organisateur")) {
        lstInviteChecked.putIfAbsent(key, () => value);
        lstSizeInvite.putIfAbsent(key, () => nbTimeEnter);
        //debugPrint("message : $key $nbTimeEnter");
      }*/
    }
  }

  /*---------------------------------------*/
  //check status de QRCode
  //il faut aussi mettre à jour  dans la BDD de les scanneurs (entre organisateur et scanneur/ scanneur entre scanneur)
  static Future<bool> status = Future<bool>.value(false);
  static late int nbPersonTotal = 0; //nb total de personne dans un events
  static late int countPersonEnter = 0; //compter cb de persons qui rentre
  static int countPersonScanned = 0; //compter cb de fois qu'il rentre
  static String emailClient = "";

  //un HashMap stocke nom personne comme clef et nb de fois qu'il rentre comme value
  static HashMap lstPersonScanned = HashMap<String, int>();

  //fonction pour verifier le status du client
  static Future<bool> fetchDataCheck(
      String idParticipation, String contentQRCode) async {
    //lstPersonEnter = HashMap<String,bool>();
    //lstPersonScanned = HashMap<String,int>();

    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participants)
        .get();
    nbPersonTotal = dataID.docs.length - 1;
    countPersonEnter = 1;
    for (int i = 0; i < dataID.docs.length; i++) {
      String idClient = dataID.docs[i].id;
      if (contentQRCode.compareTo(idClient) == 0) {
        debugPrint(" content: $contentQRCode data true $i $idClient");
        status = Future<bool>.value(true);
        emailClient = dataID.docs[i].data()['email'];
        //countPersonScanned++;
        if (!lstPersonScanned.containsKey(contentQRCode)) {
          lstPersonScanned.putIfAbsent(contentQRCode,
              () => 1); //ajouter une valeur dans la table de Hachage
          //mettre à jour le statut d'entrée d'une personne = true
          await _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(idParticipation)
              .collection(participants)
              .doc(idClient)
              .update({
                "statutEntree": true,
                "timestamp": DateTime.now(),
                "nbEntree": lstPersonScanned[contentQRCode]
              })
              .whenComplete(() =>
                  debugPrint("Updated email: $emailClient with status: true"))
              .catchError((e) => debugPrint(e));
          //countPersonEnter++;
        } else {
          countPersonEnter = ++lstPersonScanned[contentQRCode];
          //mettre à jour une valeur dans la liste
          lstPersonScanned.update(contentQRCode, (value) => countPersonEnter);
          await _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(idParticipation)
              .collection(participants)
              .doc(idClient)
              .update({"nbEntree": countPersonEnter})
              .whenComplete(() => debugPrint(
                  "Updated email: $emailClient with nbEntrée: $countPersonEnter"))
              .catchError((e) => print(e));
        }
        debugPrint("email after $emailClient ....");
        //emailClient = "";

        break;
      } else {
        debugPrint(" content: $contentQRCode data false $i $idClient");
        //status = Future<bool>.value(false);
      }
    }
    return status;
  }
  //récupérer les données dans la BDD, les comparer et les mettre un HashMap pour afficher sur écran
  static Future<bool> fetchDataCheckUpdateDB(
      String idParticipation, String contentQRCode) async {
    //lstPersonEnter = HashMap<String,bool>();
    //lstPersonScanned = HashMap<String,int>();
    HashMap<String,int> hashMapNbEnter = HashMap<String, int>();
    List<String> lstEmailClient = [];
    var dataNbEnter = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participants)
        .get();
    for (int i = 0; i < dataNbEnter.docs.length; i++) {
      String key = dataNbEnter.docs[i].id;
      int value = dataNbEnter.docs[i].data()['nbEntree'];
      String email = dataNbEnter.docs[i].data()['email'];
      String role = dataNbEnter.docs[i].data()['role'];
      hashMapNbEnter.putIfAbsent(key, () => value);
      if(!email.contains(userUid) && (role.contains("Organisateur") || role.contains("Scanneur"))) lstEmailClient.add(email);
    }
    debugPrint(lstEmailClient.toString());
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participants)
        .get();
    nbPersonTotal = dataID.docs.length - 1;
    countPersonEnter = 1;
    for (int i = 0; i < dataID.docs.length; i++) {
      String idClient = dataID.docs[i].id;
      String role = dataID.docs[i].data()['role'];
      if (contentQRCode.compareTo(idClient) == 0) {
        //debugPrint(" content: $contentQRCode data true $i $idClient");
        status = Future<bool>.value(true);
        emailClient = dataID.docs[i].data()['email'];
        //countPersonScanned++;
        if (!lstPersonScanned.containsKey(contentQRCode)) {
          countPersonEnter = hashMapNbEnter[contentQRCode]!+1;
          lstPersonScanned.putIfAbsent(contentQRCode,
                  () => countPersonEnter); //ajouter une valeur dans la table de Hachage
          //mettre à jour le statut d'entrée d'une personne = true
          debugPrint("NB " + lstPersonScanned[contentQRCode].toString());

          await _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(idParticipation)
              .collection(participants)
              .doc(idClient)
              .update({
            "statutEntree": true,
            "timestamp": DateTime.now(),
            "nbEntree": lstPersonScanned[contentQRCode]
          })
              .whenComplete(() =>
              debugPrint("$userUid Updated: $emailClient status: true"))
              .catchError((e) => debugPrint(e));

          for (int j = 0; j <lstEmailClient.length;j++) {
             _mainCollection
                .doc(lstEmailClient[j])
                .collection(eventRelated)
                .doc(idParticipation)
                .collection(participants)
                .doc(idClient)
                .update({
                "statutEntree": true,
                "timestamp": DateTime.now(),
                "nbEntree": lstPersonScanned[contentQRCode] })
                .whenComplete(() =>
                debugPrint("${lstEmailClient[j]} Updated $emailClient status: true"))
                .catchError((e) => debugPrint(e));
          }

          //countPersonEnter++;
        }
        else {
          countPersonEnter = hashMapNbEnter[contentQRCode]! + 1;
          //mettre à jour une valeur dans la liste
          lstPersonScanned.update(contentQRCode, (value) => countPersonEnter);
           _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(idParticipation)
              .collection(participants)
              .doc(idClient)
              .update({"nbEntree": countPersonEnter});
              /*.whenComplete(() => debugPrint(
              "$userUid Updated: $emailClient nbEntrée: $countPersonEnter"))
              .catchError((e) => debugPrint(e));*/

          for (int j = 0; j <lstEmailClient.length;j++) {
             _mainCollection
                .doc(lstEmailClient[j])
                .collection(eventRelated)
                .doc(idParticipation)
                .collection(participants)
                .doc(idClient)
                .update({"nbEntree": countPersonEnter});
                /*.whenComplete(() => debugPrint(
                "${lstEmailClient[j]} Updated: $emailClient nbEntrée: $countPersonEnter"))
                .catchError((e) => debugPrint(e));*/
          }
        }
        //debugPrint("email after $emailClient ....");
        //emailClient = "";
        break;
      } else {
        //debugPrint(" content: $contentQRCode data false $i $idClient");
        //status = Future<bool>.value(false);
      }
    }
    return status;
  }
  /*---------------------------------------*/
  //avoir besoins de sauvegarder touts les groupes sur BDD pour
  //mettre à jour partout dans la BDD (si changer le nom de groupe, faut comparer avec la liste ancienne,..)
  static HashMap<String,String> hashMapGrChanged = HashMap<String,String>();
  static Future<void> updateGroup(
      {required String docId,
      required List<String> lstGroupUpdate,
      required List<DateTime> lstDateStart,
      required List<DateTime> lstDateEnd}) async {

    //récupérer les données avant de modifier
    var dataNameGr = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    HashMap<String,String> hmGrUpdated = HashMap<String,String>();
    //List<String> lstId = [];
    for (int i = 0; i < dataNameGr.docs.length;i++) {
      String group = dataNameGr.docs[i].data()['group'];
      String id = dataNameGr.docs[i].id;
      hmGrUpdated.putIfAbsent(id,() => group);
    }
    hashMapGrChanged.keys.toList().forEach((element) {
      hmGrUpdated.updateAll((key, value) => value.replaceAll(element, hashMapGrChanged[element]!));
    });
    debugPrint("updated : " + hmGrUpdated.values.toList().toString());
    //changer le nom de group correspondant avec nom modifié
    for(int i = 0;i < hmGrUpdated.length;i++ ) {
      String name = hmGrUpdated.values.toList().elementAt(i);
      String id = hmGrUpdated.keys.toList().elementAt(i);
      Map<String, dynamic> updateNameGr = <String, dynamic>{
        "group": name
      };
      DocumentReference updatedGr = _mainCollection
          .doc(userUid)
          .collection(eventRelated)
          .doc(docId)
          .collection(participants)
          .doc(id);

      await updatedGr
          .update(updateNameGr)
          .whenComplete(() => debugPrint("Updated $name"))
          .catchError((e) => debugPrint(e));
    }
    //faut changer aussi l'heure affiché sur la page d'acceuil
    var dataEmail = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    //un HashMap pour stocker email avec un group
    HashMap<String,String> hmEmailUpdated = HashMap<String,String>();
    for (int i = 0; i < dataEmail.docs.length;i++) {
      String group = dataEmail.docs[i].data()['group'];
      String email = dataEmail.docs[i].data()['email'];
      hmEmailUpdated.putIfAbsent(email,() => group);
    }
    for(int i = 0;i < hmEmailUpdated.length;i++ ) {
      String group = hmEmailUpdated.values.toList().elementAt(i);
      String email = hmEmailUpdated.keys.toList().elementAt(i);
      Map<String, dynamic> updateTimeChanged = <String, dynamic>{
        "dateDebut": lstDateStart[i],
        "dateEnd": lstDateEnd[i]
      };
      DocumentReference updatedTime = _mainCollection
          .doc(email)
          .collection(eventRelated)
          .doc(docId);

      await updatedTime
          .update(updateTimeChanged)
          .whenComplete(() => debugPrint("Updated $email"))
          .catchError((e) => debugPrint(e));
    }

    //mettre à jour la liste de groupe
      DocumentReference documentGroup = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participantsGr)
        .doc(listOfGroup);

    Map<String, dynamic> dataGr = <String, dynamic>{
      "nomListeGroupe": lstGroupUpdate
    };

    await documentGroup
        .update(dataGr)
        .whenComplete(() => debugPrint("Updated group for event $docId"))
        .catchError((e) => debugPrint(e));

    //mettre à jour la liste de date commencé/terminé
    DocumentReference documentDate = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participantsGr)
        .doc(listOfHours);

    Map<String, dynamic> dataDate = <String, dynamic>{
      "listeHeureCommencee": lstDateStart,
      "listeHeureTerminee": lstDateEnd
    };

    await documentDate
        .update(dataDate)
        .whenComplete(() => debugPrint("Updated time for event $docId"))
        .catchError((e) => debugPrint(e));


  }

  /*---------------------------------------*/
  //pour récupérer tous les groupes dans la BDD
  // pour voir les groupes sauvegardées dans la BDD
  static List<String> lstGrAdded = [];

  //les 2 autres listes pour consulter les dates débuts et fins
  static List<DateTime> lstDateStartAdded = [];
  static List<DateTime> lstDateEndAdded = [];

  //méthode pour récupérer les groupes dans la liste d'invitation
  /*static void fetchGroupAdded(String idParticipation) async{
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participants)
        .get();
    late String nameGr;//nom de groupe
    late String idPers;//id de cette personne qui possède ce nom au-dessus
    late HashMap lstGr = HashMap<String,String>();

    for (int i = 0; i < dataID.docs.length; i++) {
      nameGr = dataID.docs[i].data()['group'];
      idPers = dataID.docs[i].id;
      if(!lstGr.containsValue(nameGr) && nameGr.compareTo("HOST") != 0) {
        lstGr.putIfAbsent(idPers, () => nameGr);
      }
    }
    print("avant" + lstGrAdded.length.toString());
    if(lstGrAdded.isNotEmpty) {
      lstGrAdded.clear();
    }
    lstGrAdded = lstGr.values.toList(growable: true) as List<String>;
    print("apres empty" + lstGrAdded.toString());

  }*/
  //méthode pour récupérer les groupes dans la collection "groupe"

  static Future<void> fetchGroupAdded(String idParticipation) async {
    //récupérer le nom de cet events pour savoir quel events qu'on touche
    //2
    List<Timestamp> start = [];
    List<Timestamp> end = [];
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participantsGr)
        .get();
    if (lstGrAdded.isNotEmpty) lstGrAdded.clear();
    if (lstDateStartAdded.isNotEmpty) lstDateStartAdded.clear();
    if (lstDateEndAdded.isNotEmpty) lstDateEndAdded.clear();
    if (hashMapGrChanged.isNotEmpty) hashMapGrChanged.clear();
    if (dataID.docs.isNotEmpty) {
      lstGrAdded = (dataID.docs[0].data()['nomListeGroupe']).cast<String>();
      for (String element in lstGrAdded) {
        hashMapGrChanged.putIfAbsent(element, () => element);
      }
      //cast en Timestamp parce que sur Firebase, il n'a pas de type DateTime
      start = (dataID.docs[1].data()['listeHeureCommencee']).cast<Timestamp>();
      end = (dataID.docs[1].data()['listeHeureTerminee']).cast<Timestamp>();
      /* for (int i = 0; i < dataID.docs.length; i++) {
        //faut convertir en String parce qu'au début c'est le type dynamic pour que je puisse sauvegarder dans la BDD
        lstGrAdded = (dataID.docs[i].data()['nomListeGroupe']).cast<String>();
      }*/
    }
    //parcourir la liste et convertir en DateTime
    lstDateStartAdded = start.map((date) => date.toDate()).toList();
    lstDateEndAdded = end.map((date) => date.toDate()).toList();
    debugPrint(lstDateStartAdded.toString());
    debugPrint(lstDateEndAdded.toString());
  }

  /*---------------------------------------*/
  //pour récupérer les emails + roles + groups
  static List<String> lstUserAdded = [];
  static List<String> lstRoleAdded = [];
  static List<String> lstGroupAdded = [];

  static Future<void> fetchListUsers(String idParticipation) async {
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participants)
        .get();
    if (lstUserAdded.isNotEmpty &&
        lstRoleAdded.isNotEmpty &&
        lstGroupAdded.isNotEmpty) {
      lstUserAdded.clear();
      lstRoleAdded.clear();
      lstGroupAdded.clear();
    }
    for (int i = 0; i < dataID.docs.length; i++) {
      if (dataID.docs[i].data()['role'] != "HOST" &&
          dataID.docs[i].data()['email'] != userUid) {
        lstUserAdded.add(dataID.docs[i].data()['email']);
        lstRoleAdded.add(dataID.docs[i].data()['role']);
        lstGroupAdded.add(dataID.docs[i].data()['group']);
      }
    }
    print("User ${lstUserAdded.toString()}");
    print("Role ${lstRoleAdded.toString()}");
    print("Group ${lstGroupAdded.toString()}");
  }

  /*---------------------------------------*/
  //avoir besoins de sauvegarder touts les emails apres la modification
  /*static Future<void> updateListUser(
      {required String docId,
        required List<String> lstGroupUpdate,
        required List<String> lstEmailUpdate,
        required List<String> lstRoleUpdate}) async {
    //parcourir pour prendre ID de chaque user dans la collection "participation"

      var dataID = await FirebaseFirestore.instance
          .collection(nameDB)
          .doc(userUid)
          .collection(eventRelated)
          .doc(docId)
          .collection(participants)
          .get();
      //comparer la taille entre l'ancienne liste et la nouvelle
      //if nouvelle > ancienne => créer l'ecart dans BDD et le mettre à jour apres
      //else => supprimer
      //ne pas avoir le droit de modifier l'email (juste supprimer un ancien ou ajouter un nouveau)
      int oldSize = dataID.docs.length;
      int newSize = lstGroupUpdate.length;

      if(oldSize > newSize) {

      }
      else if (oldSize < newSize) {

      }
      else {
        for (int i =0; i < dataID.docs.length; i++) {

          DocumentReference documentReferencer = _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(docId)
              .collection(participants)
              .doc(dataID.docs[i].id);

          Map<String, dynamic> data = <String, dynamic>{
            "nomListeGroupe": lstGroupUpdate
          };

          await documentReferencer
              .update(data)
              .whenComplete(() => print("Updated group for event ${docId}"))
              .catchError((e) => print(e));
        }
      }

    }*/

  //supprimer l'ancienne et rajouter la nouvelle => mettre à jour tous les comptes
  //comparer les emails d'ancienne dans nouvelle en utilisant HashMap
  //if nouvelle ne contient pas un dans ancienne => changer attribute isEfface
  //elseif nouvelle contient l'ancienne => mettre à jour les attributes correspondants  sur tous les comptes
  //else rajouter la liste dans HOST et invité

  static Future<void> updateListUser({
    required String docId,
    required List<String> lstGroupUpdate,
    required List<String> lstEmailUpdate,
    required List<String> lstRoleUpdate,
  }) async {
    //parcourir pour prendre ID de chaque user dans la collection "participation"
    List<String> listOfRoleScan = [];
    HashMap<int, String> checkLstMail = HashMap<int, String>();
    for (int i = 0; i < lstEmailUpdate.length; i++) {
      checkLstMail.putIfAbsent(i, () => lstEmailUpdate[i]);
      if (lstRoleUpdate[i].compareTo("Scanneur") == 0)
        listOfRoleScan.add(lstEmailUpdate[i]);
    }

    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    await fetchGroupAdded(docId);
    //traiter la mis à jour par rapport l'ancienne email
    for (int i = 0; i < dataID.docs.length; i++) {
      String emailCheck = dataID.docs[i].data()['email'];
      String id = dataID.docs[i].id;
      bool check = checkLstMail.containsValue(emailCheck);
      int index = checkLstMail.keys
          .firstWhere((k) => checkLstMail[k] == emailCheck, orElse: () => -1);
      //int index = checkLstMail.keys.toList();
      debugPrint("index = $index and status = $check");
      if (!check) {
        //if check = fasle => isEfface = true
        //supprimer cette personne dans la liste d'invitation (Organisateur )
        //pour lui, cet events est effacé par l'organisateur
        await _mainCollection
            .doc(emailCheck)
            .collection(eventRelated)
            .doc(docId)
            .update({"isEfface": false})
            .whenComplete(() => debugPrint(
                "Changer l'etat de l'attribute isEfface = false de $emailCheck"))
            .catchError((e) => debugPrint(e));
        await _mainCollection
            .doc(userUid)
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(id)
            .delete()
            .whenComplete(() => debugPrint("Deleted $emailCheck"))
            .catchError((e) => debugPrint(e));
      } else if (check && index >= 0) {
        //check = true => mettre à jour des valeurs
        Map<String, dynamic> update = <String, dynamic>{
          "group": lstGroupUpdate[index],
          "role": lstRoleUpdate[index],
        };
        //Organisateur mettre à jour la liste
        await _mainCollection
            .doc(userUid)
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(id)
            .update(update)
            .whenComplete(
                () => debugPrint("1 Changer des attributes de $emailCheck"))
            .catchError((e) => debugPrint(e));
        //Cette personne mettre à jour lui même
        int pos = lstGrAdded.indexOf(lstGroupUpdate[index]);
        await _mainCollection
            .doc(emailCheck)
            .collection(eventRelated)
            .doc(docId)
            .update({
              "role": lstRoleUpdate[index],
              "dateStart": lstDateStartAdded[pos],
              "dateEnd": lstDateEndAdded[pos]
            })
            .whenComplete(
                () => debugPrint("2 Changer des attributes de $emailCheck"))
            .catchError((e) => debugPrint(e));
        await _mainCollection
            .doc(emailCheck)
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(id)
            .update(update)
            .whenComplete(
                () => debugPrint("3 Changer des attributes de $emailCheck"))
            .catchError((e) => debugPrint(e));
        lstGroupUpdate.removeAt(index);
        lstEmailUpdate.removeAt(index);
        lstRoleUpdate.removeAt(index);
      }
    }
    for (int i = 0; i < lstEmailUpdate.length; i++) {
      //créer nouvelle liste pour le rest de la liste
      //faire étape par étape (par email)
      int pos = lstGrAdded.indexOf(lstGroupUpdate[i]);
      var detail = await FirebaseFirestore.instance
          .collection(nameDB)
          .doc(userUid)
          .collection(eventRelated)
          .doc(docId)
          .get();
      String name = detail.data()!['titre'];
      String address = detail.data()!['adresse'];
      String desc = detail.data()!['description'];
      DateTime dateEnd = lstDateStartAdded[pos];
      DateTime dateStart = lstDateEndAdded[pos];
      for (int i = 0; i < lstEmailUpdate.length; i++) {
        //ajouter cetter personne dans la bdd d'organisateur
        DocumentReference documentReferencer = _mainCollection
            .doc(userUid)
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc();

        Map<String, dynamic> data = <String, dynamic>{
          "role": lstRoleUpdate[i],
          "statutEntree": false,
          "nbEntree": 0,
          "timestamp": DateTime.now(),
          "email": lstEmailUpdate[i],
          "group": lstGroupUpdate[i]
        };

        await documentReferencer
            .set(data)
            .whenComplete(() => debugPrint("Add id: ${documentReferencer.id}"))
            .catchError((e) => debugPrint(e));
        //synchroniser cet events dans BDD de cet personne
        //faut récupérer le titre, la description, l'adresse, l'heure et la date concernant ce groupe
        syncItems(
            email: lstEmailUpdate[i],
            title: name,
            description: desc,
            address: address,
            start: dateStart,
            end: dateEnd,
            role: lstRoleUpdate[i],
            id: docId);
        //ajouter le dans la participation de cette personne
        await _mainCollection
            .doc(lstEmailUpdate[i])
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(documentReferencer.id)
            .set(data)
            .whenComplete(() => debugPrint("successful"))
            .catchError((e) => debugPrint(e));
        //encore mettre à jour dans la liste de scanneur
      }
    }

    //scanneur aussi
    var forScanner = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    //traiter la mis à jour par rapport l'ancienne email
    for (int i = 0; i < listOfRoleScan.length; i++) {
      for (var element in forScanner.docs) {
        Map<String, dynamic> data = <String, dynamic>{
          "role": element.data()['role'],
          "statutEntree": false,
          "nbEntree": 0,
          "timestamp": DateTime.now(),
          "email": element.data()['email'],
          "group": element.data()['group']
        };
        await _mainCollection
            .doc(listOfRoleScan[i])
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(element.id)
            .set(data)
            .whenComplete(() => debugPrint("successful"))
            .catchError((e) => debugPrint(e));
      }
    }
  }

  /*---------------------------------------*/
  //faire une requete pour récupérer les données concernant cet événement: attributs, groupes, liste
  static Future<bool> fetchItemClicked({
    required String docId,
    required int index,
    required String title,
  }) async {
    bool status = false;
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .orderBy("dateDebut", descending: true)
        .get();
    /* for (int i = 0; i < dataID.docs.length; i++) {
      if (dataID.docs[i].id == docId) {
        String message = "${dataID.docs[i].data()['titre']} ${dataID.docs[i].data()['adresse']} ${dataID.docs[i].data()['description']} " ;
        debugPrint("message : $message ");
        break;
      }
    }*/
    debugPrint(index.toString());
    String message =
        "${dataID.docs[index].data()['titre']} ${dataID.docs[index].data()['adresse']} ${dataID.docs[index].data()['description']} ";
    debugPrint("message : $message ");
    String role = dataID.docs[index].data()['role'];
    var dataInvite = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    List<String> listIdClient = [];
    for (int i = 0; i < dataInvite.docs.length; i++) {
      listIdClient.add(dataInvite.docs[i].id);
    }
    debugPrint("qrCode" + listIdClient.toString());
    if (role == "Organisateur") {
      //pour récupérer les groupes
      var dataGroup = await FirebaseFirestore.instance
          .collection(nameDB)
          .doc(userUid)
          .collection(eventRelated)
          .doc(docId)
          .collection(participantsGr)
          .get();
      List<String> group = [];
      group = (dataGroup.docs[0].data()['nomListeGroupe']).cast<String>();
      debugPrint(group.toString());

    }

    if (title.compareTo(dataID.docs[index].data()['titre']) != 0) {
      status = false;
    } else {
      status = true;
    }


    /*var update = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    for (int i = 0; i < update.docs.length; i++) {
      String id = update.docs[i].id;
      await _mainCollection
          .doc(userUid)
          .collection(eventRelated)
          .doc(docId)
          .collection(participants)
          .doc(id)
          .update({"nbEntree": 0,"statutEntree": false})
          .whenComplete(
              () => debugPrint("Updated email: $id with nbEntree"))
          .catchError((e) => debugPrint(e));
    }*/
    return status;
  }



  /*---------------------------------------*/
  //renvoyer la taille de la liste d'invitation
  static Future<int> fetchListSize({
    required String docId,
  }) async {
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();
    int sizeList = dataID.docs.length;
    return sizeList;
    //debugPrint("message : $key $value $nbTimeEnter");
  }
}
