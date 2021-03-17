import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/AppIconWidget.dart';
import 'package:manga_reader/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation<double> iconAnimation;
  AnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    iconAnimationController = AnimationController(
        duration: const Duration(seconds: 5), vsync: this);
    iconAnimation =
        Tween<double>(begin: 2, end: 4).animate(iconAnimationController);
    iconAnimationController.repeat(reverse: true);

    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacementNamed(context, Routes.lelscan);
    });
    //navigate(iconAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: AnimatedBuilder(
        animation: iconAnimationController,
        builder: (BuildContext context, Widget child) {
          return AppIconWidget(
              scale: iconAnimationController.value, image: Assets.appLogo);
        },
      )),
    );
  }

  navigate(AnimationController iconanimationController) async {
   /* Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    SharedPreferenceHelper sharedPreferenceHelper= new SharedPreferenceHelper(preferences);
    bool firstUsage = await sharedPreferenceHelper.firstUsage;
    bool isLoggedIn = await sharedPreferenceHelper.isLoggedIn;
    if(firstUsage){
      iconanimationController.dispose();
      Navigator.of(context).pushReplacementNamed(Routes.onboarding);
    }
    else if (isLoggedIn == true) {

      String refreshToken = await sharedPreferenceHelper.refreshToken;

      refreshtoken(refreshToken).then((value) async {

        await sharedPreferenceHelper.saveAuthToken(value["token"]);
        await sharedPreferenceHelper.saveRefreshToken(value["refreshToken"]);
        iconanimationController.dispose();
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }).catchError((onError){
        switch(onError.response.statusCode){
          case 403:{
            iconanimationController.dispose();
            Navigator.pushReplacementNamed(context,Routes.login);
          }
          break;
        }
      });

    } else {
      iconanimationController.dispose();
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }*/
  }
}
