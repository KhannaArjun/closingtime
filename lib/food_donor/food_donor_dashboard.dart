import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/food_donor/donate_food.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:flutter/material.dart';


class FoodDonorDashboard extends StatelessWidget {
  const FoodDonorDashboard({Key? key}) : super(key: key);

  static const appTitle = 'Closing Time!';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: _FoodDonorDashboard(title: appTitle),
    );
  }
}

class _FoodDonorDashboard extends StatelessWidget {
  const _FoodDonorDashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  List<FoodDonatedData> setData()
  {
    List<FoodDonatedData> foodDonatedList = [];

    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));


    return foodDonatedList;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      appBar: AppBar(title: Text(title)),
      body: Center(

        child: _buildFoodList(setData(), context),

      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 80.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood()));
            },
            icon: Icon(Icons.add),
            label: Text("Donote Food"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        // Add a ListView to the drawer.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Hello, Guest.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),

              ),
            ),
            ListTile(
              title: const Text('Donate Food'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList(List<FoodDonatedData> list, BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      color: Color(0x00000000)
    ),
        child: ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: list.length,
      itemBuilder: (context, i) {

        return _itemCard(context, list[i]);
      }),
    );
  }

  Widget _itemCard(BuildContext context, FoodDonatedData foodDonatedData)
  {
    return Container(
      height: 150,
        child: Card(
      color: Colors.white,
      elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
            onTap: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(foodDonatedData.foodName + ' pressed!'),
              ));
            },
            title: Text(foodDonatedData.foodDesc),
            subtitle: Text(foodDonatedData.quantity),
            leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1547721064-da6cfb341d50")))));
  }
}