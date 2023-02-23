import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  static const LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<Marker> markerList = {};

  late GoogleMapController googleMapController;

  final apiKey = 'AIzaSyAolNZTfQ98UzyM6EtBiGQIMpHUSdART-Q';

  final _mode = Mode.overlay;

  final scafoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: MyHomePage._kInitialPosition,
              markers: markerList,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              mapType: MapType.normal,
            ),
            ElevatedButton(
              onPressed: () {
                buttonHandler(context);
              },
              child: const Text('search'),
            ),

/*
            const TextField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey ),
                  border: InputBorder.none),
            ),
*/
          ],
        ),
      ),
    );
  }

  Future<void> buttonHandler(BuildContext context) async {
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      location: Location(lat: 19.018255973653343, lng: 72.84793849278007),
      radius: 100000000,
      mode: Mode.overlay,
      language: "en",
      types: [''],
      strictbounds: false,
      components: [Component(Component.country, 'pk')],
    );
    /*Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [''],
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      components: [Component(Component.country, 'pk')],
    );*/
    displayPridictions(prediction!, scafoldkey.currentState);
  }

  Future<void> displayPridictions(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detailsResponse =
        await places.getDetailsByPlaceId(p.placeId!);

    final lat = detailsResponse.result.geometry!.location.lat;
    final lng = detailsResponse.result.geometry!.location.lng;

    markerList.clear();
    markerList.add(Marker(
        markerId: const MarkerId('0'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detailsResponse.result.name)));

    setState(() {
      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
    });
  }

  onError(PlacesAutocompleteResponse response) {
    scafoldkey.currentState
        ?.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }
}
