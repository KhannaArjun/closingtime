import 'package:closingtime/food_recipient/recipient_dashboard.dart';
import 'package:closingtime/registration/donor_registration.dart';
import 'package:closingtime/registration/recipient_registration.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:closingtime/splash_screen.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // await messaging.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  messaging.getToken().then((token){

    print(token);
    _storeFirebaseToken(token);
  });

  print('User granted permission: ${settings.authorizationStatus}');


  // configureNotifications(messaging);

  runApp(SplashScreenApp());

}

void configureNotifications(FirebaseMessaging _firebaseMessaging) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // showNotification(notification);
    print(notification!.title);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: $message");

    // acceptFoodDialog();

    SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

  });


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

}

Widget acceptFoodDialog()
{
  return  CupertinoAlertDialog(
    title: const Text("Dialog Title"),
    content: const Text("This is my content"),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        child: Text("Yes"),
      ),
      CupertinoDialogAction(
        child: Text("No"),
      )
    ],
  );
}

void _storeFirebaseToken(token) async
{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString(Constants.firebase_token, token);
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}


class RolePreferenceScreen extends StatelessWidget {

  String _email = "";

  RolePreferenceScreen(String email)
  {
    this._email = email;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: LoaderOverlay(
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Closing Time!',
            style: TextStyle(
              color: ColorUtils.button_color
            ),
          ),
        ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 60.0, 5.0,0.0),
                child: const Text(
                  "“Feel what it’s like to truly starve, and I guarantee that you’ll forever think twice about wasting food.“",
                    style: TextStyle(
                      color: Colors.black, fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5.0, 60.0, 5.0,0.0),
                child: const Text(
                  "Please select",
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              buildButtonDonor(context),
              buildButtonVolunteer(context),
              buildButtonRecipient(context),
            ],
          ),
        ),
      )),
      ));
  }

  Widget buildButtonDonor(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,
          child: const Text(
            "Food Donor",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorRegistration(_email, null)));
          },
        ),
      ),
    );
  }

  Widget buildButtonVolunteer(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,

          child: const Text(
            "Volunteer",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerRegistration(_email)));
          },
        ),
      ),
    );
  }

  Widget buildButtonRecipient(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,

          child: const Text(
            "Food Recipient",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipientRegistration(_email, null)));
          },
        ),
      ),
    );
  }


  // void _showNotification(message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     'Notification Test',
  //     'Notification Test',
  //   );
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await _flutterLocalNotificationsPlugin.show(
  //     ++_count,
  //     message['title'],
  //     message['body'],
  //     platformChannelSpecifics,
  //     payload: json.encode(
  //       message['data'],
  //     ),
  //   );
  // }

  // /// initialize flutter_local_notification plugin
  // void _initializeLocalNotification() {
  //   // Settings for Android
  //   var androidInitializationSettings =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //   // Settings for iOS
  //   var iosInitializationSettings = new IOSInitializationSettings();
  //   _flutterLocalNotificationsPlugin.initialize(
  //     InitializationSettings(
  //       androidInitializationSettings,
  //       iosInitializationSettings,
  //     ),
  //     onSelectNotification: _onSelectLocalNotification,
  //   );
  // }


}
