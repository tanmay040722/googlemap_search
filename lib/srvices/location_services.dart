import 'dart:convert';

import 'package:http/http.dart' as http;

final apiKey = 'AIzaSyAolNZTfQ98UzyM6EtBiGQIMpHUSdART-Q';

Future<http.Response> getLocationData(String text) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$apiKey'),
    headers: {"Content-Type": "application/json"},
  );
  print(jsonDecode(response.body));

  return response;
}
