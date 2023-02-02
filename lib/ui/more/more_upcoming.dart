import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/services/data.dart';
import '../../widgets/item_more.dart';

class MoreUpComing extends StatefulWidget {
  const MoreUpComing({Key? key}) : super(key: key);

  @override
  State<MoreUpComing> createState() => _MoreUpComingState();
}

class _MoreUpComingState extends State<MoreUpComing> {
  final _controller = ScrollController();

  Future<void> _getUpComing() async {
    final pro = Provider.of<DataMoreUpComing>(context, listen: false);
    pro.getUpComing();
  }

  void controller() {
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _getUpComing();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUpComing();
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
    final provider = Provider.of<DataMoreUpComing>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sedang Tayang",
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
