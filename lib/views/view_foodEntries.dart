import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptal_calories_app/utils_date.dart';
import '../data/data_model.dart';
import 'dialog_create_foodEntries.dart';
import '../models/FoodEntry.dart';

import "package:collection/collection.dart";

class ViewFoodEntries extends StatelessWidget {
  const ViewFoodEntries(
      {required this.caloriesLimit,
      this.priceLimit = 1000,
      required this.foodEntries});

  final List<FoodEntry> foodEntries;
  final int caloriesLimit;
  final double priceLimit;

  @override
  Widget build(BuildContext context) {
    Map<String, List<FoodEntry>> groupByDate = groupBy(foodEntries,
        (FoodEntry foodEntry) => foodEntry.date.toString().substring(0, 10));

    List<String> keys = groupByDate.keys.toList();

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: keys.length,
        itemBuilder: (BuildContext context, int index) {
          // For Every DateGroup (foodEntries grouped by same day)

          List<FoodEntry> curFoodEntryGroup = groupByDate[keys[index]]!;

          String dateHeaderString = UtilsDate.dateFormat
              .format(curFoodEntryGroup[0].date.getDateTimeInUtc());

          int calorieSum = 0;
          double priceSum = 0;
          for (var element in curFoodEntryGroup) {
            calorieSum += element.calories;
            priceSum += element.price ?? 0;
          }

          bool isOverCalorieLimit = caloriesLimit < calorieSum;
          bool isOverPriceLimit = priceLimit < priceSum;

          return Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Card(
                    color: (isOverCalorieLimit || isOverPriceLimit)
                        ? Colors.red
                        : Colors.blue,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Text(dateHeaderString,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          isOverCalorieLimit
                              ? const Text("Over Calorie Limit",
                                  style: TextStyle(
                                      color: Colors.amberAccent, fontSize: 12))
                              : const Text("Within Calorie Limit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                          isOverPriceLimit
                              ? const Text("Over Price Limit",
                                  style: TextStyle(
                                      color: Colors.amberAccent, fontSize: 12))
                              : const Text("Within Price Limit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                        ]))),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: curFoodEntryGroup.length,
                    itemBuilder: (BuildContext context, int index) {
                      // For every FoodEntry within DateGroup

                      FoodEntry curFoodEntry = curFoodEntryGroup[index];

                      String timeString = UtilsDate.timeFormat
                          .format(curFoodEntry.date.getDateTimeInUtc());

                      return Card(
                          child: ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => DialogModifyFoodEntries(
                                          foodEntry: curFoodEntry,
                                        ));
                              },
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(curFoodEntry.name),
                                    Text(timeString,
                                        style: const TextStyle(
                                            color: Colors.blueGrey)),
                                  ]),
                              subtitle: Column(
                                children: [
                                  Text("${curFoodEntry.calories} calories"),
                                  Text("\$${curFoodEntry.price ?? 0}"),
                                ],
                              ),
                              trailing: Consumer<DataModel>(
                                  builder: (context, data, child) {
                                return IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    data.deleteFoodEntry(curFoodEntry);
                                  },
                                );
                              })));
                    })
              ]));
        });
  }
}
