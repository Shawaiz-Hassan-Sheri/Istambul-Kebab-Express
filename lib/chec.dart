import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String address = "null";
  String autocompletePlace = "null";
  Prediction? initialValue;

  final TextEditingController _controller = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyBu_Ild2B1rMbRtMp_yJoTb9xjy8NrsjZM");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Picker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            onChanged: (query) => _onSearchTextChanged(query),
            decoration: InputDecoration(
              hintText: 'Search for a place',
            ),
          ),
          // Rest of your code...
        ],
      ),
    );
  }

  void _onSearchTextChanged(String query) async {
    if (query.isEmpty) {
      return;
    }

    PlacesAutocompleteResponse response = await _places.autocomplete(
      query,
      language: "en",
      components: [Component(Component.country, "us")],
    );

    if (response.isOkay) {
      // Update your UI with autocomplete results
    }
  }
}
