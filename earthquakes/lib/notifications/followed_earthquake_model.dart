import 'dart:collection';
import 'package:earthquakes/notifications/followed_earthquake_item.dart';
import 'package:flutter/material.dart';

class FollowedEarthquakeModel extends ChangeNotifier {
  //TODO: the data has to be saved permanetelly somehow
  static final List<FollowedEarthquakeItem> _notifications = [];
  UnmodifiableListView<FollowedEarthquakeItem> get items =>
      UnmodifiableListView(_notifications);

  void add(FollowedEarthquakeItem notifications) {
    if (_notifications
            .indexWhere((element) => element.code == notifications.code) ==
        -1) {
      _notifications.add(notifications);
      notifyListeners();
    }
    // This call tells the widgets that are listening to this model to rebuild.
  }

  void remove(String stockCode) {
    _notifications.removeWhere((element) => element.code == stockCode);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _notifications.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool doesExist(String stockCode) {
    if (_notifications.indexWhere((element) => element.code == stockCode) ==
        -1) {
      return false;
    }
    return true;
  }

  void updateLimitValue(String stockCode, double newValue) {
    _notifications
        .where((element) => element.code == stockCode)
        .first
        .limitValue = newValue;
    notifyListeners();
  }

  void alterExistance(FollowedEarthquakeItem notifications) {
    if (doesExist(notifications.code)) {
      remove(notifications.code);
    } else {
      add(notifications);
    }
    notifyListeners();
  }
}
