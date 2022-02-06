import 'dart:typed_data';

import 'package:closingtime/utils/location_details_model.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class AutoCompleteGooglePlaces extends StatefulWidget {
  @override
  _AutoCompleteGooglePlacesClass createState() => _AutoCompleteGooglePlacesClass();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _AutoCompleteGooglePlacesClass extends State<AutoCompleteGooglePlaces> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();

    googlePlace = GooglePlace("AIzaSyC6BSkN2od9soYaSaiIou-Ctcop186rWPg");

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        theme: ThemeData(
        primarySwatch: Colors.blue,),
    home: Scaffold(
      appBar: AppBar(
    title: const Text("Location details"),
      backgroundColor: Colors.blue,
      elevation: 0.0,
      titleSpacing: 10.0,
      centerTitle: true,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context, null);
          },
        child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      ),),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: "Search your location",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {

                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                  } else {
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description ?? "No results found"),
                      onTap: () {


                        getDetails(predictions[index].description ?? "", predictions[index].placeId?? "");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value, offset: 2, radius: 100000, components: [Component("country", "US")], region: "US");

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetails(String desc, String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {

      // print(result.result!.addressComponents);
      // print(result.result!.formattedAddress);
      // print(result.result!.types);

      Navigator.pop(context, LocationDetailsModel(desc, result.result!.geometry!.location!.lat?? 0.0, result.result!.geometry!.location!.lng?? 0.0, placeId));
    }
  }

}