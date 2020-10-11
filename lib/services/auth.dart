import 'package:brand/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _firestore = Firestore.instance;

  Future<AuthResult> singUp(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return authResult;
  }

  Future<AuthResult> singIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Future<FirebaseUser> getUser() async {
    await _auth.currentUser();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> singInWithGoogle(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    AuthResult authResult = await _auth.signInWithCredential(authCredential);
    FirebaseUser user = authResult.user;
    print('user email = ${user.email}');
    Navigator.pushNamed(context, MyHomePage.id,
        arguments: '${user.email}');
  }
}
