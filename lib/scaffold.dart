import 'package:audioplayers/audioplayers.dart';
import 'package:finstants/models/instant_model.dart';
import 'package:finstants/services/my_instants_service.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatefulWidget {
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  List<InstantModel> data = [];

  final service = MyInstantsService();
  final audioPlayer = AudioPlayer();
  final controller = ScrollController();
  String playingSlug = "";
  int page = 1;
  bool isLoading = true;

  @override
  void initState() {
    fetch();
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        page++;
        fetch();
      }
    });
    super.initState();

    audioPlayer.onPlayerCompletion
        .listen((event) => setState(() => playingSlug = ""));
  }

  fetch() async {
    print("FETCHING PAGE $page");
    setState(() {
      isLoading = true;
    });
    final res = await service.getTrending(page);
    data = [...data, ...res];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending"),
        brightness: Brightness.dark,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                final res = await service.getTrending(page);
                data = res;
                setState(() {});
              })
        ],
      ),
      body: Column(
        children: [
          isLoading ? LinearProgressIndicator(minHeight: 2) : Container(),
          Expanded(
            child: ListView(
              controller: controller,
              children: [
                ...data
                    .map(
                      (e) => ListTile(
                        title: Text(e.name ?? "Unknown"),
                        subtitle: Text(e.slug ?? " - "),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.circle,
                            size: 37,
                            color: e.getColor(),
                          ),
                          backgroundColor: e.getColor().withOpacity(.4),
                        ),
                        trailing: IconButton(
                          icon: Icon(playingSlug == e.slug
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () async {
                            final played = await audioPlayer.play(
                              "${e.sound}".replaceFirst("http", "https"),
                            );
                            if (played == 1) {
                              setState(() {
                                playingSlug = e.slug ?? "";
                              });
                            }
                          },
                        ),
                        onTap: () {},
                      ),
                    )
                    .toSet()
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), label: "Trending"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
        ],
      ),
    );
  }
}
