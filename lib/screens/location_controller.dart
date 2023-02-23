import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_serach/srvices/location_services.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  Placemark placemark = Placemark();

  Placemark get pickPlaceMark => placemark;

  List<Prediction> priditionlist = [];

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async{
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      if (data['status'] == 'OK') {
        priditionlist = [];
        data['preditions'].forEach(
          (prediction) => priditionlist.add(
            Prediction.fromJson(prediction),
          ),
        );

      }else{
        return priditionlist;

      }
      return priditionlist;
    }
    return priditionlist;

  }
}
