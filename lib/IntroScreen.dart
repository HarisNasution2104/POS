import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> introData = [
    {
      "image": "assets/Lottiefiles/Intro1.json",
      "title": "Welcome to POS App",
      "desc": "Make your business easier by using KasIN",
    },
    {
      "image": "assets/Lottiefiles/Intro2.json",
      "title": "Management",
      "desc": "Manage your product status in real-time.",
    },
    {
      "image": "assets/Lottiefiles/Intro3.json",
      "title": "Finances",
      "desc": "Take control of your store's finances.",
    },
  ];

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntro', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildPage(Map<String, String> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(data["image"]!, height: 250),
        const SizedBox(height: 30),
        Text(
          data["title"]!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
          child: Text(
            data["desc"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: introData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (_, index) => _buildPage(introData[index]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              introData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child:
                _currentPage == introData.length - 1
                    ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _finishIntro,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE76F51),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _controller.animateToPage(
                              introData.length - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE76F51),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
