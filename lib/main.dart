// lib/main.dart

import 'dart:io';

import 'package:closingtime/registration/donor_registration.dart';
import 'package:closingtime/registration/recipient_registration.dart';
import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:closingtime/splash_screen.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';

/// Toggle this to enable/disable FCM without changing the rest of the code.
const bool kEnablePush = true; // set to true when you’re ready for push

Future<void> getAppInfo() async {
  if (Platform.isIOS || Platform.isAndroid) {
    final info = await PackageInfo.fromPlatform();
    debugPrint('App version: ${info.version}');
  } else if (Platform.isWindows) {
    debugPrint('This functionality is not available on Windows.');
  }
}


void printFirebaseInfo() {
  final opts = Firebase.app().options;
  print('FB projectID: ${opts.projectId}');
  print('FB appID:     ${opts.appId}');
  print('FB apiKey:    ${opts.apiKey}');
  print('FB bundleID:  ${opts.iosBundleId}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  printFirebaseInfo();

  // Register the background handler early (recommended; only once here).
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Show notifications while app is in foreground on iOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Crashlytics: capture uncaught Flutter errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Safe timing for plugin calls
  await getAppInfo();

  // Optional: version check logging (UI prompts should happen with a BuildContext)
  final newVersion = NewVersion();
  final version = await newVersion.getVersionStatus();
  debugPrint('hello');
  debugPrint(version?.localVersion);
  debugPrint(version?.storeVersion);

  // Push: disabled unless you flip the flag
  if (kEnablePush) {
    await _initPushSafely();
  }

  runApp(SplashScreenApp());
}

/// Initializes FCM in a way that won’t crash on iOS Simulator or when APNs isn’t set up yet.
Future<void> _initPushSafely() async {
  final fm = FirebaseMessaging.instance;

  // 1) Request notification permission first (iOS)
  final settings = await fm.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (Platform.isIOS && !kIsWeb) {
    // If user denied, bail out gracefully.
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('Notifications denied by user; skipping FCM token.');
      _attachForegroundListeners(); // still attach listeners to avoid null refs later
      return;
    }

    // 2) Wait for APNs token (iOS can be slow on first run)
    String? apnsToken;
    for (var i = 0; i < 40; i++) { // ~12 seconds max (40 * 300ms)
      apnsToken = await fm.getAPNSToken();
      if (apnsToken != null) break;
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (apnsToken == null) {
      debugPrint(
        'APNs token is still null. Ensure Push capability, Background Modes → Remote notifications, '
            'and that the user allowed notifications. Skipping FCM getToken() for now.',
      );
      _attachForegroundListeners();
      return;
    }
  }

  // 3) Safe to get FCM token now
  try {
    final token = await fm.getToken();
    if (token != null) {
      await _storeFirebaseToken(token);
      debugPrint('FCM token: $token');
    } else {
      debugPrint('FCM getToken returned null.');
    }
  } catch (e, st) {
    debugPrint('FCM getToken failed: $e');
    debugPrintStack(stackTrace: st);
  }

  // 4) Listen for token refreshes
  FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
    debugPrint('FCM token refreshed: $t');
    await _storeFirebaseToken(t);
  });

  // 5) Foreground / open handlers
  _attachForegroundListeners();
}

void _attachForegroundListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('onMessage: id=${message.messageId} data=${message.data}');
    // If you want a visible banner for data-only payloads on Android,
    // integrate flutter_local_notifications and show a local notif here.
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('onMessageOpenedApp: id=${message.messageId} data=${message.data}');
    // Navigate based on message.data if needed.
  });
}

Future<void> _storeFirebaseToken(String token) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setString(Constants.firebase_token, token);
}

@pragma('vm:entry-point') // ensure iOS can call this in the background
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a background isolate – initialize Firebase here.
  await Firebase.initializeApp();
  debugPrint('BG message: id=${message.messageId} data=${message.data}');
  // Handle background/terminated messages
}

/// ---- Optional screen from your project (left intact) ----

class RolePreferenceScreen extends StatelessWidget {
  String _email = "";

  RolePreferenceScreen(String email, {Key? key}) : super(key: key) {
    _email = email;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: LoaderOverlay(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/logo_blue.png'),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  child: const Text(
                    "“Feel what it’s like to truly starve, and I guarantee that you’ll forever think twice about wasting food.“",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 60.0, 5.0, 0.0),
                  child: const Text(
                    "Please select",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                buildButtonDonor(context),
                buildButtonVolunteer(context),
                buildButtonRecipient(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonDonor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,
          child: const Text(
            "Food Donor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DonorRegistration(_email, null)),
            );
          },
        ),
      ),
    );
  }

  Widget buildButtonVolunteer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,
          child: const Text(
            "Volunteer",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VolunteerRegistration(_email, "", null)),
            );
          },
        ),
      ),
    );
  }

  Widget buildButtonRecipient(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,
          child: const Text(
            "Food Recipient",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RecipientRegistration(_email, null)),
            );
          },
        ),
      ),
    );
  }
}
