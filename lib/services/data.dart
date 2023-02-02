import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tmdb/database/init/database.dart';
import 'package:tmdb/database/model/database_model.dart';
import 'package:tmdb/models/detail_model.dart';
import 'package:tmdb/models/movie_model.dart';
import 'package:tmdb/models/recommendation_model.dart';

import 'package:tmdb/services/api_service.dart';
import 'package:tmdb/models/movie_model.dart' as result;

class DataHome extends ChangeNotifier {
  MovieModel? _npModel;
  MovieModel? _tpModel;
  MovieModel? _popularModel;
  bool isLoaded = false;

  List npResult = [];
  List tpResult = [];
  List popularResult = [];

  DatabaseHelper _db = DatabaseHelper.instance;

  Future fetchApi(context) async {
    isLoaded = false;
    var connectivity = await (Connectivity().checkConnectivity());

    if (connectivity == ConnectivityResult.none) {
      print("connectivity none");

      npResult = await _db.read(MovieFields.nowPlaying);
      tpResult = await _db.read(MovieFields.topRated);
      popularResult = await _db.read(MovieFields.popular);
      isLoaded = true;
    } else {
      print("connectivity ready");

      await getPopular();
      await getNowPlaying();
      await getTopRated();
      isLoaded = true;
    }
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

class DataDetail extends ChangeNotifier {
  DetailMovieModel? detailModel;
  RecommendationModel? recomModel;
  bool isLoaded = false;

  Future getDetail(int id) async {
    isLoaded = false;
    detailModel = await ApiService().getDetail(id);
    recomModel = await ApiService().getRecommendation(id);
    isLoaded = true;
    notifyListeners();
  }
}

class DataMoreTrending extends ChangeNotifier {
  MovieModel? model;
  bool isLoaded = false;
  bool hasMore = true;
  int currentPage = 1;
  List<result.Results> results = [];

  Future<void> getMoreTrending(BuildContext context) async {
    isLoaded = false;
    model = await ApiService().getPopular(currentPage);

    if (currentPage > 499) {
      hasMore = false;
    } else {
      results.addAll(model!.results!);
      currentPage++;
    }

    print("current page : " + currentPage.toString());
    isLoaded = true;
    notifyListeners();
  }
}

class DataMoreUpComing extends ChangeNotifier {
  MovieModel? model;
  bool isLoaded = false;
  bool hasMore = true;
  int currentPage = 1;
  List<result.Results> results = [];

  Future<void> getUpComing() async {
    isLoaded = false;
    model = await ApiService().getNowPlaying(currentPage);

    if (currentPage > 499) {
      hasMore = false;
    } else {
      results.addAll(model!.results!);
      currentPage++;
    }

    print("current page : " + currentPage.toString());
    isLoaded = true;
    notifyListeners();
  }
}
