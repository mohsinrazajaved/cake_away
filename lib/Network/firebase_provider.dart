import 'dart:io';

import 'package:cake_away/models/like.dart';
import 'package:cake_away/models/picitUser.dart';
import 'package:cake_away/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  PicitUser user;
  Post post;
  Like like;

  Future<void> addDataToDb(User currentUser,
      {String name, String phonenumber, String country, String city}) async {
    print("Inside addDataToDb Method");

    user = PicitUser(
      uid: currentUser.uid,
      email: currentUser.email,
      displayName: currentUser.displayName ?? name,
      photoUrl: currentUser.photoURL ?? "",
      followers: '0',
      following: '0',
      bio: '',
      posts: '0',
      phone: phonenumber,
      country: country,
      city: city,
    );

    return _firestore
        .collection("users")
        .doc(currentUser.uid)
        .set(user?.toMap(user));
  }

  Future<bool> authenticateUser(User user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  User getCurrentUser() {
    User currentUser;
    currentUser = _auth.currentUser;
    print("EMAIL ID : ${currentUser?.email ?? ""}");
    return currentUser;
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<String> signIn(String email, String password) async {
    User user;
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          return "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
          break;
        default:
          return "Login failed. Please try again.";
          break;
      }
    }

    return null;
  }

  Future<User> registerUser(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<List<String>> uploadImagesToStorage(
      List<File> _images, String type) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => _uploadFile(_image, type)));
    return imageUrls;
  }

  Future<String> _uploadFile(File _image, String type) async {
    var _storageReference =
        FirebaseStorage.instance.ref().child('$type/${_image.path}');
    UploadTask storageUploadTask = _storageReference.putFile(_image);
    return await (await storageUploadTask).ref.getDownloadURL();
  }

  Future<void> addPostToDb(
    Post post,
  ) {
    DocumentReference _collectionRef = _firestore.collection("posts").doc();

    // post = Post(
    //   currentUserUid: currentUser.uid,
    //   url: imgUrl,
    //   thumburl: thumburl,
    //   type: type,
    //   title: title,
    //   dateTime: datetime,
    //   caption: caption,
    //   locationLat: lat,
    //   locationLong: long,
    //   postOwnerName: name ?? "",
    //   postOwnerPhotoUrl: currentUser?.photoURL ?? "",
    //   totalLikes: 0,
    //   isLive: isLive,
    //   liveEnddateTime: endLiveTime,
    //   postid: _collectionRef.id,
    // );
    post.postid = _collectionRef.id;
    return _collectionRef.set(post?.toJson(post));
  }

  Future<PicitUser> retrieveUserDetails(User user) async {
    DocumentSnapshot _documentSnapshot =
        await _firestore.collection("users").doc(user?.uid).get();
    return PicitUser.fromMap(_documentSnapshot.data());
  }

  Future<bool> removeAccount() async {
    var user = _auth.currentUser;
    user.delete();
    return Future.value(true);
  }

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) async {
    QuerySnapshot querySnapshot = await _firestore.collection("posts").get();
    return querySnapshot.docs?.where((e) => e["ownerUid"] == userId)?.toList();
  }

  Future<void> deletePost(String postid, String userid) async {
    DocumentReference queryReference =
        _firestore.collection("posts").doc(postid);
    queryReference.delete();
  }

  Future<List<DocumentSnapshot>> retrieveFavouritePosts(String userId) async {
    // QuerySnapshot querySnapshot = await _firestore
    //     .collection("users")
    //     .doc(userId)
    //     .collection("posts")
    //     .where("favouroites", arrayContains: userId)
    //     .get();
    List<DocumentSnapshot> list = [];
    // List<DocumentSnapshot> updatedList = [];
    // QuerySnapshot querySnapshot;
    QuerySnapshot snapshot = await _firestore.collection("posts").get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      list.add(snapshot.docs[i]);
    }

    // for (var i = 0; i < list.length; i++) {
    //   querySnapshot = await list[i].reference.collection("posts").get();
    //   for (var i = 0; i < querySnapshot.docs.length; i++) {
    //     updatedList.add(querySnapshot.docs[i]);
    //   }

    return list.where((e) {
      if (e.exists) {
        List<String> ids = (e.data()["favouroites"] ?? []).cast<String>();

        if (ids.contains(userId)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).toList();
  }

  Future<List<DocumentSnapshot>> fetchPostLikeDetails(
      DocumentReference reference) async {
    print("REFERENCE : ${reference.path}");
    QuerySnapshot snapshot = await reference.collection("likes").get();
    return snapshot.docs;
  }

  Future<bool> checkIfUserLikedOrNot(
      String userId, DocumentReference reference) async {
    DocumentSnapshot snapshot =
        await reference.collection("likes").doc(userId).get();
    print('DOC ID : ${snapshot.reference.path}');
    return snapshot.exists;
  }

  Future<List<DocumentSnapshot>> retrievePosts(String type) async {
    List<DocumentSnapshot> list = [];
    List<DocumentSnapshot> updatedList = [];
    QuerySnapshot snapshot = await _firestore
        .collection("posts")
        .where("type", isEqualTo: type)
        .get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      list.add(snapshot.docs[i]);
    }

    return list;
  }

  Future<List<String>> fetchAllUserNames(User user) async {
    List<String> userNameList = [];
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userNameList.add(querySnapshot.docs[i].data()['displayName']);
      }
    }
    print("USERNAMES LIST : ${userNameList.length}");
    return userNameList;
  }

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("users").doc(uid).collection(label).get();
    return querySnapshot.docs;
  }

  Future<int> fetchLikeStats({String uid, String label}) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("users").doc(uid).collection("posts").get();
    int likes = 0;
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      likes += querySnapshot.docs[i].data()['totalLikes'];
    }

    return likes;
  }

  Future<bool> isLiked({String uid, DocumentSnapshot documentSnapshot}) async {
    QuerySnapshot querySnapshot =
        await documentSnapshot.reference.collection("likes").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].data()['ownerUid'] == uid) {
        return true;
      }
    }

    return false;
  }

  Future<void> updatePhoto(String photoUrl, String uid) async {
    Map<String, dynamic> map = Map();
    map['photoUrl'] = photoUrl;
    return _firestore.collection("users").doc(uid).update(map);
  }

  Future<void> updateDetails(String uid, String name, String city,
      String country, String phone, String bio, String email) async {
    Map<String, dynamic> map = Map();
    map['displayName'] = name;
    map['bio'] = bio;
    map['city'] = city;
    map['country'] = country;
    map['phone'] = phone;
    map['email'] = email;
    return _firestore.collection("users").doc(uid).update(map);
  }

