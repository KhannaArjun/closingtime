import 'package:closingtime/utils/preview_food_image.dart';
import 'package:flutter/material.dart';

class FoodDescImageWidget extends StatefulWidget {
  String _image;
  FoodDescImageWidget(this._image);

  @override
  _FoodDescImageWidgetState createState() => _FoodDescImageWidgetState(_image);
}

class _FoodDescImageWidgetState extends State<FoodDescImageWidget> {
  String _image;
  _FoodDescImageWidgetState(this._image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.network(_image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.fitWidth
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewImage(_image)));
      },
    );
  }
}
