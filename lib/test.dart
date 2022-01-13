import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';


class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestHomePage(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  @override
  _TestHomePage createState() => _TestHomePage();
}

class _TestHomePage extends State<TestHomePage> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    googlePlace = GooglePlace("AIzaSyC6BSkN2od9soYaSaiIou-Ctcop186rWPg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        debugPrint(predictions[index].placeId);
                        debugPrint(predictions[index].structuredFormatting.toString());

                        getDetils(predictions[index].placeId?? "");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetils(String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {

      print(result.result!.geometry!.location!.lat);
      print(result.result!.geometry!.location!.lng);

      setState(() {

      });
    }
  }

}