//   Future<List<String>> fetchUserNames(FirebaseUser user) async {
//     DocumentReference documentReference =
//         _firestore.collection("messages").document(user.uid);
//     List<String> userNameList = List<String>();
//     List<String> chatUsersList = List<String>();
//     QuerySnapshot querySnapshot =
//         await _firestore.collection("users").getDocuments();
//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       if (querySnapshot.documents[i].documentID != user.uid) {
//         print("USERNAMES : ${querySnapshot.documents[i].documentID}");
//         userNameList.add(querySnapshot.documents[i].documentID);
//         //querySnapshot.documents[i].reference.collection("collectionPath");
//         //userNameList.add(querySnapshot.documents[i].data['displayName']);
//       }
//     }

//     for (var i = 0; i < userNameList.length; i++) {
//       if (documentReference.collection(userNameList[i]) != null) {
//         if (documentReference.collection(userNameList[i]).getDocuments() !=
//             null) {
//           print("CHAT USERS : ${userNameList[i]}");
//           chatUsersList.add(userNameList[i]);
//         }
//       }
//     }

//     print("CHAT USERS LIST : ${chatUsersList.length}");

//     return chatUsersList;

//     // print("USERNAMES LIST : ${userNameList.length}");
//     // return userNameList;
//   }

//   Future<List<User>> fetchAllUsers(FirebaseUser user) async {
//     List<User> userList = List<User>();
//     QuerySnapshot querySnapshot =
//         await _firestore.collection("users").getDocuments();
//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       if (querySnapshot.documents[i].documentID != user.uid) {
//         userList.add(User.fromMap(querySnapshot.documents[i].data));
//         //userList.add(querySnapshot.documents[i].data[User.fromMap(mapData)]);
//       }
//     }
//     print("USERSLIST : ${userList.length}");
//     return userList;
//   }

