import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tmdb/models/detail.dart';
import 'package:tmdb/models/now_playing.dart';
import 'package:tmdb/models/popular.dart';
import 'package:tmdb/models/recommendation.dart';
import 'package:tmdb/models/up_coming.dart';

class ApiService {
  final mainUrl = "https://api.themoviedb.org/3";
  final apiKey = "6336e4208132f6206aa0b05d04b1fda7";

  Future getNowPlaying() async {
    try {
      final response = await http
          .get(Uri.parse("$mainUrl/movie/now_playing?api_key=$apiKey&page=1"));

      print("get now playing : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        NowPlayingModel? model =
            NowPlayingModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUpComing() async {
    try {
      final response = await http.get(Uri.parse(
          "$mainUrl/movie/top_rated?api_key=$apiKey&language=en-US&page=1"));

      print("get upcoming : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        UpComingModel? model =
            UpComingModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getPopular() async {
    try {
      final response = await http.get(Uri.parse(
          "$mainUrl/movie/popular?api_key=$apiKey&language=en-US&page=1"));

      print("get popular : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        PopularModel? model = PopularModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getDetail(int id) async {
    try {
      final response = await http.get(Uri.parse(
          "$mainUrl/movie/$id?api_key=$apiKey&language=en-US&append_to_response=videos,credits"));

      print("get detail : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        DetailMovieModel? model =
            DetailMovieModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getRecommendation(int id) async {
    try {
      final response = await http.get(Uri.parse(
          "$mainUrl/movie/$id/recommendations?api_key=$apiKey&language=en-US&page=1"));

      print("get recommendation : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        RecommendationModel model =
            RecommendationModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        throw "Failed to fetch API";
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
