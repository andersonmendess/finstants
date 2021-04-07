import 'package:flutter/material.dart';

class InstantModel {
  String? name;
  String? slug;
  String? sound;
  String? color;
  String? image;
  String? description;
  String? tags;

  InstantModel({
    required this.name,
    required this.slug,
    required this.sound,
    required this.color,
    required this.image,
    required this.description,
    required this.tags,
  });

  InstantModel.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    sound = json['sound'].replaceFirst("http", "https");
    color = json['color'];
    image = json['image'];
    description = json['description'];
    tags = json['tags'];
  }

  Color getColor() {
    if(color == null) return Colors.black;
    try {
      return Color(int.parse("0xFF$color"));
    } catch (e) {
      return Colors.black;
    }

  }
}

// "name": "Lula",
// "slug": "lula",
// "sound": "http://www.myinstants.com/media/sounds/ok-vamos-falar-do-bolsonaro.mp3",
// "color": "FF0000",
// "image": "http://www.myinstants.com/media/instants_images/lulita.jpg",
// "description": "Não vai ter golpe, vai ter luta!\r\n#ComunismoÉAmor",
// "tags": ""
