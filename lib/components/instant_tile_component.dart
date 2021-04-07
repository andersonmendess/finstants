import 'package:finstants/models/instant_model.dart';
import 'package:flutter/material.dart';

class InstantTileComponent extends StatelessWidget {
  final InstantModel instant;
  final bool isPlaying;
  final Function onPlay;
  final Function onTap;

  InstantTileComponent({
    required this.instant,
    required this.isPlaying,
    required this.onPlay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(instant.name ?? "Unknown"),
      subtitle: Text(instant.slug ?? " - "),
      leading: CircleAvatar(
        child: Icon(
          Icons.circle,
          size: isPlaying ? 34 : 37,
          color: instant.getColor(),
        ),
        backgroundColor: instant.getColor().withOpacity(.4),
      ),
      tileColor: isPlaying ? Color.fromARGB(255, 25, 25, 25) : Colors.transparent,
      trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () => onPlay()),
      onTap: () => onTap,
    );
  }
}
