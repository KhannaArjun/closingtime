import 'package:closingtime/utils/location_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class AutoCompleteGooglePlaces extends StatefulWidget {
  const AutoCompleteGooglePlaces({Key? key}) : super(key: key);

  @override
  _AutoCompleteGooglePlacesClass createState() => _AutoCompleteGooglePlacesClass();
}

class _AutoCompleteGooglePlacesClass extends State<AutoCompleteGooglePlaces> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyCWze0LuZzMqxMMgmsTxGFqRp0VsYsSxlE"); // Replace with your API Key
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Places Autocomplete',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Location Details"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context, null),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Search your location",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 2.0),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.isNotEmpty && mounted) {
                        setState(() => predictions = []);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.pin_drop, color: Colors.white),
                        ),
                        title: Text(predictions[index].description ?? "No results found"),
                        onTap: () {
                          getDetails(
                            predictions[index].description ?? "",
                            predictions[index].placeId ?? "",
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Fetches location suggestions based on user input.
  void autoCompleteSearch(String value) async {
    try {
      var result = await googlePlace.autocomplete.get(
        value,
        offset: 2,
        radius: 100000,
        components: [Component("country", "US")],
        region: "US",
      );

      if (result == null) {
        print("API Error: No response from Google API");
        return;
      }

      if (result.predictions == null || result.predictions!.isEmpty) {
        print("No predictions found.");
        return;
      }

      print("Predictions: ${result.predictions}");

      if (mounted) {
        setState(() => predictions = result.predictions!);
      }
    } catch (e) {
      print("Error fetching autocomplete results: $e");
    }
  }

  /// Fetches place details after user selects a location.
  void getDetails(String desc, String placeId) async {
    try {
      print("--- getDetails ---");
      print("Fetching details for Description: '$desc'");
      print("Fetching details for Place ID: '$placeId'"); // Log the placeId

      // Basic check for empty or obviously invalid placeId
      if (placeId.isEmpty) {
        print("Error: placeId is empty. Cannot fetch details.");
        // Optionally show a user-facing error or handle gracefully
        return;
      }
      var result = await googlePlace.details.get(placeId);

      if (result == null || result.result == null) {
        print("Error: Failed to fetch place details.");
        return;
      }

      double lat = result.result!.geometry?.location?.lat ?? 0.0;
      double lng = result.result!.geometry?.location?.lng ?? 0.0;

      // print("Location: $desc, Latitude: $lat, Longitude: $lng");

      if (mounted) {
        Navigator.pop(context, LocationDetailsModel(desc, lat, lng, placeId));
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
  }
}