import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/config/responsive_config.dart';
import 'package:tmdb/models/detail_model.dart';
import 'package:tmdb/services/data.dart';
import 'package:tmdb/services/firebase_service.dart';
import 'package:tmdb/widgets/item_cast.dart';
import 'package:tmdb/widgets/item_recom.dart';
import 'package:tmdb/widgets/item_video.dart';
import 'package:tmdb/widgets/snackbar/snackbar_item.dart';
import 'package:tmdb/widgets/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/shared_code.dart';

class Detail extends StatefulWidget {
  final int id;

  const Detail({Key? key, required this.id}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool _currentUser = false;

  Future<void> getDetail() async {
    final pro = Provider.of<DataDetail>(context, listen: false);
    pro.getDetail(widget.id);
    _currentUser = await SharedCode().currentUser;
  }

  Future _openUrl(String url) async {
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days} hari');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours} jam');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes} menit');
    }

    return tokens.join(' ');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataDetail>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: provider.isLoaded
          ? _currentUser
              ? _floatingButton(provider.detailModel!)
              : FloatingActionButton(
                  onPressed: () {
                    showSnackBar(context,
                        title: 'Silahkan masuk terlebih dahulu');
                  },
                  backgroundColor: Colors.pink,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                )
          : null,
      body: provider.isLoaded
          ? SingleChildScrollView(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      String url =
                          "https://www.youtube.com/watch?v=${provider.detailModel!.videos!.results![0].key}";
                      _openUrl(url);
                    },
                    child: Container(
                      width: double.infinity,
                      height: isLandscape(context)
                          ? size.height * 0.55
                          : size.height * 0.3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CachedNetworkImage(
                            width: double.infinity,
                            imageUrl:
                                "https://image.tmdb.org/t/p/w500${provider.detailModel!.backdropPath}",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.0),
                                  end: Alignment(0.0, 1.0),
                                  colors: [
                                    Colors.black45,
                                    backgroundColor,
                                  ]),
                            ),
                          ),
                          Image.asset(
                            "assets/images/play.png",
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    margin: EdgeInsets.only(
                        top: isLandscape(context)
                            ? size.width * 0.18
                            : size.width * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: isLandscape(context)
                                    ? size.width * 0.18
                                    : size.width * 0.35,
                                height: isLandscape(context)
                                    ? size.height * 0.5
                                    : size.height * 0.25,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/w500${provider.detailModel!.posterPath}",
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return Container(
                                      width: size.width * 0.18,
                                      height: size.height * 0.13,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.grey.withOpacity(0.7),
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.5,
                                    child: Text(
                                      provider.detailModel!.title!,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: size.width * 0.5,
                                    child: Table(
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      children: [
                                        _tableRow(
                                            "Genre",
                                            provider
                                                .detailModel!.genres![0].name!),
                                        _tableRow(
                                          "Durasi",
                                          _formatDuration(
                                            Duration(
                                              minutes: provider
                                                  .detailModel!.runtime!,
                                            ),
                                          ),
                                        ),
                                        _tableRow("Sutradara", "Taika Watiti"),
                                        _tableRow("Tanggal Rilis",
                                            provider.detailModel!.releaseDate!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isLandscape(context)
                              ? size.height * 0.08
                              : size.height * 0.04,
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoRating(
                                  size, provider.detailModel!.voteAverage!),
                              _infoText(size, "Status",
                                  provider.detailModel!.status!),
                              _infoText(size, "P-G", "16+"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isLandscape(context)
                              ? size.height * 0.08
                              : size.height * 0.04,
                        ),
                        Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                "Ringkasan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text(
                                provider.detailModel!.overview!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: isLandscape(context)
                              ? size.height * 0.08
                              : size.height * 0.04,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Pemeran",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: isLandscape(context)
                              ? size.height * 0.44
                              : size.height * 0.21,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount:
                                provider.detailModel?.credits?.cast?.length,
                            itemBuilder: (context, index) {
                              final model =
                                  provider.detailModel!.credits!.cast![index];

                              return ItemCast(
                                imageUrl: model.profilePath ?? "null",
                                name: model.name!,
                                character: model.character!,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: isLandscape(context)
                              ? size.height * 0.08
                              : size.height * 0.04,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Video",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: isLandscape(context)
                              ? size.height * 0.3
                              : size.height * 0.14,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount:
                                provider.detailModel?.videos?.results?.length,
                            itemBuilder: (context, index) {
                              final model =
                                  provider.detailModel!.videos!.results![index];

                              return ItemVideo(
                                ytKey: model.key!,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: isLandscape(context)
                              ? size.height * 0.08
                              : size.height * 0.04,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Rekomendasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: isLandscape(context)
                              ? size.height * 0.65
                              : size.height * 0.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 20, right: 5),
                            itemCount: provider.recomModel?.results?.length,
                            itemBuilder: (context, index) {
                              final model =
                                  provider.recomModel!.results![index];

                              return ItemRecommendation(
                                id: model.id!,
                                title: model.title!,
                                poster: model.posterPath ?? "a",
                                vote: model.voteAverage!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  TableRow _tableRow(String first, String second) {
    return TableRow(
      children: [
        Text(
          first,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 15,
          ),
        ),
        Text(
          second,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _infoText(Size size, String title, String desc) {
    return Container(
      width: size.width * 0.25,
      height: isLandscape(context) ? size.height * 0.17 : size.height * 0.07,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRating(Size size, double rating) {
    return Container(
      width: size.width * 0.25,
      height: isLandscape(context) ? size.height * 0.17 : size.height * 0.07,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RatingBarIndicator(
            rating: rating / 2,
            direction: Axis.horizontal,
            unratedColor: Colors.white.withOpacity(0.5),
            itemSize: 14,
            itemPadding: EdgeInsets.only(right: 1),
            itemCount: 5,
            itemBuilder: (context, index) {
              return FaIcon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
              );
            },
          ),
          Text(
            "${rating.toString().substring(0, 3)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingButton(DetailMovieModel model) {
    final _getDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(SharedCode().uid)
        .collection('favourite')
        .doc('${widget.id}');

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _getDocument.snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.data!.exists) {
            return FloatingActionButton(
              onPressed: () async {
                await FirebaseService()
                    .addFavourite(
                      context,
                      id: widget.id,
                      image: model.posterPath!,
                      title: model.title!,
                      rating: model.voteAverage!,
                      language: model.originalLanguage!,
                      release: model.releaseDate!,
                    )
                    .then(
                      (value) => value
                          ? showSnackBar(context,
                              title: 'Berhasil menambahkan film')
                          : showSnackBar(context,
                              title: 'Gagal menambahkan film'),
                    );
              },
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            );
          }
          return FloatingActionButton(
            onPressed: () async {
              await FirebaseService()
                  .deleteFavourite(context, id: widget.id)
                  .then(
                    (value) => value
                        ? showSnackBar(context, title: 'Film telah dihapus')
                        : showSnackBar(context, title: 'Gagal menghapus film'),
                  );
            },
            backgroundColor: Colors.pink,
            child: Icon(
              Icons.done,
              color: Colors.white,
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
