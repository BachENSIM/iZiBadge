import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/model/database_test.dart';

import 'custom_colors.dart';

class GroupForm extends StatefulWidget {
  //const GroupForm({Key? key}) : super(key: key);

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _groupNameCtl =
      TextEditingController(); // un autre controller pour saisir => creer des groupe differents
  TextEditingController?
      _groupEditCtl; //un autre controller pour modifier le nom d'un groupe
  //un controller par default => afficher un groupe par default
  String initialText = "Groupe 1";
  TextEditingController? _groupInitCtl;

  //verifier l'indice de la liste => si = 0 => c'est le default(ne pas del)
  bool _zero = true;

  //pour sauvegarder dans la BDD
  final List<String> _groupNameList = ["Groupe 1"];
  late int taille;

  //pour afficher la date et l'heure afin de limiter par rapport aux groupes
  late String? dateShare;
  late String? timeShare;

  DateTime slcDStart = DatabaseTest.startSave!;
  DateTime slcDEnd = DatabaseTest.endSave!;
  TimeOfDay slcTStart = DatabaseTest.timeStartSave!;
  TimeOfDay slcTEnd = DatabaseTest.timeEndSave!;

  late String dtStart = displayDate(DatabaseTest.startSave!);
  late String dtEnd = displayDate(DatabaseTest.endSave!);
  late String todStart = displayTime(DatabaseTest.timeStartSave!);
  late String todEnd = displayTime(DatabaseTest.timeEndSave!);

  late final List<String> _lstDTStart = ["$dtStart/$todStart"];
  late final List<String> _lstDTEnd = ["$dtEnd/$todEnd"];

