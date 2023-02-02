import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/services/data.dart';
import 'package:tmdb/widgets/item_more.dart';

class MoreTrending extends StatefulWidget {
  const MoreTrending({Key? key}) : super(key: key);

  @override
  State<MoreTrending> createState() => _MoreTrendingState();
}

class _MoreTrendingState extends State<MoreTrending> {
  final _controller = ScrollController();

  Future<void> _getTrending() async {
    final pro = Provider.of<DataMoreTrending>(context, listen: false);
    pro.getMoreTrending(context);
  }

  void controller() {
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _getTrending();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTrending();
    controller();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataMoreTrending>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trending",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: provider.isLoaded
          ? ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              controller: _controller,
              itemCount: provider.results.length + 1,
              itemBuilder: (context, index) {
                if (index < provider.results.length) {
                  return ItemMore(
                    id: provider.results[index].id!,
                    poster: provider.results[index].posterPath!,
                    title: provider.results[index].title!,
                    vote: provider.results[index].voteAverage!,
                    language: provider.results[index].originalLanguage!,
                    release: provider.results[index].releaseDate!,
                  );
                } else {
                  return Visibility(
                    visible: provider.hasMore,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
