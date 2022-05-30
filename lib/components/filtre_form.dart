import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:izibagde/model/database_test.dart';

class FiltreForm extends StatefulWidget {
  final int nbOrganisateur;
  final int nbInviteur;
  final int nbScan;

  FiltreForm({
    required this.nbOrganisateur,
    required this.nbInviteur,
    required this.nbScan
});
  @override
  _FiltreFormState createState() => _FiltreFormState();
}

class _FiltreFormState extends State<FiltreForm> {

  @override
  Widget build(BuildContext context) {
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
                  child: const Text('Filtre by Role')),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Organisateur : "),
                      Checkbox(
                          value: DatabaseTest.isOrgan,
                          onChanged: (bool? value) {
                            setState(() {
                              DatabaseTest.isOrgan = value!;
                              print("organisateur " +   DatabaseTest.isOrgan.toString());
                            });
                          }),
                      Text("Count : "  + widget.nbOrganisateur.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Invité : "),
                      Checkbox(
                          value:   DatabaseTest.isInvite,
                          onChanged: (bool? value) {
                            setState(() {
                              DatabaseTest.isInvite = value!;
                              debugPrint("invité " + DatabaseTest.isInvite.toString());
                            });
                          }),
                      Text("Count : " +  widget.nbInviteur.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Scanneur : "),
                      Checkbox(
                          value: DatabaseTest.isScan,
                          onChanged: (bool? value) {
                            setState(() {
                              DatabaseTest.isScan = value!;
                              debugPrint("scanneur " + DatabaseTest.isScan.toString());
                            });
                          }),
                      Text("Count : " +  widget.nbScan.toString()),
                    ],
                  ),
                  GFCheckboxListTile(
                    titleText: "Scanneur :" +  widget.nbScan.toString(),
                      value: DatabaseTest.isScan,
                      onChanged: (bool? value) {
                        setState(() {
                          DatabaseTest.isScan = value!;
                          debugPrint("scanneur " + DatabaseTest.isScan.toString());
                        });
                      }
                      )
                ],
              ),
            ],
          ),
        ),
      );
  }
}
