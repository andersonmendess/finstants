import 'dart:convert';

import 'package:finstants/models/instant_model.dart';
import 'package:http/http.dart' as http;

class MyInstantsService {
  final endpoint = "https://www.myinstants.com/api/v1/instants";

  Future<List<InstantModel>> getTrending(int page) async {
    final res = await http.get(Uri.parse(endpoint + "?page=$page"));

    if(res.statusCode != 200) {
      return [];
    }

    final Map<String, dynamic>json = jsonDecode(res.body);

    List<InstantModel> instants = [];


    json['results'].forEach((i) {
      instants.add(InstantModel.fromJSON(i));
    });

    return instants;
  }
}