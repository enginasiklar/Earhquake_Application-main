
import '../services/api_service.dart'; // Add this import

class FollowedEarthquakeItem {
  String title;
  String code;
  double? limitValue;
  FollowedEarthquakeItem(this.code, this.title, this.limitValue) {
    limitValue ??= 1;
  }

  static Future<List<FollowedEarthquakeItem>> getNotifications() async {
    final apiService = ApiService();
    final stationList = await getStationNames(); // Fetch stations from the API
    List<FollowedEarthquakeItem> notif = [];
    for (Stations element in stationList) {
      //TODO: the magnitude is random, to be changed into a real value
      notif.add(FollowedEarthquakeItem(element.ticker, element.name, null));
    }
    return notif;
  }
}
