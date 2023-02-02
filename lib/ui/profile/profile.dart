import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/common/shared_code.dart';

import '../../common/navigate.dart';
import '../auth/login/login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () async {
              await SharedCode().setToken('skip', false);
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigate.navigatorPushAndRemove(context, Login());
            },
            child: Text('Keluar'),
          ),
        ),
      ),
    );
  }
}
