import 'package:closingtime/registration/sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  }

  Widget _buildFullscreenImage(imagename) {
    return Image.asset(
      'assets/images/$imagename',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return MaterialApp(
        home: Scaffold(
        body: IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      pages: [

        PageViewModel(
          titleWidget:Visibility (
              visible: false,
              child: Text(
                  ''
              )),
          bodyWidget:
          Visibility (
              visible: false,
              child: Text(
                  ''
              )),
          image: _buildFullscreenImage('donate.png'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,

            bodyFlex: 0,
            imageFlex: 4,
          ),
        ),

        PageViewModel(
          titleWidget: Visibility (
            visible: false,
            child: Text(
              ''
          )),
          bodyWidget:
          Visibility (
              visible: false,
              child: Text(
                  ''
              )),
          image: _buildFullscreenImage('recipient.png'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          titleWidget: Visibility (
              visible: false,
              child: Text(
                  ''
              )),
          bodyWidget:
          Visibility (
              visible: false,
              child: Text(
                  ''
              )),
          image: _buildFullscreenImage('volunteer.png'),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 4,
          ),
        ),
      ],

      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      showNextButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      next: const Icon(Icons.arrow_forward, ),
      done: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    ), ), );
}
}