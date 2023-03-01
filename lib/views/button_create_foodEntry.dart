import 'package:flutter/material.dart';

import 'dialog_create_foodEntries.dart';

class ButtonCreateFoodEntry extends StatelessWidget {
  const ButtonCreateFoodEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        child: const Text(
          "Create Food Entry",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => const DialogModifyFoodEntries());
        });
  }
}
