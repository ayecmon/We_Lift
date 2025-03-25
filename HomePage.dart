import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'TimePage.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: AssetImage("assets/background.jpg") != null
              ? DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ... (Your animated logo)

              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: _controller.duration!,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, -20 * (1 - Curves.easeInOut.transform(value))),
                    child: child,
                  );
                },
                child: Image.asset(
                  "assets/logo.jpg",
                  height: 200,
                  width: 600,
                ),
              ),

              SizedBox(height: 50),
              Lottie.asset(
                'assets/timepageanimation.json',
                width: 150,
                height: 150,
                repeat: true,
              ),
              SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome to Workout Generator!',
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 100), // Adjust speed
                  ),
                ],
                totalRepeatCount: 20,
                pause: const Duration(milliseconds: 1000),
              ),

              SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimePage()),
                  );},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}