//   void uploadImageMsgToDb(String url, String receiverUid, String senderuid) {
//     _message = Message.withoutMessage(
//         receiverUid: receiverUid,
//         senderUid: senderuid,
//         photoUrl: url,
//         timestamp: FieldValue.serverTimestamp(),
//         type: 'image');
//     var map = Map<String, dynamic>();
//     map['senderUid'] = _message.senderUid;
//     map['receiverUid'] = _message.receiverUid;
//     map['type'] = _message.type;
//     map['timestamp'] = _message.timestamp;
//     map['photoUrl'] = _message.photoUrl;

//     print("Map : ${map}");
//     _firestore
//         .collection("messages")
//         .document(_message.senderUid)
//         .collection(receiverUid)
//         .add(map)
//         .whenComplete(() {
//       print("Messages added to db");
//     });

//     _firestore
//         .collection("messages")
//         .document(receiverUid)
//         .collection(_message.senderUid)
//         .add(map)
//         .whenComplete(() {
//       print("Messages added to db");
//     });
//   }

//   Future<void> addMessageToDb(Message message, String receiverUid) async {
//     print("Message : ${message.message}");
//     var map = message.toMap();

//     print("Map : $map");
//     await _firestore
//         .collection("messages")
//         .document(message.senderUid)
//         .collection(receiverUid)
//         .add(map);

//     return _firestore
//         .collection("messages")
//         .document(receiverUid)
//         .collection(message.senderUid)
//         .add(map);
//   }

//   Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) async {
//     List<String> followingUIDs = List<String>();
//     List<DocumentSnapshot> list = List<DocumentSnapshot>();

//     QuerySnapshot querySnapshot = await _firestore
//         .collection("users")
//         .document(user.uid)
//         .collection("following")
//         .getDocuments();

//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       followingUIDs.add(querySnapshot.documents[i].documentID);
//     }

//     print("FOLLOWING UIDS : ${followingUIDs.length}");

//     for (var i = 0; i < followingUIDs.length; i++) {
//       print("SDDSSD : ${followingUIDs[i]}");

//       //retrievePostByUID(followingUIDs[i]);
//       // fetchUserDetailsById(followingUIDs[i]);

//       QuerySnapshot postSnapshot = await _firestore
//           .collection("users")
//           .document(followingUIDs[i])
//           .collection("posts")
//           .getDocuments();
//       // postSnapshot.documents;
//       for (var i = 0; i < postSnapshot.documents.length; i++) {
//         print("dad : ${postSnapshot.documents[i].documentID}");
//         list.add(postSnapshot.documents[i]);
//         print("ads : ${list.length}");
//       }
//     }

//     return list;
//   }

//   Future<List<String>> fetchFollowingUids(FirebaseUser user) async {
//     List<String> followingUIDs = List<String>();

//     QuerySnapshot querySnapshot = await _firestore
//         .collection("users")
//         .document(user.uid)
//         .collection("following")
//         .getDocuments();

//     for (var i = 0; i < querySnapshot.documents.length; i++) {
//       followingUIDs.add(querySnapshot.documents[i].documentID);
//     }

//     for (var i = 0; i < followingUIDs.length; i++) {
//       print("DDDD : ${followingUIDs[i]}");
//     }
//     return followingUIDs;
//   }
}
