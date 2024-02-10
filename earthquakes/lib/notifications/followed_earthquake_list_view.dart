import 'dart:collection';
import 'dart:math';
import 'package:earthquakes/notifications/followed_earthquake_model.dart';
import 'package:earthquakes/notifications/following_setting_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/predict_line_chart_page.dart';
import 'followed_earthquake_item.dart';

class FollowedEarthquakeListView extends StatefulWidget {
  const FollowedEarthquakeListView({super.key});

  @override
  State<FollowedEarthquakeListView> createState() =>
      _FollowedEarthquakeListViewState();
}

class _FollowedEarthquakeListViewState
    extends State<FollowedEarthquakeListView> {
  // List<NotificationItem> notifications = NotificationItem.getNotifications();

  @override
  Widget build(BuildContext context) {
    UnmodifiableListView<FollowedEarthquakeItem> notificationModel =
        FollowedEarthquakeModel().items;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 0,
          title: const Text("Notifications"),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<FollowedEarthquakeModel>(context, listen: false)
                      .removeAll();
                },
                icon: const Icon(Icons.delete_forever_rounded))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.notifications),
                child: Text("Notifications"),
              ),
              Tab(
                icon: Icon(Icons.bar_chart_rounded),
                child: Text("Followed"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //TODO: this child has to be changed to the real notifications
            Consumer<FollowedEarthquakeModel>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: notificationModel.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      //TODO
                      leading: Random().nextBool()
                          ? Image.asset(
                              "assets/images/arrow_down.png",
                              height: 20,
                            )
                          : Image.asset(
                              "assets/images/arrow_up.png",
                              height: 20,
                            ),
                      title: Text(notificationModel[index].code),
                      subtitle: Text(notificationModel[index].title),
                      //TODO: add insted of limitValue, the real data of today
                      trailing: Text("${notificationModel[index].limitValue}"),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          // return const stockPage();
                          return PredictLineDataPage(
                            key: null,
                            stationCode: notificationModel[index].code,
                            stationName: notificationModel[index].title,
                          );
                        }));
                      },
                      onLongPress: () {
                        Provider.of<FollowedEarthquakeModel>(context,
                                listen: false)
                            .remove(notificationModel[index].code);
                      },
                    );
                  },
                );
              },
            ),
            Consumer<FollowedEarthquakeModel>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: notificationModel.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      //TODO
                      leading: Random().nextBool()
                          ? Image.asset(
                              "assets/images/arrow_down.png",
                              height: 20,
                            )
                          : Image.asset(
                              "assets/images/arrow_up.png",
                              height: 20,
                            ),
                      title: Text(notificationModel[index].code),
                      subtitle: Text(notificationModel[index].title),
                      trailing: IconButton(
                          onPressed: () {
                            FollowingSettingView.showAlertDialog(
                                context,
                                notificationModel[index].title,
                                notificationModel[index].code);
                          },
                          icon: const Icon(Icons.settings)),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          // return const stockPage();
                          return PredictLineDataPage(
                            key: null,
                            stationCode: notificationModel[index].code,
                            stationName: notificationModel[index].title,
                          );
                        }));
                      },
                      onLongPress: () {
                        Provider.of<FollowedEarthquakeModel>(context,
                                listen: false)
                            .remove(notificationModel[index].code);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
