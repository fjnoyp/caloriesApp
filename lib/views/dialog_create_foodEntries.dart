import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toptal_calories_app/models/ModelProvider.dart';

import '../data/data_model.dart';

class DialogModifyFoodEntries extends StatefulWidget {
  final FoodEntry? foodEntry;

  const DialogModifyFoodEntries({super.key, this.foodEntry});

  @override
  DialogModifyFoodEntriesState createState() {
    return DialogModifyFoodEntriesState();
  }
}

class DialogModifyFoodEntriesState extends State<DialogModifyFoodEntries> {
  final _formKey = GlobalKey<FormState>();

  final DateFormat _dateFormat = DateFormat('MMM d');

  late String _name;
  late int _calories;
  late double _price;
  late DateTime _dateTime;
  late TimeOfDay _timeOfDay;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dateTime = DateUtils.dateOnly(DateTime.now());
      _timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        content: Stack(clipBehavior: Clip.none, children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        const Center(child: Text("Name: ")),
                        SizedBox(
                            height: 65,
                            child: TextFormField(
                              initialValue: widget.foodEntry?.name,
                              onSaved: (String? value) {
                                _name = value!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name';
                                }
                                return null;
                              },
                            ))
                      ],
                    ),
                    TableRow(children: [
                      const Center(child: Text("Calories: ")),
                      SizedBox(
                          height: 65,
                          child: TextFormField(
                            initialValue:
                                widget.foodEntry?.calories?.toString(),
                            onSaved: (String? value) {
                              _calories = int.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter calories';
                              }
                              final number = num.tryParse(value);

                              if (number == null) {
                                return 'Enter a valid number';
                              }

                              if (number != number.roundToDouble()) {
                                return 'Enter an integer';
                              }

                              return null;
                            },
                          ))
                    ]),
                    TableRow(children: [
                      const Center(child: Text("Price: ")),
                      SizedBox(
                          height: 65,
                          child: TextFormField(
                            initialValue:
                                widget.foodEntry?.price?.toString() ?? '0',
                            onSaved: (String? value) {
                              _price = double.parse(value!);
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter price';
                              }
                              final number = num.tryParse(value);

                              if (number == null) {
                                return 'Enter a valid number';
                              }

                              return null;
                            },
                          ))
                    ]),
                    TableRow(children: [
                      const Center(child: Text("Date: ")),
                      ElevatedButton(
                          child: Text(_dateFormat.format(_dateTime)),
                          onPressed: () async {
                            DateTime? newDateTime = await showDatePicker(
                              context: context,
                              initialDate: _dateTime,
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2025),
                            );

                            if (newDateTime != null) {
                              setState(() {
                                _dateTime = newDateTime;
                              });
                            }
                          })
                    ]),
                    TableRow(children: [
                      const Center(child: Text("Time: ")),
                      ElevatedButton(
                          child: Text(_timeOfDay.format(context)),
                          onPressed: () async {
                            TimeOfDay? newTimeOfDay = await showTimePicker(
                              context: context,
                              initialTime: _timeOfDay,
                            );

                            if (newTimeOfDay != null) {
                              setState(() {
                                _timeOfDay = newTimeOfDay;
                              });
                            }
                          })
                    ])
                  ],
                ),
                Consumer<DataModel>(builder: (context, data, child) {
                  User? saveUser = widget.foodEntry?.user;
                  saveUser ??= data.currentUser;

                  return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          DateTime selectedDateTime = _dateTime.add(Duration(
                              hours: _timeOfDay.hour,
                              minutes: _timeOfDay.minute));

                          if (DateTime.now().isBefore(selectedDateTime)) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("Invalid Date Selected"),
                                    content: Text(
                                        "Please select a time in the past "),
                                  );
                                });
                            return;
                          }

                          data.addFoodEntry(FoodEntry(
                              id: widget.foodEntry?.id,
                              date: TemporalDateTime(selectedDateTime),
                              name: _name,
                              calories: _calories,
                              price: _price,
                              user: saveUser!));

                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Submit"));
                })
              ],
            ),
          )
        ]));
  }
}
