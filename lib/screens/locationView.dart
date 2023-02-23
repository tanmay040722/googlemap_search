import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_map_serach/screens/location_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'search_location.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    _cameraPosition =
        CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
  }

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      init: LocationController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
                onMapCreated: (GoogleMapController mapController) {
                  _mapController = mapController;
                  // controller.setMapController(mapController);
                },
                initialCameraPosition: _cameraPosition),
            Positioned(
              top: 100,
              left: 10, right: 20,
                child: GestureDetector(
                onTap: () =>Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.location_on,
                      size: 25, color: Theme.of(context).primaryColor),
                    SizedBox(width: 5),
                    Expanded(
                      child:
                        Text(
                        '${controller.pickPlaceMark.name ?? ''} ${controller.pickPlaceMark.locality ?? ''} '
                        '${controller.pickPlaceMark.postalCode ?? ''} ${controller.pickPlaceMark.country ?? ''}',
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                    SizedBox(width: 10),
                    Icon(Icons.search,
                      size: 25,
                      color: Theme.of(context).textTheme.bodyText1!.color),
                ]),
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
