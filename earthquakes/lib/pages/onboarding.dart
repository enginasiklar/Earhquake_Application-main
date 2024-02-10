import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '/../main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completedOnboarding', true);
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Welcome to Earthquake Predictor",
        body:
            "This app will help you predict and track earthquakes in your area.",
        image: const Center(
          child: Icon(Icons.waving_hand, size: 50.0),
        ),
      ),
      PageViewModel(
        title: "Follow Earthquakes",
        body:
            "You can follow specific earthquakes to receive updates and notifications.",
        image: const Center(
          child: Icon(Icons.notifications, size: 50.0),
        ),
      ),
      PageViewModel(
        title: "Search Earthquakes",
        body: "Find earthquakes by location, magnitude, and more.",
        image: const Center(
          child: Icon(Icons.search, size: 50.0),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPages(),
      done: const Text("Done"),
      onDone: () async {
        await completeOnboarding();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootPage(userName: 'Test')),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      onSkip: () async {
        await completeOnboarding();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootPage(userName: 'Test')),
        );
      },
      next: const Text("Next"), // Add this line
    );
  }
}
