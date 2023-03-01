import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toptal_calories_app/views/button_create_foodEntry.dart';

import '../views/view_filterableListView.dart';

class PageUserHome extends StatefulWidget {
  const PageUserHome({Key? key}) : super(key: key);

  @override
  _PageUserHomeState createState() => _PageUserHomeState();
}

class _PageUserHomeState extends State<PageUserHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calories App"),
          actions: [
            ElevatedButton(
                onPressed: () => Amplify.Auth.signOut(),
                child: const Text("Sign out"))
          ],
        ),
        body: Center(
          child: ViewFilterableFoodEntries(),
        ),
        floatingActionButton: ButtonCreateFoodEntry());
  }
}
