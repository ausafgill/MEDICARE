import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/models/onboarding_model.dart';
import 'package:medicare/features/auth/screens/login_screen.dart';

class OnboardingScreens extends StatefulWidget {
  static const routeName = '/onboarding-screen';
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  PageController _controller = PageController();
  List<OnboardingModel> obData = OnboardingModel.list;
  int currIndex = 0;

  Container buildDots(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color:
            currIndex == index ? EColors.primaryColor : const Color(0xff696974),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (int index) {
                setState(() {
                  currIndex = index;
                });
              },
              itemCount: obData.length,
              itemBuilder: (_, index) {
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(obData[index].img),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            obData[index].des,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: EColors.dark,
                              height: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              obData.length, (index) => buildDots(index)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
            child: InkWell(
              onTap: () {
                if (currIndex < obData.length - 1) {
                  _controller.nextPage(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                } else {
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(color: EColors.primaryColor),
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
