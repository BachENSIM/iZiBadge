import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';

class EditGroupForm extends StatefulWidget {
  //const EditGroupForm({Key? key}) : super(key: key);
  late final String documentId;
  late final String nameEvent;
  late final DateTime dateStart;
  late final DateTime dateEnd;

  EditGroupForm({
    required this.documentId,
    required this.nameEvent,
    required this.dateStart,
    required this.dateEnd,
  });

  @override
  _EditGroupFormState createState() => _EditGroupFormState();
}

class _EditGroupFormState extends State<EditGroupForm> {
  // un autre controller pour saisir => creer des groupe differents
  final _groupNameCtl = TextEditingController();

  //un autre controller pour modifier le nom d'un groupe
  TextEditingController? _groupEditCtl;

  //un controller par default => afficher un groupe par default
  String initialText = "Groupe 2";
  TextEditingController? _groupInitCtl;

  //verifier l'indice de la liste => si = 0 => c'est le default
  bool _one = false;
  bool _isProcessing = false;

  //pour sauvegarder dans la BDD

  late int taille = 2;

  //pour heures/ dates
  late DateTime slcDStart = DateTime(widget.dateStart.year,widget.dateStart.month,widget.dateStart.day);
  late DateTime slcDEnd = DateTime(widget.dateEnd.year,widget.dateEnd.month,widget.dateEnd.day);
  late TimeOfDay slcTStart = TimeOfDay(hour: widget.dateStart.hour,minute:widget.dateStart.minute );
  late TimeOfDay slcTEnd = TimeOfDay(hour: widget.dateEnd.hour,minute:widget.dateEnd.minute );


  late String dtStart = displayDate(slcDStart);
  late String dtEnd = displayDate(slcDEnd);
  late String todStart = displayTime(slcTStart);
  late String todEnd = displayTime(slcTEnd);

  late final List<String> _lstDTStart = ["$dtStart/$todStart"];
  late final List<String> _lstDTEnd = ["$dtEnd/$todEnd"];


