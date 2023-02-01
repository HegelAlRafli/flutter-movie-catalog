import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/common/color_value.dart';
import 'package:tmdb/services/data.dart';
import 'package:tmdb/services/providers/loading_provider.dart';
import 'package:tmdb/ui/home/home.dart';
import 'package:tmdb/ui/splash_screen/splash_screen.dart';
import 'package:tmdb/widgets/theme.dart';

import 'config/push_notification_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await PushNotificationConfig().requestPermission();
  await PushNotificationConfig().androidNotificationChanel();
  setSystemChrome();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void setSystemChrome() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: backgroundColor,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ketika notifikasi di klik on background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        String route = message.data['route'];
        Navigator.pushNamed(context, route);
      }
    });

    // ketika notifikasi di klik on terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data.isNotEmpty) {
          String route = message.data['route'];
          Navigator.pushNamed(context, route);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Data()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: appBarColor),
            scaffoldBackgroundColor: backgroundColor,
            textTheme: GoogleFonts.openSansTextTheme(),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: ColorValue.primaryColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )),
            )),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
