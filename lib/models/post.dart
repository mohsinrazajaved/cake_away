import 'package:intl/intl.dart';

class Post {
  String currentUserUid;
  String postid;

  String type;
  String description;
  String title;
  String city;
  String country;
  String price;
  String phonenumber;
  String eventDate;
  String dateTime;
  String postOwnerName;
  String postOwnerPhotoUrl;
  DateTime time;
  bool isliked;
  int totalLikes;
  List<String> likeUids;
  List<String> favouroites;
  List<String> imagesUrls;

  Post({
    this.currentUserUid,
    this.postid,
    this.type,
    this.eventDate,
    this.dateTime,
    this.time,
    this.title,
    this.description,
    this.city,
    this.country,
    this.price,
    this.phonenumber,
    this.postOwnerName,
    this.postOwnerPhotoUrl,
    this.isliked,
    this.totalLikes,
    this.likeUids,
    this.favouroites,
    this.imagesUrls,
  });

  Map<String, dynamic> toJson(Post post) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = post.currentUserUid;
    data['postid'] = post.postid;
    data['eventDate'] = post.eventDate;
    data['dateTime'] = post.dateTime;
    data['title'] = post.title;
    data['time'] = post.time;
    data['city'] = post.city;
    data['description'] = post.description;
    data['country'] = post.country;
    data['price'] = post.price;
    data['phonenumber'] = post.phonenumber;

    data['type'] = post.type;

    data['postOwnerName'] = post.postOwnerName;
    data['isLiked'] = post.isliked;
    data['totalLikes'] = post.totalLikes;
    data['likeUids'] = post.likeUids;
    data['favouroites'] = post.favouroites;
    data["imagesUrls"] = post.imagesUrls;
    return data;
  }

  Post.fromJson(Map<String, dynamic> mapData) {
    this.currentUserUid = mapData['ownerUid'];
    this.title = mapData['title'];
    this.description = mapData['description'];
    this.eventDate = mapData['eventDate'];
    this.city = mapData['city'];
    this.country = mapData['country'];
    this.price = mapData['price'];
    this.phonenumber = mapData['phonenumber'];
    this.type = mapData['type'];
    this.postid = mapData['postid'];
    this.dateTime = mapData['dateTime'];

    this.postOwnerName = mapData['postOwnerName'];
    this.time = DateFormat('dd-MM-yyyy HH:mm')?.parse(mapData['dateTime']);
    this.isliked = mapData['isLiked'];
    this.totalLikes = mapData['totalLikes'];

    if (mapData['imagesUrls'] != null) {
      this.imagesUrls = mapData['imagesUrls'].cast<String>();
    }
    if (mapData['likeUids'] != null) {
      this.likeUids = mapData['likeUids'].cast<String>();
    }
    if (mapData['favouroites'] != null) {
      this.favouroites = mapData['favouroites'].cast<String>();
    }
  }
}
