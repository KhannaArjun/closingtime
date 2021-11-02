import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class CommonStyles {
  static textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint:true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black,
            width: 2
        ),
      ),
    );
  }

  static layoutBackgroundShape()
  {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular( 20),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0)),
      child: Container(
        color: Colors.blue,

      ),
    );
  }

// Widget showDialog(BuildContext context)
// {
//   return showDialog(
//     context: context,
//     builder: (context) => Center(
//       child: Container(
//         width: 60.0,
//         height: 60.0,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: CupertinoActivityIndicator(),
//         ),
//       ),
//     )
//   );

//  }

}