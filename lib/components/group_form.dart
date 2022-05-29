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
            Text(
              "Titre : ${DatabaseTest.nameSave!}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(children: [
              const SizedBox(
                width: 75,
                child: Text(
                  "Début :",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green),
                ),
              ),
              Container(
                  width: 150,
                  alignment: Alignment.centerLeft,
                  child: Text(displayDate(DatabaseTest.startSave!))),
              Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(displayTime(DatabaseTest.timeStartSave!)))
            ]),
            Row(children: [
              const SizedBox(
                width: 75,
                child: Text(
                  "Fin :",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red),
                ),
              ),
              Container(
                  width: 150,
                  alignment: Alignment.centerLeft,
                  child: Text(displayDate(DatabaseTest.endSave!))),
              Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(displayTime(DatabaseTest.timeEndSave!)))
            ]),
            SizedBox(height: 15),
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
                          }
                          if (_groupNameList.contains(mess)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$mess est déjà créé ..."),
                                padding: const EdgeInsets.all(15.0),
                              ),
                            );
                          } else {
                            _groupNameList.add(mess);
                            DatabaseTest.listNameGroup.add(mess);
                          }
                          _groupNameCtl.clear();

                          _lstDTStart.add("$dtStart/$todStart");
                          _lstDTEnd.add("$dtEnd/$todEnd");
                          String start =
                              "${slcDStart.toLocal().toString().split(" ").first} ${slcTStart.format(context)}:00";
                          String end =
                              "${slcDEnd.toLocal().toString().split(" ").first} ${slcTEnd.format(context)}:00";
                          debugPrint("start" +
                              slcDStart.toLocal().toString().split(" ").first);
                          debugPrint("end" +
                              slcDEnd.toLocal().toString().split(" ").first);
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
            /*dateTime(slcDStart, "Début", slcTStart, true),
            dateTime(slcDEnd, "Fin", slcTEnd, false),*/
            ListView(shrinkWrap: true, children: <Widget>[
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
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
                              icon: const Icon(
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
                                icon: const Icon(
                                  Icons.delete_forever_sharp,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (!_zero) {
                                      _groupNameList.removeAt(index);
                                      _lstDTStart.removeAt(index);
                                      _lstDTEnd.removeAt(index);
                                      DatabaseTest.listHoursStart
                                          .removeAt(index);
                                      DatabaseTest.listHoursEnd.removeAt(index);
                                      DatabaseTest.listNameGroup
                                          .removeAt(index);
                                    }
                                  });
                                },
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

  void _modify(
    BuildContext context,
    int index,
  ) {
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
              dateTimeModal(
                  DateTime(
                      DatabaseTest.listHoursStart[index].year,
                      DatabaseTest.listHoursStart[index].month,
                      DatabaseTest.listHoursStart[index].day),
                  "Début",
                  TimeOfDay(
                      hour: DatabaseTest.listHoursStart[index].hour,
                      minute: DatabaseTest.listHoursStart[index].minute),
                  true,index),
              dateTimeModal(
                  DateTime(
                      DatabaseTest.listHoursEnd[index].year,
                      DatabaseTest.listHoursEnd[index].month,
                      DatabaseTest.listHoursEnd[index].day),
                  "Fin",
                  TimeOfDay(
                      hour: DatabaseTest.listHoursEnd[index].hour,
                      minute: DatabaseTest.listHoursEnd[index].minute),
                  false,index),
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

  Widget dateTimeModal(
      DateTime dateInit, String container, TimeOfDay timeInit, bool status, int index) {
    return StatefulBuilder(
        builder: (BuildContext _context, StateSetter  _setState) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: container.contains("Début") ? Colors.green : Colors.red,
                  size: 12,
                ),
                TextButton(
                    onPressed: () async {
                      final DateTime? selected = await showDatePicker(
                        locale: const Locale('fr', ''),
                        context: _context,
                        initialDate: dateInit,
                        firstDate: DatabaseTest.startSave!,
                        lastDate: DatabaseTest.endSave!,
                      );
                      if (selected != null && selected != dateInit) {
                        _setState(() {
                          dateInit = selected;
                          status ? slcDStart = selected : slcDEnd = selected;
                          status
                              ? dtStart = displayDate(dateInit)
                              : dtEnd = displayDate(dateInit);

                          status ?
                          DatabaseTest.listHoursStart[index] = DateTime(dateInit.year,dateInit.month,dateInit.day,DatabaseTest.listHoursStart[index].hour,DatabaseTest.listHoursStart[index].minute) :
                          DatabaseTest.listHoursEnd[index] = DateTime(dateInit.year,dateInit.month,dateInit.day,DatabaseTest.listHoursEnd[index].hour,DatabaseTest.listHoursEnd[index].minute) ;

                          debugPrint(displayDate(dateInit));
                          debugPrint(dtStart);
                          debugPrint("az" + dateInit.toLocal().toString());
                          debugPrint(status ? slcDStart.toString() : slcDEnd.toString());
                        });
                      }
                      _setState(() {
                        //_selectDate(_context, dateInit, status,index);

                      });
                    },
                    child: Container(
                        width: 125,
                        alignment: Alignment.centerRight,
                        child: Text(displayDate(dateInit)))),
                const SizedBox(width: 10.0),
                TextButton(
                    onPressed: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                          context: _context,
                          initialTime: timeInit,
                          initialEntryMode: TimePickerEntryMode.dial,
                          builder: (_context, child) {
                            if (MediaQuery.of(_context).alwaysUse24HourFormat) {
                              //return child!;
                              return Localizations.override(
                                context: _context,
                                locale: const Locale('fr', 'FR'),
                                child: child,
                              );
                            } else {
                              return child!;
                            }
                          });
                      if (timeOfDay != null && timeOfDay != timeInit) {
                        _setState(() {
                          timeInit = timeOfDay;
                          status ? slcTStart = timeOfDay : slcTEnd = timeOfDay;
                          status
                              ? todStart = displayTime(timeInit)
                              : todEnd = displayTime(timeInit);

                          status ?
                          DatabaseTest.listHoursStart[index] = DateTime(DatabaseTest.listHoursStart[index].year,DatabaseTest.listHoursStart[index].month,DatabaseTest.listHoursStart[index].day,timeInit.hour,timeInit.minute) :
                          DatabaseTest.listHoursEnd[index] = DateTime(DatabaseTest.listHoursEnd[index].year,DatabaseTest.listHoursEnd[index].month,DatabaseTest.listHoursEnd[index].day,timeInit.hour,timeInit.minute) ;
                        });
                      }
                      _setState(() {
                        //_selectTime(_context, timeInit, status,index);

                      });
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(displayTime(timeInit))))
              ],
            ),
          );
        });

  }

 /* Widget dateTime(
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
                alignment: Alignment.centerRight,
                child: Text(displayDate(dateInit)))),
        const SizedBox(width: 10.0),
        TextButton(
            onPressed: () {
              _selectTime(context, timeInit, status);
            },
            child: Container(
                alignment: Alignment.centerLeft,
                child: Text(displayTime(timeInit))))
      ],
    );
  }*/

  Widget subTitle(
      List<DateTime> lstStart, int position, List<DateTime> lstEnd) {
    TimeOfDay timeStart = TimeOfDay(
        hour: lstStart[position].toLocal().hour,
        minute: lstStart[position].toLocal().minute);
    TimeOfDay timeEnd = TimeOfDay(
        hour: lstEnd[position].toLocal().hour,
        minute: lstEnd[position].toLocal().minute);
    String start = lstStart[position].toLocal().toString().split(" ").first +
        " - " +
        timeStart.format(context);
    String end = lstEnd[position].toLocal().toString().split(" ").first +
        " - " +
        timeEnd.format(context);
    //+ lstEnd[position].toLocal().toString().split(" ").last;
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
              style: TextStyle(fontSize: 14),
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
              style: TextStyle(fontSize: 14),
            )
          ],
        )
      ],
    );
  }

  _selectDate(BuildContext context, DateTime dateTimeInit, bool status,int index) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('fr', ''),
      context: context,
      initialDate: dateTimeInit,
      firstDate: DatabaseTest.startSave!,
      lastDate: DatabaseTest.endSave!,
    );
    if (selected != null && selected != dateTimeInit) {
      //setState(() {
        dateTimeInit = selected;
        status ? slcDStart = selected : slcDEnd = selected;
        status
            ? dtStart = displayDate(dateTimeInit)
            : dtEnd = displayDate(dateTimeInit);

        status ?
        DatabaseTest.listHoursStart[index] = DateTime(dateTimeInit.year,dateTimeInit.month,dateTimeInit.day,DatabaseTest.listHoursStart[index].hour,DatabaseTest.listHoursStart[index].minute) :
        DatabaseTest.listHoursEnd[index] = DateTime(dateTimeInit.year,dateTimeInit.month,dateTimeInit.day,DatabaseTest.listHoursEnd[index].hour,DatabaseTest.listHoursEnd[index].minute) ;

        debugPrint(displayDate(dateTimeInit));
        debugPrint(dtStart);
        debugPrint("az" + dateTimeInit.toLocal().toString());
        debugPrint(status ? slcDStart.toString() : slcDEnd.toString());
      //});
    }
  }

  _selectTime(BuildContext context, TimeOfDay todInit, bool status,int index) async {
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

        status ?
        DatabaseTest.listHoursStart[index] = DateTime(DatabaseTest.listHoursStart[index].year,DatabaseTest.listHoursStart[index].month,DatabaseTest.listHoursStart[index].day,todInit.hour,todInit.minute) :
        DatabaseTest.listHoursEnd[index] = DateTime(DatabaseTest.listHoursEnd[index].year,DatabaseTest.listHoursEnd[index].month,DatabaseTest.listHoursEnd[index].day,todInit.hour,todInit.minute) ;
      });
    }
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
      'jan.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.'
    ];

    if (dateInit.day < 10) {
      day = "0${dateInit.day}";
    } else {
      day = "${dateInit.day}";
    }

    message =
        "${dayOfWeek[dateInit.weekday - 1]} $day ${months[dateInit.month - 1]} ${dateInit.year}";
    return message;
  }
}
