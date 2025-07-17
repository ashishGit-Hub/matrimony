import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/login_module/view/login_screen.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding 1 1.png',
      'title': 'Find Your Match',
      'desc': 'Discover people who share your values.',
    },
    {
      'image': 'assets/images/onboarding 2 1.png',
      'title': 'Trusted & Secure',
      'desc': 'Your information is safe with us.',
    },
    {
      'image': 'assets/images/onboarding 3 1.png',
      'title': 'Start a New Journey',
      'desc': 'Build meaningful connections today.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[index]['image']!, height: 300),
                    SizedBox(height: 30),
                    Text(
                      onboardingData[index]['title']!,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        onboardingData[index]['desc']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => buildDot(index),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == onboardingData.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              } else {
                _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 45),
              backgroundColor: Colors.deepPurple,
            ),
            child: Text(_currentPage == 2 ? 'Get Started' : 'Next',style: TextStyle(color: Colors.white),),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 4),
      duration: Duration(milliseconds: 200),
      width: _currentPage == index ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.deepPurple : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
