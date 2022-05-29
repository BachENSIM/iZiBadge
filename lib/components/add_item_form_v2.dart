import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/custom_form_field.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/model/validator.dart';
import 'package:izibagde/screens/add_group_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AddItemForm extends StatefulWidget {
  //const AddItemForm({Key? key}) : super(key: key);

  final FocusNode titleFocusNode;
  final FocusNode descFocusNode;
  final FocusNode addrFocusNode;

  const AddItemForm(
      {required this.titleFocusNode,
      required this.descFocusNode,
      required this.addrFocusNode});

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  //for create date and hours of event
/*  DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay.now(); */
  DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  late DateTime selectedDateEnd = selectedDateStart;

  late TimeOfDay selectedTimeEnd = TimeOfDay(
      hour: selectedTimeStart.hour + 1, minute: selectedTimeStart.minute);

  late String? startDate = displayDate(selectedDateStart);
  late String? startTime =
      displayTime(TimeOfDay(hour: selectedDateStart.hour + 1, minute: 00));
  late String? endDate = displayDate(selectedDateEnd);
  late String? endTime =
      displayTime(TimeOfDay(hour: selectedDateStart.hour + 2, minute: 00));

  final TextEditingController _titleCtl = TextEditingController();
  final TextEditingController _descCtl = TextEditingController();
  final TextEditingController _addrCtl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("Create " + selectedTimeStart.hour.toString());
    if (selectedTimeStart.hour == 24) {
      selectedDateStart = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      selectedTimeStart = TimeOfDay(hour: 0, minute: 0);
      startTime = displayTime(selectedTimeStart);
      debugPrint("Create " + selectedTimeEnd.hour.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addItemFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12.0),
                const Text(
                  'Titre',
                  style: TextStyle(
                    //color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _titleCtl,
                  focusNode: widget.titleFocusNode,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Titre',
                  hint: "Saisir le titre de l'événement",
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Description',
                  style: TextStyle(
                    //color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  maxLines: 7,
                  isLabelEnabled: false,
                  controller: _descCtl,
                  focusNode: widget.descFocusNode,
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Description',
                  hint: "Saisir la description de l'événement",
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Adresse',
                  style: TextStyle(
                    //color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomFormField(
                  maxLines: 3,
                  isLabelEnabled: false,
                  controller: _addrCtl,
                  focusNode: widget.addrFocusNode,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateField(
                    value: value,
                  ),
                  label: 'Adresse',
                  hint: "Saisir l'adresse de l'événement",
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Date et heure de début',
                  style: TextStyle(
                    //color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                dateTime(selectedDateStart, selectedTimeStart, true),
                const SizedBox(height: 12.0),
                const Text(
                  'Date et heure de fin',
                  style: TextStyle(
                    //color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                dateTime(selectedDateEnd, selectedTimeEnd, false),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
          _isProcessing
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                      // valueColor: AlwaysStoppedAnimation<Color>(
                      //   CustomColors.accentLight,
                      // ),
                      ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      // backgroundColor: MaterialStateProperty.all(
                      //   CustomColors.accentLight,
                      // ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      widget.titleFocusNode.unfocus();
                      widget.descFocusNode.unfocus();
                      widget.addrFocusNode.unfocus();

                      if (_addItemFormKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });
                        DatabaseTest.nameSave = _titleCtl.text;
                        DatabaseTest.addrSave = _addrCtl.text;
                        DatabaseTest.descSave = _descCtl.text;
                        DatabaseTest.startSave = selectedDateStart;
                        DatabaseTest.endSave = selectedDateEnd;
                        DatabaseTest.timeStartSave = selectedTimeStart;
                        DatabaseTest.timeEndSave = selectedTimeEnd;

                        String start =
                            "${selectedDateStart.toLocal().toString().split(" ").first}T${selectedTimeStart.format(context)}:00";
                        String end =
                            "${selectedDateEnd.toLocal().toString().split(" ").first}T${selectedTimeEnd.format(context)}:00";
                        debugPrint("start " + DateTime.parse(start).toString());
                        debugPrint("end " + DateTime.parse(end).toString());
                        //debugPrint(slcTStart.format(context));
                        if (DatabaseTest.listHoursStart.isNotEmpty)
                          DatabaseTest.listHoursStart.clear();
                          DatabaseTest.listHoursStart
                              .add(DateTime.parse(start));
                        if (DatabaseTest.listHoursEnd.isNotEmpty)
                          DatabaseTest.listHoursEnd.clear();
                          DatabaseTest.listHoursEnd.add(DateTime.parse(end));

                        /*debugPrint(
                            "Change page " + selectedDateStart.toString());
                        debugPrint(selectedDateEnd.toString());
                        debugPrint(selectedTimeStart.format(context));
                        debugPrint(selectedTimeEnd.format(context));*/

                        /*await Database.addItem(
                          title: _titleCtl.text,
                          description: _descCtl.text,
                          address: _addrCtl.text,
                          //start: DateTime.fromMicrosecondsSinceEpoch(DateTime.parse(startDate! + "T" + startTime!).microsecondsSinceEpoch),
                          //end: DateTime.fromMicrosecondsSinceEpoch(DateTime.parse(endDate! + "T" + endTime!).microsecondsSinceEpoch),
                          //limit: DateTime.fromMicrosecondsSinceEpoch(DateTime.parse(limitDate! + "T" + limitTime!).microsecondsSinceEpoch),
                          //start: DateTime.parse(startDate! + " " + startTime!),
                          //end: DateTime.parse(endDate! + " " + endTime!),

                          start: DateTime.parse(DateTime.now().toString()),
                          end: DateTime.parse(DateTime.now().toString()),
                        );*/

                        setState(() {
                          _isProcessing = false;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupScreen()));
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'Suivant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget dateTime(DateTime dateInit, TimeOfDay timeInit, bool start) {
    return Row(
      children: [
        const Icon(Icons.calendar_today),
        TextButton(
            onPressed: () {
              _selectDate(context, dateInit, start);
              setState(() {});
              //showDatePicker(context, dateInit,timeInit);
            },
            child: Container(
                width: 150,
                alignment: Alignment.centerRight,
                child: //Text(displayDate(dateInit))
                    Text(start ? startDate! : endDate!))),
        TextButton(
            onPressed: () {
              _selectTime(context, timeInit, start);
              setState(() {});
            },
            child: Container(
                alignment: Alignment.centerLeft,
                child: //Text(displayTime(timeInit))
                    Text(start ? startTime! : endTime!)))
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

  _selectDate(BuildContext context, DateTime dateTimeInit, bool start) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('fr', ''),
      context: context,
      initialDate: dateTimeInit,
      //bloquer la date entre firstDate et lastDate
      firstDate: DateTime.now(),
      lastDate: DateTime(2099),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (selected != null && selected != dateTimeInit) {
      setState(() {
        dateTimeInit = selected;
        if (start) {
          if (selectedDateEnd.day == selectedDateStart.day &&
              selectedDateEnd.month == selectedDateStart.month) {
            selectedDateStart = selected;
            selectedDateEnd = selectedDateStart;
            endDate = displayDate(selectedDateEnd);
          }

          /*if(selectedDateEnd.day < selectedDateStart.day && selectedDateEnd.month == selectedDateStart.month ){
            selectedDateEnd = dateTimeInit;
            endDate = displayDate(selectedDateEnd);
            debugPrint("Start: $selectedDateStart");
            debugPrint("End: $selectedDateEnd");
          }*/

        } else {
          selectedDateEnd = dateTimeInit;
          if (selectedDateEnd.day < selectedDateStart.day &&
              selectedDateEnd.month == selectedDateStart.month) {
            selectedDateStart = selectedDateEnd;
            startDate = displayDate(dateTimeInit);
          }
        }
        debugPrint("Start: $selectedDateStart");
        debugPrint("End: $selectedDateEnd");
        start
            ? startDate = displayDate(dateTimeInit)
            : endDate = displayDate(dateTimeInit);
      });
    }
  }

  _selectTime(BuildContext context, TimeOfDay todInit, bool start) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: todInit.hour, minute: 00),
      //initialTime:  todInit,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        //return child!;
        return Localizations.override(
          context: context,
          locale: const Locale('fr', 'FR'),
          child: child,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != todInit) {
      setState(() {
        todInit = timeOfDay;
        //pour l'heure début
        if (start) {
          selectedTimeStart = todInit;
          selectedTimeEnd =
              TimeOfDay(hour: todInit.hour + 1, minute: todInit.minute);
          debugPrint(selectedTimeEnd.hour.toString());
          if (selectedTimeEnd.hour > 23) {
            selectedDateEnd = DateTime(selectedDateEnd.year,
                selectedDateEnd.month, selectedDateEnd.day + 1);
            endDate = displayDate(selectedDateEnd);
          }
          endTime = displayTime(selectedTimeEnd);
          debugPrint(start.toString());
        }
        //pour l'heure fin
        else {
          selectedTimeEnd = todInit;
          if (todInit.hour <= selectedTimeStart.hour &&
              selectedDateStart.day == selectedDateEnd.day) {
            selectedTimeStart =
                TimeOfDay(hour: todInit.hour - 1, minute: todInit.minute);
            debugPrint("qsd" + selectedTimeStart.hour.toString());
            if (selectedTimeStart.hour == -1) {
              selectedDateStart = DateTime(selectedDateStart.year,
                  selectedDateStart.month, selectedDateStart.day - 1);
              selectedTimeStart =
                  TimeOfDay(hour: 23, minute: selectedTimeEnd.minute);
              startDate = displayDate(selectedDateStart);
            }
            startTime = displayTime(selectedTimeStart);
          }
        }
        debugPrint("Start $selectedTimeStart");
        debugPrint("End $selectedTimeEnd");
        //pour les afficher
        start
            ? startTime = displayTime(todInit)
            : endTime = displayTime(todInit);

        //debugPrint(timeOfDay.format(context));
      });
    }
  }
}
