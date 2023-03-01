import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:toptal_calories_app/utils_date.dart';

import '../models/FoodEntry.dart';
import '../models/User.dart';
import 'data_adapter.dart';

/// Stores state that is consumed by widgets
/// Manages DataAdapter to interact with cloud data
class DataModel extends ChangeNotifier {
  late List<FoodEntry> _foodEntries = [];
  late List<FoodEntry> _filteredFoodEntries = [];

  late DateTime filterStartDate = UtilsDate.earliestDate;
  late DateTime filterEndDate = UtilsDate.latestDate;

  late User currentUser;

  bool isReady = false;

  UnmodifiableListView<FoodEntry> get foodEntries =>
      UnmodifiableListView(_foodEntries);
  UnmodifiableListView<FoodEntry> get filteredFoodEntries =>
      UnmodifiableListView(_filteredFoodEntries);

  final DataAdapter _dataAdapter = DataAdapter();

  DataModel();

  Future<void> initialize() async {
    await _dataAdapter.configure();

    /// Create/retrieve user data object based on current user
    /// Listen to foodEntry changes for current user
    _dataAdapter.handleRetrieveUsers((users) async {
      String curAuthUserId = await _dataAdapter.getCurrentUserAttribute();

      User? curUser;
      for (var user in users) {
        if (user.authUserID == curAuthUserId) {
          curUser = user;
        }
      }
      if (curUser == null) {
        curUser =
            User(authUserID: curAuthUserId, calorieLimit: 2100, isAdmin: false);
        await _dataAdapter.saveUser(curUser);
      }

      currentUser = curUser;
      isReady = true;
      notifyListeners();

      _dataAdapter.observeFoodEntries(currentUser,
          (List<FoodEntry> foodEntries) {
        _foodEntries = foodEntries;
        applyFilters(foodEntries);
      });
    });
  }

  void applyFilters(List<FoodEntry> foodEntries) {
    List<FoodEntry> newFilteredFoodEntries = foodEntries.where((foodEntry) {
      DateTime curDateTime =
          DateUtils.dateOnly(foodEntry.date.getDateTimeInUtc());
      return curDateTime.compareTo(filterStartDate) >= 0 &&
          curDateTime.compareTo(filterEndDate) <= 0;
    }).toList();

    _filteredFoodEntries = newFilteredFoodEntries;
    notifyListeners();
  }

  void setFilterStartDate(DateTime dateTime) {
    filterStartDate = dateTime;
    applyFilters(foodEntries);
  }

  void setFilterEndDate(DateTime dateTime) {
    filterEndDate = dateTime;
    applyFilters(foodEntries);
  }

  void addFoodEntry(FoodEntry foodEntry) {
    _dataAdapter.saveFoodEntry(foodEntry);
    applyFilters(_foodEntries);
  }

  void deleteFoodEntry(FoodEntry foodEntry) {
    _dataAdapter.deleteFoodEntry(foodEntry);
    applyFilters(_foodEntries);
  }
}
