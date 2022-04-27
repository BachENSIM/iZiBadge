import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/custom_form_field.dart';
import 'package:izibagde/model/database.dart';
import 'package:izibagde/model/validator.dart';

class EditItemForm extends StatefulWidget {
  //const EditItemForm({Key? key}) : super(key: key);

  late final FocusNode titleFocusNode;
  late final FocusNode descFocusNode;
  late final FocusNode addrFocusNode;
  late final String currTitle;
  late final String currDesc;
  late final String currAddr;
  late final String documentId;

  /*late final DateTime currStartDate;
  late final String currStartTime;
  late final String currEndDate;
  late final String currEndTime;
  late final String currLimitDate;
  late final String currLimitTime;
  */

  EditItemForm({
    required this.titleFocusNode,
    required this.descFocusNode,
    required this.addrFocusNode,
    required this.currTitle,
    required this.currDesc,
    required this.currAddr,
    //required this.currStartDate,
    required this.documentId,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

late String? startDate;
late String? startTime;
late String? endDate;
late String? endTime;
late String? limitDate;
late String? limitTime;

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  late TextEditingController _titleCtl;
  late TextEditingController _descCtl;
  late TextEditingController _addrCtl;
  /*late Text _startDateCtl;
  late Text _endDateCtl;
  late Text _limitDateCtl;
  late Text _startTimeCtl;
  late Text _endTimeCtl;
  late Text _limitTimeCtl;*/

  //for create date and hours of event
  /*DateTime selectedDateStart = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  DateTime selectedDateEnd = DateTime.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();
  DateTime selectedDateLimit = DateTime.now();
  TimeOfDay selectedTimeLimit = TimeOfDay.now();*/

  @override
  void initState() {
    // TODO: implement initState
    _titleCtl = TextEditingController(text: widget.currTitle);
    _descCtl = TextEditingController(text: widget.currDesc);
    _addrCtl = TextEditingController(text: widget.currAddr);
    // _startDateCtl = Text(widget.currStartDate.toString());
    /*_startTimeCtl = Text(widget.currStartTime);
    _endDateCtl = Text(widget.currEndDate);
    _endTimeCtl = Text(widget.currEndTime);
    _limitTimeCtl = Text(widget.currLimitDate);
    _limitTimeCtl = Text(widget.currLimitTime);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _editItemFormKey,
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
                  const SizedBox(height: 12.0), //invisible box
                  const Text(
                    'Title',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
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
                    hint: 'Enter your title of this event',
                  ),
                  SizedBox(height: 24.0),
                  const Text(
                    'Description',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 5,
                    isLabelEnabled: false,
                    controller: _descCtl,
                    focusNode: widget.descFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Description',
                    hint: 'Enter your description of this event',
                  ),
                  SizedBox(height: 24.0),
                  const Text(
                    'Address',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 3,
                    isLabelEnabled: false,
                    controller: _addrCtl,
                    focusNode: widget.addrFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Address',
                    hint: 'Enter your address of this event',
                  ),
                  /*const SizedBox(height: 24.0),
                  Text(
                    'Start Date',
                    style: TextStyle(
                      color: CustomColors.primaryText,
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
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.calendar_today_rounded,
                                color: CustomColors.accentDark,
                                size: 32.0,
                              ),
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_startDateCtl.toString()
                          //"${selectedDateStart.day}/${selectedDateStart.month}/${selectedDateStart.year}"
                          ),
                      const SizedBox(width: 30.0),
                      ElevatedButton(
                          onPressed: () {
                            _selectTimeStart(context);
                          },
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.timer_rounded,
                                color: Colors.CustomColors.accentDark,
                                size: 32.0,
                              ),
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_startTimeCtl.toString()
                          //"${selectedTimeStart.hour}:${selectedTimeStart.minute}"
                          ),
                    ],
                  ),*/
                  /*const SizedBox(height: 24.0),
                  Text(
                    'End Date',
                    style: TextStyle(
                      color: CustomColors.primaryText,
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
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.calendar_today_rounded,
                                color: CustomColors.accentDark,
                                size: 32.0,
                              ),
                              //Text("Click me!", style:TextStyle(fontSize:20)),
                              //Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_endDateCtl.toString()
                          //"${selectedDateEnd.day}/${selectedDateEnd.month}/${selectedDateEnd.year}"
                          ),
                      const SizedBox(width: 30.0),
                      ElevatedButton(
                          onPressed: () {
                            _selectTimeEnd(context);
                          },
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.timer_rounded,
                                color: CustomColors.accentDark,
                                size: 32.0,
                              ),
                              //Text("Click me!", style:TextStyle(fontSize:20)),
                              //Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_endTimeCtl.toString()
                          //"${selectedTimeEnd.hour}:${selectedTimeEnd.minute}"
                          ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Limit Date',
                    style: TextStyle(
                      color: CustomColors.primaryText,
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
                            _selectDateLimit(context);
                          },
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.calendar_today_rounded,
                                color: CustomColors.accentDark,
                                size: 32.0,
                              ),
                              //Text("Click me!", style:TextStyle(fontSize:20)),
                              //Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_limitDateCtl.toString()
                          //"${selectedDateLimit.day}/${selectedDateLimit.month}/${selectedDateLimit.year}"
                          ),
                      const SizedBox(width: 30.0),
                      ElevatedButton(
                          onPressed: () {
                            _selectTimeLimit(context);
                          },
                          child: Wrap(
                            children: const <Widget>[
                              Icon(
                                Icons.timer_rounded,
                                color: CustomColors.accentDark,
                                size: 32.0,
                              ),
                              //Text("Click me!", style:TextStyle(fontSize:20)),
                              //Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                            ],
                          )),
                      const SizedBox(width: 10.0),
                      Text(_limitTimeCtl.toString()
                          //"${selectedTimeLimit.hour}:${selectedTimeLimit.minute}"
                          ),
                    ],
                  )*/
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

                        if (_editItemFormKey.currentState!.validate()) {
                          setState(() {
                            //print("1" + _isProcessing.toString());
                            print("ID: " + widget.documentId.toString());

                            _isProcessing = true;
                          });

                          await Database.updateItem(
                            docId: widget.documentId,
                            title: _titleCtl.text,
                            description: _descCtl.text,
                            address: _addrCtl.text,
                          );

                          setState(() {
                            //print("2" + _isProcessing.toString());
                            _isProcessing = false;
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'UPDATE ITEM',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            //color: CustomColors.textPrimary,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }

  /*_selectDateStart(BuildContext context) async {
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
        _startDateCtl = startDate as Text;
        print("StartDate: " + startDate! + " " + startTime!);

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
        print("StartDate: " + startDate! + " " + startTime!);
        print((DateTime.parse(startDate! + " " + startTime!)));
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
        print("EndDate: " + endDate! + " " + endTime!);
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
        print("EndDate: " + endDate! + " " + endTime!);
      });
    }
  }

  _selectDateLimit(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateLimit,
      firstDate: DateTime(1999),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != selectedDateLimit) {
      setState(() {
        selectedDateLimit = selected;
        //limitDate = selectedDateLimit.day.toString()+ "-" + selectedDateLimit.month.toString()  +"-"+selectedDateLimit.year.toString();
        if (selectedDateLimit.month < 10) {
          if (selectedDateLimit.day < 10) {
            limitDate = selectedDateLimit.year.toString() +
                "-0" +
                selectedDateLimit.month.toString() +
                "-0" +
                selectedDateLimit.day.toString();
          } else {
            limitDate = selectedDateLimit.year.toString() +
                "-0" +
                selectedDateLimit.month.toString() +
                "-" +
                selectedDateLimit.day.toString();
          }
        } else {
          limitDate = selectedDateLimit.year.toString() +
              "-" +
              selectedDateLimit.month.toString() +
              "-" +
              selectedDateLimit.day.toString();
        }
        print("LimitDate: " + limitDate! + " " + limitTime!);
      });
    }
  }

  _selectTimeLimit(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeLimit,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTimeLimit) {
      setState(() {
        selectedTimeLimit = timeOfDay;
        if (selectedTimeLimit.hour < 10) {
          if (selectedTimeLimit.minute < 10) {
            limitTime = "0" +
                selectedTimeLimit.hour.toString() +
                ":0" +
                selectedTimeLimit.minute.toString() +
                ":00.000";
          } else {
            limitTime = "0" +
                selectedTimeLimit.hour.toString() +
                ":" +
                selectedTimeLimit.minute.toString() +
                ":00.000";
          }
        } else {
          limitTime = selectedTimeLimit.hour.toString() +
              ":" +
              selectedTimeLimit.minute.toString() +
              ":00.000";
        }
        _limitTimeCtl = limitTime as Text;
        //limitTime = selectedTimeLimit.hour.toString() + ":" + selectedTimeLimit.minute.toString() + ":00";
        print("LimitDate: " + limitDate! + " " + limitTime!);
      });
    }
  }*/
}
