import 'package:flutter/foundation.dart';
import 'package:tmdb/database/init/database.dart';
import 'package:tmdb/database/model/database_model.dart';
import 'package:tmdb/models/movie_model.dart';

import 'package:tmdb/services/api_service.dart';
import 'package:tmdb/ui/home/home.dart';
import 'package:tmdb/services/api_service.dart';

class Data extends ChangeNotifier {
  MovieModel? _npModel;
  MovieModel? _tpModel;
  MovieModel? _popularModel;
  bool isLoaded = false;

  List npResult = [];
  List tpResult = [];
  List popularResult = [];

  Future fetchApi(context) async {
    await getPopular();
    await getNowPlaying();
    await getTopRated();
    isLoaded = true;
    notifyListeners();
  }

  Future getPopular() async {
    _popularModel = await ApiService().getPopular(1);
    popularResult = _popularModel!.results!;
    await _cacheDb(popularResult, MovieFields.popular);
  }

  Future getNowPlaying() async {
    _npModel = await ApiService().getNowPlaying(1);
    npResult = _npModel!.results!;
    await _cacheDb(npResult, MovieFields.nowPlaying);
  }

  Future getTopRated() async {
    _tpModel = await ApiService().getTopRated(1);
    tpResult = _tpModel!.results!;
    await _cacheDb(tpResult, MovieFields.topRated);
  }

  Future<void> _cacheDb(List model, String table) async {
    DatabaseHelper _db = DatabaseHelper.instance;
    await _db.deleteTable(table);

    for (int i = 0; i < model.length; i++) {
      final data = model[i];
      var result = MovieDatabaseModel(
        id: data.id,
        posterPath: data.posterPath,
        backdropPath: data.backdropPath,
        title: data.title,
        voteAverage: data.voteAverage,
      );
      await _db.create(table, result);
    }
  }

  Future<List<MovieDatabaseModel>> _readDb(String table) async {
    DatabaseHelper _db = DatabaseHelper.instance;

    return _db.read(table);
  }
}
