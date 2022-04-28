import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class DatabaseTest {
  //définir le nom de personne qui se connecte
  //static String userUid = "test14@gmail.com";
  static String userUid = "example4@gmail.com";
  /*---------------------------------------*/
  //variable globale pour changer la BDD
  static String nameDB = "evenements"; //nom de bdd
  static String eventRelated = "items"; //nom de la premiere collection
  static String participants = "participation"; //nom de la 2eme collection
  static String participantsGr =
      "groupe"; //nom de la collection qui sauvegarde les groupes dans un event
  static String listOfGroup =
      "listeGroupe"; //nom du document de la collection "groupe"
  /*---------------------------------------*/
  //des variables pour les sauvegarder dans la BDD (les mettre en variable pour les déplacer étape par étape)
  static String? docIdAdd; //renvoyer ID d'un event spécifique
  static String? addrSave; //Adresses
  static String? nameSave; //titre
  static String? descSave; //description
  static DateTime? startSave; //date commencé
  static DateTime? endSave; //date fin
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
  //pour save d'un nom de chaque groupe
  static List<String> listNameGroup = [];

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
            () => print("Event of this account updated in the database"))
        .catchError((e) => print(e));
  }

  /*---------------------------------------*/
  //pour récupérer tous les events dans la BDD et les metrre dans un listview
  static Stream<QuerySnapshot> readItems() {
    Query<Map<String, dynamic>> notesItemCollection = _mainCollection
        .doc(userUid)
        .collection("items")
        .orderBy("dateDebut", descending: true);
    //_mainCollection.doc("test@gmail.com").collection(eventRelated);

    return notesItemCollection.snapshots();
  }

  /*---------------------------------------*/
  //pour récupérer tous les events dans la BDD mais trier par "role"
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
          .where("titre",
              /*isGreaterThanOrEqualTo: searchSave, isLessThan: searchSave+ 'z')*/
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
          .orderBy("dateDebut", descending: false)
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
    //Step 2bis : delete list of group (participation) of this event
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
      "group": "HOST"
    };

    await documentReferencer
        .set(data)
        .whenComplete(
            () => print("Add Organisateur : id " + documentReferencer.id))
        .catchError((e) => print(e));

    //Step 2bis: Need to also save the list of group for modify after
    DocumentReference documentRefGr = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docIdAdd)
        .collection(participantsGr)
        .doc(listOfGroup);
    //utiliser hashmap pour éviter les duplicatas
    HashMap<String, int> hashMapGr = new HashMap<String, int>();
    for(int i = 0;i < listGroup.length; i++) {
      hashMapGr.putIfAbsent(listGroup[i], () => i);
    }
    /*print(hashMapGr.toString());
    print(hashMapGr.keys.toList(growable: false));*/
    Map<String, dynamic> dataGr = <String, dynamic>{
      "nomListeGroupe": hashMapGr.keys.toList(growable: false)
    };
    await documentRefGr
        .set(dataGr)
        .whenComplete(() => print("Updated group for event ${docIdAdd}"))
        .catchError((e) => print(e));

    //Step 2: Save the list into database
    for (int i = 0; i < listEmail.length; i++) {
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
        "group": listGroup[i]
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
          role: listRole[i]);
      //Step 4: in this event of this client, create too an email in the collection "participation" for the content of QRCode
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
    }
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
        _mainCollection.doc(email).collection(eventRelated).doc(docIdAdd);

    Map<String, dynamic> data = <String, dynamic>{
      "titre": title,
      "description": description,
      "adresse": address,
      "dateDebut": start,
      "dateEnd": end,
      "role": role,
      "isEfface": isDel,
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
  //check status de QRCode
  static bool status = false;
  static late int nbPersonTotal = 0; //nb total de personne dans un events
  static late int countPersonEnter = 0; //compter cb de persons qui rentre
  static int countPersonScanned = 0; //compter cb de fois qu'il rentre
  static String emailClient = "";
  //static late HashMap lstPersonEnter ;
  static HashMap lstPersonScanned = HashMap<String, int>();

  //fonction pour verifier le status du client
  static void fetchDataCheck(
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
    nbPersonTotal = dataID.docs.length;
    //countPersonEnter = 0;
    for (int i = 0; i < dataID.docs.length; i++) {
      if (contentQRCode.compareTo(dataID.docs[i].id) == 0) {
        status = true;
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
              .update({"statutEntree": status})
              .whenComplete(() => print("Updated email: " +
                  emailClient +
                  "with status: " +
                  status.toString()))
              .catchError((e) => print(e));
          //countPersonEnter++;
        } else {
          lstPersonScanned.update(contentQRCode,
              (value) => value++); //mettre à jour une valeur dans la liste
        }
      } else {
        status = false;
      }
    }
  }

  /*---------------------------------------*/
  //pour récupérer tous les groupes dans la BDD
  static List<String> lstGrAdded = [];
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

  static void fetchGroupAdded(String idParticipation) async {
    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(idParticipation)
        .collection(participantsGr)
        .get();

    for (int i = 0; i < dataID.docs.length; i++) {
      //faut convertir en String parce qu'au début c'est le type dynamic pour que je puisse sauvegarder dans la BDD
      lstGrAdded = (dataID.docs[i].data()['nomListeGroupe']).cast<String>();
    }
  }

  /*---------------------------------------*/
  //avoir besoins de sauvegarder touts les groupes sur BDD pour
  static Future<void> updateGroup(
      {required String docId, required List<String> lstGroupUpdate}) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participantsGr)
        .doc(listOfGroup);

    Map<String, dynamic> data = <String, dynamic>{
      "nomListeGroupe": lstGroupUpdate
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Updated group for event ${docId}"))
        .catchError((e) => print(e));
  }

  /*---------------------------------------*/
  //pour récupérer les emails + roles + groups
  static List<String> lstUserAdded = [];
  static List<String> lstRoleAdded = [];
  static List<String> lstGroupAdded = [];
  static void fetchListUsers(String idParticipation) async {
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
    print("User ${lstUserAdded.length}");
    print("Role ${lstRoleAdded.length}");
    print("Group ${lstGroupAdded.length}");
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
    HashMap<int, String> checkLstMail = HashMap<int, String>();
    for (int i = 0; i < lstEmailUpdate.length; i++) {
      checkLstMail.putIfAbsent(i, () => lstEmailUpdate[i]);
    }

    var dataID = await FirebaseFirestore.instance
        .collection(nameDB)
        .doc(userUid)
        .collection(eventRelated)
        .doc(docId)
        .collection(participants)
        .get();

    for (int i = 0; i < dataID.docs.length; i++) {
      String emailCheck = dataID.docs[i].data()['email'];
      bool check = checkLstMail.containsValue(emailCheck);
      int index = checkLstMail.keys
          .firstWhere((k) => checkLstMail[k] == emailCheck, orElse: () => -1);

      if (!check) {
        //if check = fasle => isEfface = true
        await _mainCollection
            .doc(emailCheck)
            .collection(eventRelated)
            .doc(docId)
            .update({"isEfface": false})
            .whenComplete(() => print(
                "Changer l'etat de l'attribute isEfface = false de ${emailCheck}"))
            .catchError((e) => print(e));
      } else if (check && index > 0) {
        //check = true => mettre à jour des valeurs
        Map<String, dynamic> update = <String, dynamic>{
          "groupe": lstGroupUpdate[index],
          "role": lstGroupUpdate[index],
        };
        await _mainCollection
            .doc(emailCheck)
            .collection(eventRelated)
            .doc(docId)
            .collection(participants)
            .doc(dataID.docs[i].id)
            .update(update)
            .whenComplete(
                () => print("Changer des attributes de ${emailCheck}"))
            .catchError((e) => print(e));
        lstGroupUpdate.removeAt(index);
        lstEmailUpdate.removeAt(index);
        lstRoleUpdate.removeAt(index);
      } else {
        //créer nouveau liste
        for (int i = 0; i < lstGroupUpdate.length; i++) {
          DocumentReference documentReferencer = _mainCollection
              .doc(userUid)
              .collection(eventRelated)
              .doc(docIdAdd)
              .collection(participants)
              .doc();

          Map<String, dynamic> data = <String, dynamic>{
            "role": lstRoleUpdate[i],
            "statutEntree": false,
            "timestamp": DateTime.now(),
            "email": lstEmailUpdate[i],
            "group": lstGroupUpdate[i]
          };

          await documentReferencer
              .set(data)
              .whenComplete(
                  () => print("Add id: ${documentReferencer.id}"))
              .catchError((e) => print(e));

          syncItems(
              email: lstEmailUpdate[i],
              title: nameSave!,
              description: descSave!,
              address: addrSave!,
              start: startSave!,
              end: endSave!,
              role: listRole[i]);

          await _mainCollection
              .doc(lstEmailUpdate[i])
              .collection(eventRelated)
              .doc(docIdAdd)
              .collection(participants)
              .doc(documentReferencer.id)
              .set(data)
              .whenComplete(() => print("successful"))
              .catchError((e) => print(e));
        }
      }

    }
  }
}
