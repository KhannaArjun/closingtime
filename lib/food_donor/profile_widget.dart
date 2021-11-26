import 'dart:io';

import 'package:closingtime/utils/ColorUtils.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          //buildImage(),
          buildCircleAvatar(),
          // Positioned(
          //   bottom: 0,
          //   right: 4,
          //   child: buildEditIcon(color),
          // ),
        ],
      ),
    );
  }

  // Widget buildImage() {
  //   final image = NetworkImage(imagePath);
  //
  //   return ClipOval(
  //     child: Material(
  //       color: Colors.transparent,
  //       child: Ink.image(
  //         image: Image.asset('assets/images/lake.jpg'),
  //         fit: BoxFit.cover,
  //         width: 128,
  //         height: 128,
  //         child: InkWell(onTap: onClicked),
  //       ),
  //     ),
  //   );
  // }

  Widget buildCircleAvatar()
  {
    return CircleAvatar(
        radius: 55,
        backgroundColor: ColorUtils.primaryColor,
        child: Container(
        decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(50)),
  width: 100,
  height: 100,
  child: Image.asset('assets/images/user.png')
    ));
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}