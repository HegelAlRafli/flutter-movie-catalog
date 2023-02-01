import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/snackbar/snackbar_item.dart';

class FirebaseService {
  Future<bool> signUp(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          String uid = FirebaseAuth.instance.currentUser!.uid;

          DocumentReference documentReference =
              FirebaseFirestore.instance.collection('users').doc(uid);
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            documentReference.set({
              'uid': uid,
              'name': name,
              'email': email,
              'created_at': DateTime.now(),
              'updated_at': DateTime.now(),
            });
          }
        });
      });
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          showSnackBar(context, title: 'Email sudah digunakan');
          break;
      }
      return false;
    } on SocketException {
      showSnackBar(context, title: 'Tidak ada koneksi internet');
      return false;
    }
  }
}