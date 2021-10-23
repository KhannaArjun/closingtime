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

  List setData()
  {
    List list = [];

    list.add("1");
    list.add("2");
    list.add("3");

    return list;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget _buildFoodList(List list, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: list.length,
      itemBuilder: (context, i) {

        return _buildRow(list[i]);
      },
    );
  }

  Widget _buildRow(String str) {
    return ListTile(
      title: Text(str),
    );
  }
}