  @override
  void initState() {
    super.initState();
    _groupInitCtl = TextEditingController(text: initialText);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Titre : ${widget.nameEvent}",
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
                  child: Text(displayDate(DateTime(widget.dateStart.year,
                      widget.dateStart.month, widget.dateStart.day)))),
              Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(displayTime(TimeOfDay(
                      hour: widget.dateStart.hour,
                      minute: widget.dateStart.minute))))
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
                  child: Text(displayDate(DateTime(widget.dateEnd.year,
                      widget.dateEnd.month, widget.dateEnd.day)))),
              Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(displayTime(TimeOfDay(
                      hour: widget.dateEnd.hour,
                      minute: widget.dateEnd.minute))))
            ]),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: _groupNameCtl,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    //Hides label on focus or if filled
                    labelText: "Ex: Groupe Etudiant",
                    filled: true,
                    // Needed for adding a fill color
                    // fillColor: CustomColors.backgroundLight,
                    isDense: false,
                    // Reduces height a bit
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0)),
                    ),
                    prefixIcon: const Icon(Icons.group_add, size: 22),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: IconButton(
                          onPressed: () {
                            _groupNameCtl.clear();
                          },
                          icon: const Icon(Icons.clear_rounded)),
                    ),
                  ),
                )),
                SizedBox(
                  height: 59,
                  /*width: 75,*/
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String mess = _groupNameCtl.text;
                          if (_groupNameCtl.text.isEmpty) {
                            mess = "Groupe " + (taille++).toString();
                          }
                          if (DatabaseTest.lstGrAdded.contains(mess)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$mess est déjà créé ..."),
                                padding: const EdgeInsets.all(15.0),
                              ),
                            );
                          } else {
                            DatabaseTest.hashMapGrChanged.putIfAbsent(mess,() => mess);
                            //_groupNameList.add(mess);
                            DatabaseTest.lstGrAdded.add(mess);
                            _groupNameCtl.clear();
                          }
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
                          DatabaseTest.lstDateStartAdded
                              .add(DateTime.parse(start));
                          DatabaseTest.lstDateEndAdded.add(DateTime.parse(end));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0)))),
                      child: const Text("Ajouter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            // color: CustomColors.textSecondary,
                          ))),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ListView(shrinkWrap: true, children: <Widget>[
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 1.7,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: DatabaseTest.lstGrAdded.length,
                  itemBuilder: (BuildContext context, int index) {
                    //if (_groupNameList.length == 1)
                    (DatabaseTest.lstGrAdded.length == 1)
                        ? _one = true
                        : _one = false;
                    return Column(children: <Widget>[
                      GFListTile(
                        color: index.isEven
                            ? CustomColors.lightPrimaryColor
                            : CustomColors.lightPrimaryColor.withOpacity(0.6),
                        avatar: CircleAvatar(
                            radius: 20,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            )),
                        titleText: DatabaseTest.lstGrAdded[index],
                        subTitle: subTitle(DatabaseTest.lstDateStartAdded,
                            index, DatabaseTest.lstDateEndAdded),
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit_rounded),
                              onPressed: () {
                                _groupEditCtl = TextEditingController(
                                    text: DatabaseTest.lstGrAdded[index]);
                                setState(() {
                                  _modify(context, index);
                                });
                              },
                            ),
                            if (!_one)
                              IconButton(
                                icon: const Icon(Icons.delete_forever_sharp),
                                onPressed: () {
                                  setState(() {
                                    if (!_one) {

                                      if(DatabaseTest.hashMapGrChanged.containsValue(DatabaseTest.lstGrAdded[index])) {
                                        int position = DatabaseTest.hashMapGrChanged.values.toList().indexOf(DatabaseTest.lstGrAdded[index]);
                                        String key = DatabaseTest.hashMapGrChanged.keys.toList().elementAt(position);
                                        DatabaseTest.hashMapGrChanged.update(key, (value) => "deleted");
                                        debugPrint("2 " + DatabaseTest.hashMapGrChanged.toString());
                                      }
                                      DatabaseTest.lstGrAdded.removeAt(index);
                                      DatabaseTest.lstDateStartAdded
                                          .removeAt(index);
                                      DatabaseTest.lstDateEndAdded
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
            const SizedBox(
              height: 15,
            ),
            _isProcessing
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                          ),
                    ),
                  )
                : Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isProcessing = false;
                        });
                        await DatabaseTest.updateGroup(
                            docId: widget.documentId,
                            lstGroupUpdate: DatabaseTest.lstGrAdded,
                            lstDateStart: DatabaseTest.lstDateStartAdded,
                            lstDateEnd: DatabaseTest.lstDateEndAdded);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                        setState(() {
                          _isProcessing = true;
                        });

                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Sauvegarder",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
  //le modal pour modifier
  void _modify(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Modifier le nom du groupe'),
            content: TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              controller: _groupEditCtl,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                isDense: true,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: [
              dateTimeModal(
                  DateTime(
                      DatabaseTest.lstDateStartAdded[index].year,
                      DatabaseTest.lstDateStartAdded[index].month,
                      DatabaseTest.lstDateStartAdded[index].day),
                  "Début",
                  TimeOfDay(
                      hour: DatabaseTest.lstDateStartAdded[index].hour,
                      minute: DatabaseTest.lstDateStartAdded[index].minute),
                  true,
                  index),
              dateTimeModal(
                  DateTime(
                      DatabaseTest.lstDateEndAdded[index].year,
                      DatabaseTest.lstDateEndAdded[index].month,
                      DatabaseTest.lstDateEndAdded[index].day),
                  "Fin",
                  TimeOfDay(
                      hour: DatabaseTest.lstDateEndAdded[index].hour,
                      minute: DatabaseTest.lstDateEndAdded[index].minute),
                  false,
                  index),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  // Remove the box
                  setState(() {
                    if(DatabaseTest.hashMapGrChanged.containsValue(DatabaseTest.lstGrAdded[index])) {
                      int position = DatabaseTest.hashMapGrChanged.values.toList().indexOf(DatabaseTest.lstGrAdded[index]);
                      String key = DatabaseTest.hashMapGrChanged.keys.toList().elementAt(position);
                      DatabaseTest.hashMapGrChanged.update(key, (value) =>  _groupEditCtl!.text);
                    }
                    DatabaseTest.lstGrAdded[index] = _groupEditCtl!.text;
                    _groupEditCtl?.clear();
                  });
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Modifier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
  //Pour ajouter 2 lignes: heure commencé et heure terminé
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
  //un modal qui permet de sélectionner date/heure en même temps
  Widget dateTimeModal(DateTime dateInit, String container, TimeOfDay timeInit,
      bool status, int index) {
    return StatefulBuilder(
        builder: (BuildContext _context, StateSetter _setState) {
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
                    firstDate: widget.dateStart,
                    lastDate: widget.dateEnd,
                  );
                  if (selected != null && selected != dateInit) {
                    _setState(() {
                      dateInit = selected;
                      status
                          ? DatabaseTest.lstDateStartAdded[index] = DateTime(
                              dateInit.year,
                              dateInit.month,
                              dateInit.day,
                              DatabaseTest.lstDateStartAdded[index].hour,
                              DatabaseTest.lstDateStartAdded[index].minute)
                          : DatabaseTest.lstDateEndAdded[index] = DateTime(
                              dateInit.year,
                              dateInit.month,
                              dateInit.day,
                              DatabaseTest.lstDateEndAdded[index].hour,
                              DatabaseTest.lstDateEndAdded[index].minute);

                      debugPrint(displayDate(dateInit));
                    });
                  }
                  _setState(() {
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

                      status
                          ? DatabaseTest.lstDateStartAdded[index] = DateTime(
                              DatabaseTest.lstDateStartAdded[index].year,
                              DatabaseTest.lstDateStartAdded[index].month,
                              DatabaseTest.lstDateStartAdded[index].day,
                              timeInit.hour,
                              timeInit.minute)
                          : DatabaseTest.lstDateEndAdded[index] = DateTime(
                              DatabaseTest.lstDateEndAdded[index].year,
                              DatabaseTest.lstDateEndAdded[index].month,
                              DatabaseTest.lstDateEndAdded[index].day,
                              timeInit.hour,
                              timeInit.minute);
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
  //Afficher heure sous forme String
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
  //Afficher date sous forme String
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
