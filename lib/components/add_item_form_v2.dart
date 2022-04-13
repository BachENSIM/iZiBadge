
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/custom_form_field.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/model/validator.dart';
import 'package:izibagde/screens/add_group_screen.dart';



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

late String? startDate;
late String? startTime;
late String? endDate;
late String? endTime;

class _AddItemFormState extends State<AddItemForm> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  //for create date and hours of event
  DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  DateTime selectedDateEnd = DateTime.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();

  final TextEditingController _titleCtl = TextEditingController();
  final TextEditingController _descCtl = TextEditingController();
  final TextEditingController _addrCtl = TextEditingController();

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
                  'Title',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
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
                  label: 'Title',
                  hint: 'Enter a name of event',
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Description',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
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
                  hint: 'Enter a description for this event',
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Address',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
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
                  label: 'Address',
                  hint: 'Enter a address for this event',
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Start Date',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _selectDateStart(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(CustomColors.textSecondary)),
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today_rounded,
                              color: CustomColors.accentLight,
                              size: 32.0,
                            ),
                          ],
                        )),
                    const SizedBox(width: 10.0),
                    Text(
                        "${selectedDateStart.day}/${selectedDateStart.month}/${selectedDateStart.year}"),
                    const SizedBox(width: 30.0),
                    ElevatedButton(
                        onPressed: () {
                          _selectTimeStart(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(CustomColors.textSecondary)),
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              Icons.timer_rounded,
                              color: CustomColors.accentLight,
                              size: 32.0,
                            ),
                          ],
                        )),
                    const SizedBox(width: 10.0),
                    Text(
                        "${selectedTimeStart.hour}:${selectedTimeStart.minute}"),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'End Date',
                  style: TextStyle(
                    color: CustomColors.textPrimary,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _selectDateEnd(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(CustomColors.textSecondary)),
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today_rounded,
                              color: CustomColors.accentLight,
                              size: 32.0,
                            ),
                          ],
                        )),
                    const SizedBox(width: 10.0),
                    Text(
                        "${selectedDateEnd.day}/${selectedDateEnd.month}/${selectedDateEnd.year}"),
                    const SizedBox(width: 30.0),
                    ElevatedButton(
                        onPressed: () {
                          _selectTimeEnd(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(CustomColors.textSecondary)),
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              Icons.timer_rounded,
                              color: CustomColors.accentLight,
                              size: 32.0,
                            ),
                          ],
                        )),
                    const SizedBox(width: 10.0),
                    Text("${selectedTimeEnd.hour}:${selectedTimeEnd.minute}"),
                  ],
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
          _isProcessing
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.accentLight,
                    ),
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.accentLight,
                      ),
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
                        DatabaseTest.startSave = DateTime.parse(DateTime.now().toString());
                        DatabaseTest.endSave = DateTime.parse(DateTime.now().toString());
                        print( "T:[" + DatabaseTest.nameSave! + "]  A:[" +   DatabaseTest.addrSave! + "]  D:[" + DatabaseTest.descSave! + "]");

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
                        'Next',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _selectDateStart(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateStart,
      firstDate: DateTime(1999),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedDateStart) {
      setState(() {
        selectedDateStart = selected;
        //startDate = selectedDateStart.day.toString()+ "-" + selectedDateStart.month.toString()  +"-"+selectedDateStart.year.toString();
        if (selectedDateStart.month < 10) {
          if (selectedDateStart.day < 10) {
            startDate = selectedDateStart.year.toString() +
                "-0" +
                selectedDateStart.month.toString() +
                "-0" +
                selectedDateStart.day.toString();
          } else {
            startDate = selectedDateStart.year.toString() +
                "-0" +
                selectedDateStart.month.toString() +
                "-" +
                selectedDateStart.day.toString();
          }
        } else {
          startDate = selectedDateStart.year.toString() +
              "-" +
              selectedDateStart.month.toString() +
              "-" +
              selectedDateStart.day.toString();
        }
        //startDate = selectedDateStart.toString();
        //print("StartDate: " + startDate! + " " + startTime!);

        //print((DateTime.parse(startDate!)) );
        //print((DateTime.parse(selectedDateStart.toString())) );
      });
    }
  }

  _selectTimeStart(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeStart,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTimeStart) {
      setState(() {
        selectedTimeStart = timeOfDay;
        if (selectedTimeStart.hour < 10) {
          if (selectedTimeStart.minute < 10) {
            startTime = "0" +
                selectedTimeStart.hour.toString() +
                ":0" +
                selectedTimeStart.minute.toString() +
                ":00.000";
          } else {
            startTime = "0" +
                selectedTimeStart.hour.toString() +
                ":" +
                selectedTimeStart.minute.toString() +
                ":00.000";
          }
        } else {
          startTime = selectedTimeStart.hour.toString() +
              ":" +
              selectedTimeStart.minute.toString() +
              ":00.000";
        }

        //startTime = selectedTimeStart.hour.toString() + ":" + selectedTimeStart.minute.toString() + ":00";
        //print("StartDate: " + startDate! + " " + startTime!);
        //print((DateTime.parse(startDate! + " " + startTime!)));
      });
    }
  }

  _selectDateEnd(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd,
      firstDate: DateTime(1999),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedDateEnd) {
      setState(() {
        selectedDateEnd = selected;
        //endDate = selectedDateEnd.day.toString()+ "-" + selectedDateEnd.month.toString()  +"-"+selectedDateEnd.year.toString();
        if (selectedDateEnd.month < 10) {
          if (selectedDateEnd.day < 10) {
            endDate = selectedDateEnd.year.toString() +
                "-0" +
                selectedDateEnd.month.toString() +
                "-0" +
                selectedDateEnd.day.toString();
          } else {
            endDate = selectedDateEnd.year.toString() +
                "-0" +
                selectedDateEnd.month.toString() +
                "-" +
                selectedDateEnd.day.toString();
          }
        } else {
          endDate = selectedDateEnd.year.toString() +
              "-" +
              selectedDateEnd.month.toString() +
              "-" +
              selectedDateEnd.day.toString();
        }
        //print("EndDate: " + endDate! + " " + endTime!);
      });
    }
  }

  _selectTimeEnd(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeEnd,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTimeEnd) {
      setState(() {
        selectedTimeEnd = timeOfDay;
        //endTime = selectedTimeEnd.hour.toString() + ":" + selectedTimeEnd.minute.toString() + ":00";
        if (selectedTimeEnd.hour < 10) {
          if (selectedTimeEnd.minute < 10) {
            endTime = "0" +
                selectedTimeEnd.hour.toString() +
                ":0" +
                selectedTimeEnd.minute.toString() +
                ":00.000";
          } else {
            endTime = "0" +
                selectedTimeEnd.hour.toString() +
                ":" +
                selectedTimeEnd.minute.toString() +
                ":00.000";
          }
        } else {
          endTime = selectedTimeEnd.hour.toString() +
              ":" +
              selectedTimeEnd.minute.toString() +
              ":00.000";
        }
        //print("EndDate: " + endDate! + " " + endTime!);
      });
    }
  }
}
