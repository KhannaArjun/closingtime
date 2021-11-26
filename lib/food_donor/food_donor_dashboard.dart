// import 'dart:convert';
//
// import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
// import 'package:closingtime/food_donor/donate_food.dart';
// import 'package:closingtime/network/api_service.dart';
// import 'package:closingtime/utils/ColorUtils.dart';
// import 'package:closingtime/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
//
//
// class FoodDonorDashboard extends StatefulWidget {
//   const FoodDonorDashboard({Key? key}) : super(key: key);
//
//   static const appTitle = 'Closing Time!';
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: appTitle,
//       home: _FoodDonorDashboard(title: appTitle),
//     );
//   }
// }
//
// class _FoodDonorDashboard extends StatefulWidget {
//   const _FoodDonorDashboard({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//   List<Data> _addedFoodList;
//
//
//   List<Data> setData(List<Data> data)
//   {
//     // List<FoodDonatedData> foodDonatedList = [];
//     //
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
//     //
//
//     return data;
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0x00000000),
//       appBar: AppBar(title: Text(title)),
//       body: Center(
//
//         child: _buildFoodList(_addedFoodList, context),
//
//       ),
//       floatingActionButton: Container(
//         padding: const EdgeInsets.only(bottom: 80.0),
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: FloatingActionButton.extended(
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood()));
//             },
//             icon: Icon(Icons.add),
//             label: Text("Donote Food"),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       drawer: Drawer(
//         // Add a ListView to the drawer.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Hello, Guest.',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//
//               ),
//             ),
//             ListTile(
//               title: const Text('Donate Food'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Logout'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodList(List<Data> list, BuildContext context) {
//     return Container(
//     decoration: BoxDecoration(
//       color: Color(0x00000000)
//     ),
//         child: ListView.builder(
//       padding: const EdgeInsets.all(10.0),
//       itemCount: list.length,
//       itemBuilder: (context, i) {
//
//         Data addedFoodModel = list[i];
//         return _itemCard(context, addedFoodModel);
//       }),
//     );
//   }
//
//   Widget _itemCard(BuildContext context, Data addedFoodModel)
//   {
//     return Container(
//       height: 150,
//         child: Card(
//       color: Colors.white,
//       elevation: 20,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: ListTile(
//             onTap: () {
//               Scaffold.of(context).showSnackBar(SnackBar(
//                 content: Text(addedFoodModel.foodName + ' pressed!'),
//               ));
//             },
//             title: Text(addedFoodModel.foodDesc),
//             subtitle: Text(addedFoodModel.quantity),
//             leading: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://images.unsplash.com/photo-1547721064-da6cfb341d50")))));
//   }
//
//   void foodListApiCall()
//   {
//
//     Map body = {
//       "user_id":"6185845517e8d97ac25b1199"
//     };
//
//     try
//     {
//       Future<AddedFoodListModel> addedFoodListModel = ApiService.addedFoodList(jsonEncode(body));
//       addedFoodListModel.then((value){
//
//         if (!value.error)
//         {
//           if (value.data.isNotEmpty)
//             {
//               setData(value.data);
//
//               value.data = _addedFoodList;
//             }
//         }
//       });
//
//     }
//     on Exception catch(e)
//     {
//       print(e);
//       Constants.showToast("Please try again");
//     }
//
//   }
// }