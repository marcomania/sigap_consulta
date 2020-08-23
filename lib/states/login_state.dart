import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loggedIn = false;
  bool _loading = false;
  String username = "";
  String password = "";
  var perfil;
  FirebaseUser _user;

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  FirebaseUser currentUser() => _user;
  void setLoggedIn(bool state) {
    _loggedIn = state;
  }

  void setCredentials(String user, String pass) {}
  void login() async {
    _loading = true;
    notifyListeners();
    _googleSignIn.signOut();
    _user = await _handleSignIn();

    _loading = false;
    if (_user != null) {
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  void logout() {
    _googleSignIn.signOut();
    _loggedIn = true;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential));
    print("signed in " + user.displayName);
    return user;
  }
}
