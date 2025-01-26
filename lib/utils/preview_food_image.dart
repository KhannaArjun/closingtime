import 'package:flutter/material.dart';


class PreviewImage extends StatefulWidget {
  final String _image;

  const PreviewImage(this._image, {Key? key}) : super(key: key);

  @override
  _PreviewImageState createState() => _PreviewImageState(_image);
}

class _PreviewImageState extends State<PreviewImage> {

  final String _image;
  _PreviewImageState(this._image);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
        "",
        style: TextStyle(
        color: Colors.black
    ),),
    backgroundColor: Colors.black,
    elevation: 0.0,
    titleSpacing: 10.0,
    centerTitle: true,
    leading: InkWell(
    onTap: () {
    Navigator.pop(context);
    },
    child: const Icon(
    Icons.arrow_back_ios,
    color: Colors.white,
    ),
    ),),

    body: Container(
      color: Colors.black,
          child: Padding(padding: const EdgeInsets.all(5),
          child: Image.network(
            _image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
    ), ),);
  }
}
