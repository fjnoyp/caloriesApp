import 'package:flutter/material.dart';
import 'package:toptal_calories_app/utils_date.dart';

class ViewDatePickerButton extends StatelessWidget {
  const ViewDatePickerButton(
      {Key? key,
      this.dateValidator,
      this.onValidationFailText = "Please select another date",
      required this.onDateSelected,
      required this.selectedDateTime})
      : super(key: key);

  final bool Function(DateTime)? dateValidator;
  final String onValidationFailText;
  final Function(DateTime) onDateSelected;
  final DateTime selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(UtilsDate.dateFormat.format(selectedDateTime)),
        onPressed: () async {
          DateTime? newDateTime = await showDatePicker(
              context: context,
              initialDate: selectedDateTime,
              firstDate: UtilsDate.earliestDate,
              lastDate: UtilsDate.latestDate);

          if (newDateTime != null) {
            // custom validation

            if (dateValidator != null && dateValidator!(newDateTime)) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Invalid Date Selected"),
                      content: Text(onValidationFailText),
                    );
                  });
              return;
            }
            onDateSelected(newDateTime);
          }
        });
  }
}
