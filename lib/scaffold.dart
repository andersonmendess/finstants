import 'package:audioplayers/audioplayers.dart';
import 'package:finstants/components/instant_tile_component.dart';
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
  InstantModel? playing;
  int page = 1;
  bool isLoading = true;

  @override
  void initState() {
    fetch();
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        fetch();
      }
    });
    super.initState();

    audioPlayer.onPlayerCompletion
        .listen((event) => setState(() => playing = null));
  }

  fetch() async {
    print("FETCHING PAGE $page");
    setState(() {
      isLoading = true;
    });

    var res = await service.getTrending(page);
    data = [...data, ...res];
    page++;
    res = await service.getTrending(page);
    data = [...data, ...res];
    page++;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending"),
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
      ),
      body: Column(
        children: [
          isLoading ? LinearProgressIndicator(minHeight: 2) : Container(),
          Expanded(
            child: ListView(
              controller: controller,
              children: [
                ...data
                    .map((e) => InstantTileComponent(
                          instant: e,
                          isPlaying: playing?.slug == e.slug,
                          onPlay: () async {

                            if(playing?.slug == e.slug) {
                              audioPlayer.stop();
                              playing = null;
                              setState(() {
                                
                              });
                              return;
                            }
                            

                            final played = await audioPlayer.play(
                              "${e.sound}"
                            );
                            if (played == 1) {
                              setState(() {
                                playing = e;
                              });
                            }
                          },
                          onTap: () {},
                        ))
                    .toList()
              ],
            ),
          ),
        ],
      ),
      bottomSheet: playing != null ? Container(
        padding: const EdgeInsets.all(6),
        color: playing?.getColor(),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Icon(Icons.music_note, color: ((playing?.getColor().computeLuminance() ?? 0) >= 0.6) ? Colors.black :Colors.white, ),
            ),
            Text(playing?.name ?? "None", style: TextStyle(color: ((playing?.getColor().computeLuminance() ?? 0) >= 0.6) ? Colors.black :Colors.white,),)
          ],
        ),
      ): null,
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
