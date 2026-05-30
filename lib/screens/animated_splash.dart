import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class AnimatedSplash extends StatefulWidget {
  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    scaleAnimation = Tween<double>(begin: 0.6, end: 1).animate(controller);

    controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

        child: Center(
          child: AnimatedBuilder(
            animation: controller,

            builder: (context, child) {
              return Opacity(
                opacity: fadeAnimation.value,

                child: Transform.scale(
                  scale: scaleAnimation.value,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // LOGO
                      Image.asset("assets/images/logo.png", height: 120),

                      SizedBox(height: 20),

                      // APP NAME ANIMATION
                      Text(
                        "Lumina AI",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Imagine • Create • Generate",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
