import 'dart:async';
import 'dart:io';

import 'package:cake_away/models/picitUser.dart';
import 'package:cake_away/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'firebase_provider.dart';

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(User user,
          {String name, String phonenumber, String country, String city}) =>
      _firebaseProvider.addDataToDb(user);

  Future<String> signIn(String email, String password) =>
      _firebaseProvider.signIn(email, password);
  Future<User> registerUser(String email, String password) =>
      _firebaseProvider.registerUser(email, password);

  Future<bool> authenticateUser(User user) =>
      _firebaseProvider.authenticateUser(user);

  User getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();
  Future<void> forgotPassword(String email) =>
      _firebaseProvider.forgotPassword(email);

  Future<void> addPostToDb(
    Post post,
  ) =>
      _firebaseProvider.addPostToDb(post);

  Future<void> deletePost(String postid, String userid) =>
      _firebaseProvider.deletePost(postid, userid);

  Future<PicitUser> retrieveUserDetails(User user) =>
      _firebaseProvider.retrieveUserDetails(user);

  Future<bool> removeAccount() => _firebaseProvider.removeAccount();

  Future<bool> isLiked({String uid, DocumentSnapshot documentSnapshot}) =>
      _firebaseProvider.isLiked(uid: uid, documentSnapshot: documentSnapshot);

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) =>
      _firebaseProvider.retrieveUserPosts(userId);

  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) =>
      _firebaseProvider.fetchPostLikeDetails(reference);

  Future<bool> checkIfUserLikedOrNot(
          String userId, DocumentReference reference) =>
      _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

  Future<List<DocumentSnapshot>> retrievePosts(String type) =>
      _firebaseProvider.retrievePosts(type);

  Future<List<DocumentSnapshot>> retrieveFavouritePosts(String id) =>
      _firebaseProvider.retrieveFavouritePosts(id);

  Future<List<String>> fetchAllUserNames(User user) =>
      _firebaseProvider.fetchAllUserNames(user);

  Future<List<String>> uploadImagesToStorage(List<File> _images, String type) =>
      _firebaseProvider.uploadImagesToStorage(_images, type);

  Future<List<DocumentSnapshot>> fetchStats(
          {String uid = "", String label = ""}) =>
      _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<int> fetchLikeStats({String uid = "", String label = ""}) =>
      _firebaseProvider.fetchLikeStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String name, String city,
          String country, String phone, String bio, String email) =>
      _firebaseProvider.updateDetails(
          uid, name, city, country, phone, bio, email);
}
