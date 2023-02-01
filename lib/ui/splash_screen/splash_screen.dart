import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/common/navigate.dart';
import 'package:tmdb/ui/auth/register/register.dart';
import 'package:tmdb/ui/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<double> _opacityLogo = ValueNotifier<double>(0);

  Future _initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _opacityLogo.value = 1;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigate.navigatorPushAndRemove(
      context,
      FirebaseAuth.instance.currentUser != null ? Home() : Register(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<double>(
          valueListenable: _opacityLogo,
          builder: (context, value, _) => AnimatedOpacity(
            opacity: value,
            duration: Duration(milliseconds: 300),
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
