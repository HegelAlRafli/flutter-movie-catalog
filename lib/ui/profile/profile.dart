import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/common/color_value.dart';
import 'package:tmdb/common/navigate.dart';
import 'package:tmdb/common/shared_code.dart';
import 'package:tmdb/ui/auth/login/login.dart';
import 'package:tmdb/ui/favourite/favourite.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        backgroundColor: Color(0XFF2F2C44),
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Setting'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CircleAvatar(
              //   backgroundColor: ColorValue.primaryColor,
              //   foregroundColor: Colors.white,
              //   radius: 50,
              //   child: ClipRRect(
              //     child: Icon(
              //       Icons.person,
              //       size: 50,
              //     ),
              //     borderRadius: BorderRadius.circular(50.0),
              //   ),
              // ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favourite(),
                      ));
                },
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: Image(
                              image: AssetImage(
                            'assets/images/lover.png',
                          )),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Text("Film Disukai",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 72, top: 12),
                      color: Color(0XFF2F2C44),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  await SharedCode().setToken('skip', false);
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigate.navigatorPushAndRemove(context, Login());
                },
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: Image(
                              image: AssetImage(
                            'assets/images/log-out.png',
                          )),
                        ),
                        SizedBox(
                          width: 32,
                        ),
                        Text("Keluar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 72, top: 12),
                      color: Color(0XFF2F2C44),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
