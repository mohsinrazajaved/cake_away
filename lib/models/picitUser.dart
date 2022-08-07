class PicitUser {
  String uid;
  String email;
  String photoUrl;
  String displayName;
  String followers;
  String following;
  String posts;
  String bio;
  String phone;
  String country;
  String city;

  PicitUser({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.followers,
    this.following,
    this.bio,
    this.posts,
    this.phone,
    this.country,
    this.city,
  });

  Map<String, dynamic> toMap(PicitUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['followers'] = user.followers;
    data['following'] = user.following;
    data['bio'] = user.bio;
    data['posts'] = user.posts;
    data['phone'] = user.phone;
    data['country'] = user.country;
    data['city'] = user.city;
    return data;
  }

  PicitUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.bio = mapData['bio'];
    this.posts = mapData['posts'];
    this.phone = mapData['phone'];
    this.country = mapData['country'];
    this.city = mapData['city'];
  }

  static bool isPasswordValid(String text) {
    return text.replaceAll(new RegExp(r"\s+"), "").length > 0;
  }

  static bool isEmailValid(String text) {
    if (text.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static bool isUsernameValid(String text) {
    return text.replaceAll(new RegExp(r"\s+"), "").length > 0;
  }

  static bool isConfirmPassword(String oldText, String newText) {
    return oldText == newText;
  }

  static bool isNotEmpty(String text) {
    return !text.isEmpty;
  }
}
