import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';



import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginProvider
{
  Future<String> googleSignIn() async
  {
    String email = "";

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      if(user != null)
        {
          email = user.email;
        }

      return email;

    } catch (error) {
      print(error);
      return email;
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

  Future<String?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.

    _firebaseAuth = FirebaseAuth.instance;

    if(_firebaseAuth.currentUser != null)
      {
        return _firebaseAuth.currentUser!.email;
      }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
      await _firebaseAuth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';

      final firebaseUser = authResult.user;
      print(displayName);
      print(userEmail);
      await firebaseUser!.updateDisplayName(displayName);
      await firebaseUser.updateEmail(userEmail);

      return userEmail;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  static void isLoggedIn() async
  {
    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null)
    {
  // signed in
      print(firebaseAuth.currentUser!.email);
      print("logged in");
  } else {
      print("not logged in");
  }
  }
}