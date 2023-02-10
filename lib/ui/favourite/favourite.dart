import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/common/shared_code.dart';
import 'package:tmdb/widgets/item_more.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  bool _currentUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = SharedCode().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorit'),
      ),
      body: SafeArea(
        child: _currentUser
            ? SingleChildScrollView(
                child: _listFavourite(size.width, size.height),
              )
            : Container(
                width: size.width,
                height: size.height,
                child: Center(
                  child: Text(
                    'Silahkan login terlebih dahulu untuk melihat favorit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _listFavourite(double width, double height) {
    final _getCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(SharedCode().uid)
        .collection('favourite');

    return StreamBuilder<QuerySnapshot>(
      stream: _getCollection.snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              width: width,
              height: height,
              child: Center(
                child: Text(
                  'Data masih kosong',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                var data = snapshot.data!.docs[index];

                return ItemMore(
                  id: data['id'],
                  poster: data['image'],
                  title: data['title'],
                  vote: data['rating'],
                  language: data['language'],
                  release: data['release'],
                  isFavourite: true,
                );
              });
        } else {
          return Container(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
