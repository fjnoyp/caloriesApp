import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptal_calories_app/pages/page_admin_home.dart';
import 'package:toptal_calories_app/pages/page_user_home.dart';

import 'data/data_model.dart';
import 'models/User.dart';

DataModel dataModel = DataModel();

void main() {
  runApp(ChangeNotifierProvider<DataModel>.value(
      value: dataModel, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    dataModel.initialize();
  }

  Widget showHomePage() {
    bool isReady = context.select<DataModel, bool>((dataModel) {
      return dataModel.isReady;
    });
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    User currentUser = context.select<DataModel, User>((dataModel) {
      return dataModel.currentUser;
    });
    return (currentUser.isAdmin ?? false)
        ? const PageAdminHome()
        : const PageUserHome();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            builder: Authenticator.builder(),
            home: SafeArea(child: showHomePage())));
  }
}
