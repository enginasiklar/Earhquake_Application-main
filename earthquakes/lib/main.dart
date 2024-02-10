import 'package:earthquakes/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:earthquakes/notifications/followed_earthquake_list_view.dart';
import 'package:earthquakes/notifications/followed_earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:earthquakes/pages/home_page.dart';
import 'package:earthquakes/pages/search_page.dart';
import 'package:earthquakes/pages/profile_page.dart';
import 'package:earthquakes/pages/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => FollowedEarthquakeModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> hasCompletedOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('completedOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earthquake Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: hasCompletedOnboarding(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while waiting for SharedPreferences
          } else {
            if (snapshot.data!) {
              return const RootPage(userName: 'Test');
            } else {
              return const OnboardingScreen();
            }
          }
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.userName});
  final String appTitle = 'Earthquake Predictions';
  static String title = "/root";
  final String userName;
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [const HomePage(), ProfilePage(userName: widget.userName)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              tooltip: "Notifications",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const FollowedEarthquakeListView();
                }));
              },
              icon: const Icon(Icons.notifications)),
          IconButton(
              tooltip: "search",
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const SearchViewPage();
                }));
              },
              icon: const Icon(Icons.search))
        ],
        title: Text(widget.appTitle),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        height: 55,
      ),
    );
  }
}
