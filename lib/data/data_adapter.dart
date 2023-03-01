import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

/// Presents a storage agnostic API for interacting with Amplify AWS cloud functions
/// In the future this can become an abstract class, and the implementation can reside in a separate AmplifyDataAdapter
class DataAdapter {
  late StreamSubscription hubSubscription;

  /// Configure Amplify plugins
  Future<void> configure() async {
    try {
      await Amplify.addPlugins([
        AmplifyDataStore(
          modelProvider: ModelProvider.instance,
        ),
        AmplifyAPI(),
        AmplifyAuthCognito()
      ]);
      await Amplify.configure(amplifyconfig);
      await Amplify.DataStore.start();
    } on AmplifyAlreadyConfiguredException {
      print(
          'Amplify was already configured. Looks like app restarted on android.');
    }
  }

  /// Handle the retrieval of `User` model of Auth signed in user
  void handleRetrieveUsers(Function(List<User>) onUsersRetrieved) {
    // Listen for user sign in to retrieve user
    hubSubscription =
        Amplify.Hub.listen([HubChannel.DataStore], (hubEvent) async {
      print("DS Hub Event: " + hubEvent.eventName);

      if (hubEvent.eventName == 'ready') {
        onUsersRetrieved(await retrieveUsers());
      }
    });
  }

  Future<String> getCurrentUserAttribute() async {
    return (await Amplify.Auth.getCurrentUser()).userId;
  }

  Future<List<User>> retrieveUsers() async {
    return await Amplify.DataStore.query(User.classType);
  }

  Future<void> saveUser(User user) async {
    return await Amplify.DataStore.save(user);
  }

  void observeFoodEntries(
      User user, Function(List<FoodEntry>) onFoodEntriesUpdated) async {
    Amplify.DataStore.observeQuery(
      FoodEntry.classType,
    ).listen((QuerySnapshot<FoodEntry> snapshot) {
      /// User access rules limit which FoodEntry are returned based on signed in user
      if (user.isAdmin ?? false) {
        return onFoodEntriesUpdated(snapshot.items);
      } else {
        return onFoodEntriesUpdated(List.from(snapshot.items
            .where((element) => element.user.authUserID == user.authUserID)));
      }
    });
  }

  Future<List<FoodEntry>> queryFoodEntries(User user) async {
    List<FoodEntry> foodEntries =
        await Amplify.DataStore.query(FoodEntry.classType);
    if (user.isAdmin ?? false) {
      return foodEntries;
    } else {
      return List.from(foodEntries
          .where((element) => element.user.authUserID == user.authUserID));
    }
  }

  Future<List<User>> getUsers() async {
    return Amplify.DataStore.query(User.classType);
  }

  Future<void> saveFoodEntry(FoodEntry foodEntry) async {
    await Amplify.DataStore.save(foodEntry);
  }

  Future<void> deleteFoodEntry(FoodEntry foodEntry) async {
    await Amplify.DataStore.delete(foodEntry);
  }
}
