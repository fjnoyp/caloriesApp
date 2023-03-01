import 'dart:collection';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptal_calories_app/utils_date.dart';

import '../data/data_model.dart';

import '../models/User.dart';
import '../views/button_create_foodEntry.dart';
import '../views/view_filterableListView.dart';

class PageAdminHome extends StatefulWidget {
  const PageAdminHome({Key? key}) : super(key: key);

  @override
  _PageAdminHomeState createState() => _PageAdminHomeState();
}

class _PageAdminHomeState extends State<PageAdminHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: const Text("Calories App"),
                actions: [
                  ElevatedButton(
                      onPressed: () => Amplify.Auth.signOut(),
                      child: Text("Sign out"))
                ],
                bottom: const TabBar(tabs: [
                  Tab(child: Text("All")),
                  Tab(child: Text("Reports"))
                ])),
            body: TabBarView(children: [
              Center(
                child: ViewFilterableFoodEntries(),
              ),
              Report()
            ]),
            floatingActionButton: ButtonCreateFoodEntry()));
  }
}

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, data, child) {
      /// Calculate report statistics
      /// This can be moved to an AWS lambda so it isn't calculated on client side
      DateTime today = DateUtils.dateOnly(DateTime.now());

      Duration weekDuration = const Duration(days: 7);
      Duration twoWeekDuration = const Duration(days: 14);

      int numWeekEntries = 0;
      int numTwoWeekEntries = 0;

      int totalCalories = 0;
      final uniqueUsers = HashSet<User>();

      for (var foodEntry in data.foodEntries) {
        DateTime date = DateUtils.dateOnly(foodEntry.date.getDateTimeInUtc());
        Duration diff = today.difference(date);

        if (diff < twoWeekDuration) {
          numTwoWeekEntries++;
          if (diff < weekDuration) {
            numWeekEntries++;

            totalCalories += foodEntry.calories;
            uniqueUsers.add(foodEntry.user);
          }
        }
      }

      numTwoWeekEntries -= numWeekEntries;
      double averageCaloriesPerUser = totalCalories / uniqueUsers.length;

      return Center(
        child: ListView(
          children: [
            Card(
                color: Colors.blue,
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            UtilsDate.dateFormat.format(today))))),
            Card(
                child: ListTile(
                    title:
                        Text("New entries in last 7 days: $numWeekEntries"))),
            Card(
                child: ListTile(
                    title: Text(
                        "New entries in 7 day prior period: $numTwoWeekEntries"))),
            Card(
                child: ListTile(
                    title: Text(
                        "Average calories/user in last 7 days: $averageCaloriesPerUser"))),
          ],
        ),
      );
    });
  }
}