  @override
  void initState() {
    super.initState();
    taille = _groupNameList.length + 1;
    _groupInitCtl = TextEditingController(text: initialText);
    if (DatabaseTest.listNameGroup.isNotEmpty)
      DatabaseTest.listNameGroup.clear();
    DatabaseTest.listNameGroup.add(_groupNameList[0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _groupInitCtl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _groupNameCtl,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    //Hides label on focus or if filled
                    labelText: "Ex: Groupe Etudiant",
                    filled: true,
                    // Needed for adding a fill color
                    //fillColor: CustomColors.backgroundLight,
                    isDense: false,
                    // Reduces height a bit
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft:
                              Radius.circular(12.0)), // Apply corner radius
                    ),
                    prefixIcon: const Icon(Icons.group_add, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: IconButton(
                          onPressed: () {
                            _groupNameCtl.clear();
                          },
                          icon: Icon(Icons.clear_rounded)),
                    ),
                  ),
                )),
                SizedBox(
                  height: 59,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String mess = _groupNameCtl.text;
                          if (_groupNameCtl.text.isEmpty) {
                            mess = "Groupe " + (taille++).toString();
                            _groupNameList.add(mess);
                          } else {
                            _groupNameList.add(_groupNameCtl.text);
                          }
                          DatabaseTest.listNameGroup.add(mess);
                          _groupNameCtl.clear();
                          _lstDTStart.add("$dtStart/$todStart");
                          _lstDTEnd.add("$dtEnd/$todEnd");
                          String start =
                              "${slcDStart.toUtc().toString().split(" ").first} ${slcTStart.format(context)}:00";
                          String end =
                              "${slcDEnd.toUtc().toString().split(" ").first} ${slcTEnd.format(context)}:00";
                          debugPrint("start" +
                              slcDStart.toUtc().toString().split(" ").first);
                          debugPrint("end" +
                              slcDEnd.toUtc().toString().split(" ").first);
                          //debugPrint(slcTStart.format(context));
                          DatabaseTest.listHoursStart
                              .add(DateTime.parse(start));
                          DatabaseTest.listHoursEnd.add(DateTime.parse(end));
                          debugPrint(DatabaseTest.listNameGroup.toString());
                          debugPrint(DatabaseTest.listHoursStart.toString());
                          debugPrint(DatabaseTest.listHoursEnd.toString());
                        });
                      },
                      //style:  ElevatedButton.styleFrom(side: ),
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0)))),
                      child: const Text("Ajouter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            //color: CustomColors.textSecondary,
                          ))),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            /*dateTime(DatabaseTest.startSave!,"Début",DatabaseTest.timeStartSave!),
            dateTime(DatabaseTest.endSave!,"Fin",DatabaseTest.timeEndSave!),  */
            dateTime(slcDStart, "Début", slcTStart, true),
            dateTime(slcDEnd, "Fin", slcTEnd, false),
            ListView(shrinkWrap: true, children: <Widget>[
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groupNameList.length,
                  itemBuilder: (BuildContext context, int index) {
                    (_groupNameList.length != 1) ? _zero = false : _zero = true;
                    return Column(children: <Widget>[
                      GFListTile(
                        avatar: CircleAvatar(
                            radius: 20,
                            //backgroundColor: CustomColors.accentDark,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                //color: CustomColors.textSecondary
                              ),
                            )),
                        titleText: _groupNameList[index],
                        //subTitleText: subTitle(_lstDTStart, index, _lstDTEnd),
                        //subTitle: subTitle(_lstDTStart, index, _lstDTEnd),
                        subTitle: subTitle(DatabaseTest.listHoursStart, index,
                            DatabaseTest.listHoursEnd),
                        color: index.isEven
                            ? CustomColors.lightPrimaryColor
                            : CustomColors.darkPrimaryColor,
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                size: 18,
                              ),
                              onPressed: () {
                                _groupEditCtl = TextEditingController(
                                    text: _groupNameList[index]);
                                setState(() {
                                  _modify(context, index);
                                });
                              },
                              //color: CustomColors.accentDark,
                            ),
                            if (!_zero)
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever_sharp,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (!_zero) {
                                      _groupNameList.removeAt(index);
                                      _lstDTStart.removeAt(index);
                                      _lstDTEnd.removeAt(index);
                                      DatabaseTest.listNameGroup
                                          .removeAt(index);
                                    }
                                  });
                                },
                                //color: _zero
                                //     ? Colors.grey
                                //     : CustomColors.accentDark,
                              )
                          ],
                        ),
                      ),
                    ]);
                  },
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Widget dateTime(
      DateTime dateInit, String container, TimeOfDay timeInit, bool status) {
    return Row(
      children: [
        Container(width: 50, child: Text(container)),
        TextButton(
            onPressed: () {
              _selectDate(context, dateInit, status);
            },
            child: Container(
                width: 125,
                alignment: Alignment.center,
                child: Text(displayDate(dateInit)))),
        const SizedBox(width: 10.0),
        TextButton(
            onPressed: () {
              _selectTime(context, timeInit, status);
            },
            child: Container(
                alignment: Alignment.center,
                child: Text(displayTime(timeInit))))
      ],
    );
  }

  String displayDate(DateTime dateInit) {
    String message = "";
    String day = "";
    List<String> dayOfWeek = [
      'lun.',
      'mar.',
      'mer.',
      'jeu.',
      'ven.',
      'sam.',
      'dim.'
    ];
    List<String> months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'decembre'
    ];

    if (dateInit.day < 10) {
      day = "0${dateInit.day}";
    } else {
      day = "${dateInit.day}";
    }
    message =
        "${dayOfWeek[dateInit.weekday - 1]} $day ${months[dateInit.month - 1]}, ${dateInit.year}";
    return message;
  }

  /*Widget subTitle(List<String> lstStart, int position, List<String> lstEnd) {
    String start = lstStart[position].split("/").first +
        " - " +
        lstStart[position].split("/").last;
    String end = lstEnd[position].split("/").first +
        " - " +
        lstEnd[position].split("/").last;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            const Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 10,
            ),
            Text(start,style: TextStyle(fontSize: 12),)
          ],
        ),
        Row(
          children: <Widget>[
            const Icon(
              Icons.calendar_today,
              color: Colors.red,
              size: 10,
            ),
            Text(end,style: TextStyle(fontSize: 12),)
          ],
        )
      ],
    );
  }*/

  Widget subTitle(
      List<DateTime> lstStart, int position, List<DateTime> lstEnd) {
    String start = lstStart[position].toLocal().toString().split(" ").first +
        " - " +
        lstStart[position].toLocal().toString().split(" ").last;
    String end = lstEnd[position].toLocal().toString().split(" ").first +
        " - " +
        lstEnd[position].toLocal().toString().split(" ").last;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            const Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 12,
            ),
            Text(
              start,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        Row(
          children: <Widget>[
            const Icon(
              Icons.calendar_today,
              color: Colors.red,
              size: 12,
            ),
            Text(
              end,
              style: TextStyle(fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  String displayTime(TimeOfDay timeInit) {
    String message = "";
    String mins = "";
    String hours = "";
    (timeInit.minute < 10)
        ? mins = "0${timeInit.minute}"
        : mins = "${timeInit.minute}";
    (timeInit.hour < 10)
        ? hours = "0${timeInit.hour}"
        : hours = "${timeInit.hour}";
    message = "$hours:$mins";
    return message;
  }

  _selectDate(BuildContext context, DateTime dateTimeInit, bool status) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('fr', ''),
      context: context,
      initialDate: dateTimeInit,
      firstDate: DatabaseTest.startSave!,
      lastDate: DatabaseTest.endSave!,
    );
    if (selected != null && selected != dateTimeInit) {
      setState(() {
        dateTimeInit = selected;
        status ? slcDStart = selected : slcDEnd = selected;
        status
            ? dtStart = displayDate(dateTimeInit)
            : dtEnd = displayDate(dateTimeInit);
        debugPrint(displayDate(dateTimeInit));
        debugPrint("az" + dateTimeInit.toLocal().toString());
        debugPrint(status ? slcDStart.toString() : slcDEnd.toString());
      });
    }
  }

  _selectTime(BuildContext context, TimeOfDay todInit, bool status) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: todInit,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (context, child) {
          if (MediaQuery.of(context).alwaysUse24HourFormat) {
            //return child!;
            return Localizations.override(
              context: context,
              locale: const Locale('fr', 'FR'),
              child: child,
            );
          } else {
            return Localizations.override(
              context: context,
              locale: const Locale('fr', 'FR'),
              child: child,
            );
          }
        });
    if (timeOfDay != null && timeOfDay != todInit) {
      setState(() {
        todInit = timeOfDay;
        status ? slcTStart = timeOfDay : slcTEnd = timeOfDay;
        status
            ? todStart = displayTime(todInit)
            : todEnd = displayTime(todInit);
      });
    }
  }

  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Renommer"),
            content: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              controller: _groupEditCtl,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler")),
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      _groupNameList[index] = _groupEditCtl!.text;
                      DatabaseTest.listNameGroup[index] = _groupNameList[index];
                      print("list" + _groupNameList[index]);
                      print("data: " + DatabaseTest.listNameGroup.toString());
                      _groupEditCtl?.clear();
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Renommer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          );
        });
  }
}
