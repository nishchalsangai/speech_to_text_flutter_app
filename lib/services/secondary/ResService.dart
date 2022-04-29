import 'package:flutter/material.dart';
import 'package:ninjastudytask/models/Secondary/restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Restaurant>> getChatData() async {
  var response =
      await http.get(Uri.parse("https://my-json-server.typicode.com/tryninjastudy/dummyapi/db"));
  List<dynamic> raw = jsonDecode(response.body)['restaurant'];
  return raw.map((e) => Restaurant.fromJSON(e)).toList();
}
