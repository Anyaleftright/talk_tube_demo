import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:talk_tube/models/intro_model.dart';
import 'package:talk_tube/screens/number_screen.dart';
import 'package:talk_tube/widgets/intro_view.dart';

class IntroductionScreen extends StatelessWidget {
  IntroductionScreen({Key? key}) : super(key: key);

  PageController pageController = PageController(initialPage: 0);
  List<Intro> introPageList = ([
    Intro(
      'Number Verification',
      '',
      'assets/images/intro1.jpg',
    ),
    Intro(
      'Find Friend Contact',
      '',
      'assets/images/intro2.jpg',
    ),
    Intro(
      'Online Messages',
      '',
      'assets/images/intro3.jpg',
    ),
    Intro(
      'User Profile',
      '',
      'assets/images/intro4.jpg',
    ),
    Intro(
      'Settings',
      '',
      'assets/images/intro5.jpg',
    ),
  ]);

  var currentShowIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Expanded(
            child: PageView(
              controller: pageController,
              pageSnapping: true,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                currentShowIndex = index;
              },
              scrollDirection: Axis.horizontal,
              children: [
                IntroView(intro: introPageList[0]),
                IntroView(intro: introPageList[1]),
                IntroView(intro: introPageList[2]),
                IntroView(intro: introPageList[3]),
                IntroView(intro: introPageList[4]),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: introPageList.length,
            effect: SlideEffect(
              dotColor: Colors.grey,
              activeDotColor: Theme.of(context).primaryColor,
            ),
            onDotClicked: (index) {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).disabledColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.to(NumberScreen());
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
