import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';



import 'package:crypto/crypto.dart';

class LoginProvider
{
  Future<Map<String, String?>> googleSignIn() async
  {
    String email = "";
    String displayName = "";

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile'
      ],
    );

    try {
      GoogleSignInAccount? user = await googleSignIn.signIn();

      if(user != null)
        {
          email = user.email;
          if (user.displayName != null) user.displayName!;
          {
            displayName = user.displayName!;
          }
        }

      return {
        'email': email,
        'displayName': displayName,
      };

      // return email;

    } catch (error) {
      // print(error);
      return {
        'email': email,
        'displayName': displayName,
      };
      // return email;
    }

  }

 late final FirebaseAuth _firebaseAuth;


  //Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  Future<Map<String, String?>> signInWithApple() async {
    _firebaseAuth = FirebaseAuth.instance;

    if (_firebaseAuth.currentUser != null) {
      return {
        'email': _firebaseAuth.currentUser!.email ?? _firebaseAuth.currentUser!.uid,
        'displayName': _firebaseAuth.currentUser!.displayName ?? "",
      };

      // return _firebaseAuth.currentUser!.email ?? _firebaseAuth.currentUser!.uid;
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final cred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // 🛠️ Debug: log + decode identityToken payload
      if (cred.identityToken == null) {
        print('❌ identityToken is null (check iCloud/capability/cancel).');

        return {
          'email': "",
          'displayName': "",
        };

        // return null;
      }

      final parts = cred.identityToken!.split('.');
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      print('🍏 Apple token payload: $payload');
      print('aud: ${payload['aud']}');   // should equal your iOS Bundle ID
      print('nonce: ${payload['nonce']}'); // should equal sha256ofString(rawNonce)
      print('email: ${payload['email']}');

      // Build Firebase OAuth credential
      final oauth = OAuthProvider("apple.com").credential(
        idToken: cred.identityToken,
        rawNonce: rawNonce,
        accessToken: cred.authorizationCode
      );

      final userCred = await _firebaseAuth.signInWithCredential(oauth);
      final user = userCred.user;

      // Update displayName if present
      final fullName = [
        if (cred.givenName != null) cred.givenName!,
        if (cred.familyName != null) cred.familyName!,
      ].join(' ').trim();
      if (fullName.isNotEmpty) {
        await user!.updateDisplayName(fullName);
      }

      // Update email only if provided
      if (cred.email != null) {
        await user!.updateEmail(cred.email!);
      }

      return {
        'email': user?.email ?? cred.email ?? cred.userIdentifier,
        'displayName': user?.displayName ?? fullName,
      };

      // return user?.email ?? cred.email ?? cred.userIdentifier;
    } catch (e, st) {
      print('🔥 signInWithApple failed: $e\n$st');
      return {
        'email': "",
        'displayName': "",
      };
      // return null;
    }
  }


  static void isLoggedIn() async
  {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null)
    {
  // signed in
  } else {
  }
  }
}