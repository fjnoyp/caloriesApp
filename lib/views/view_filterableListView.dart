import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptal_calories_app/views/view_datePickerButton.dart';

import '../data/data_model.dart';
import '../views/view_foodEntries.dart';

class ViewFilterableFoodEntries extends StatelessWidget {
  const ViewFilterableFoodEntries({Key? key}) : super(key: key);

  Widget startDateFilter(DataModel data) {
    return ViewDatePickerButton(
      dateValidator: (newDateTime) {
        return newDateTime.compareTo(data.filterEndDate) > 0;
      },
      onValidationFailText: "Start Date must be before End Date!",
      onDateSelected: (newDateTime) {
        data.setFilterStartDate(newDateTime);
      },
      selectedDateTime: data.filterStartDate,
    );
  }

  Widget endDateFilter(DataModel data) {
    return ViewDatePickerButton(
      dateValidator: (newDateTime) {
        return newDateTime.compareTo(data.filterStartDate) < 0;
      },
      onValidationFailText: "End Date must be after Start Date!",
      onDateSelected: (newDateTime) {
        data.setFilterEndDate(newDateTime);
      },
      selectedDateTime: data.filterEndDate,
    );
  }

  Widget foodEntryList(DataModel data) {
    return ViewFoodEntries(
      caloriesLimit: data.currentUser.calorieLimit,
      foodEntries: data.filteredFoodEntries,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, data, child) {
      return Column(
        children: [
          Card(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [startDateFilter(data), endDateFilter(data)],
          )),
          Expanded(child: foodEntryList(data))
        ],
      );
    });
  }
}
