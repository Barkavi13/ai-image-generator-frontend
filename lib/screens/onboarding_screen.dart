import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF312E81)],
          ),
        ),

        child: Padding(
          padding: EdgeInsets.only(bottom: 80),

          child: PageView(
            controller: controller,

            onPageChanged: (index) {
              setState(() {
                lastPage = (index == 2);
              });
            },

            children: [
              buildPage(
                Icons.auto_awesome,
                "Generate AI Images",
                "Transform imagination into artwork instantly",
              ),

              buildPage(
                Icons.download,
                "Save Your Creations",
                "Store and access your AI images anytime",
              ),

              buildPage(
                Icons.psychology,
                "Smart AI Experience",
                "Create powerful visuals with AI assistance",
              ),
            ],
          ),
        ),
      ),

      bottomSheet: lastPage
          ? Container(
              color: Color(0xFF312E81),

              height: 80,

              child: Center(
                child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    await prefs.setBool("onboarding_done", true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },

                  child: Text(
                    "Get Started",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              color: Color(0xFF312E81),

              padding: EdgeInsets.symmetric(horizontal: 20),

              height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    },

                    child: Text("Skip", style: TextStyle(color: Colors.white)),
                  ),

                  SmoothPageIndicator(
                    controller: controller,

                    count: 3,

                    effect: WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.white,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },

                    child: Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage(IconData icon, String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Icon(icon, size: 120, color: Colors.white),

        SizedBox(height: 40),

        Text(
          title,

          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 20),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),

          child: Text(
            subtitle,

            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
