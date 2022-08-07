// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:picit/Utilities/constants.dart';

// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   Widget _buildEmailTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Email',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Email',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNameTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Name',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             keyboardType: TextInputType.name,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.person,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Name',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Password',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             obscureText: true,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Password',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildConfirmPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Confirm Password',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 60.0,
//           child: TextField(
//             obscureText: true,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Password',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginBtn() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 25.0),
//       width: double.infinity,
//       child: RaisedButton(
//         elevation: 5.0,
//         onPressed: () => print('Signup Button Pressed'),
//         padding: EdgeInsets.all(15.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         color: Colors.white,
//         child: Text(
//           'SIGNUP',
//           style: TextStyle(
//             color: Color(0xFF527DAA),
//             letterSpacing: 1.5,
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: new Color(0xfff8faf8),
//           elevation: 1,
//           title: Text('Profile'),
//           actions: <Widget>[
//             IconButton(
//               icon: Icon(Icons.settings_power),
//               color: Colors.black,
//               onPressed: () {
//                 // _repository.signOut().then((v) {
//                 //   Navigator.pushReplacement(context,
//                 //       MaterialPageRoute(builder: (context) {
//                 //     return MyApp();
//                 //   }));
//                 // });
//               },
//             )
//           ],
//         ),
//         body: 
//         // _user != null
//         //     ? 
//             ListView(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0, left: 20.0),
//                         child: Container(
//                             width: 110.0,
//                             height: 110.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(80.0),
//                               image: DecorationImage(
//                                   image: _user.photoUrl.isEmpty
//                                       ? AssetImage('assets/no_image.png')
//                                       : NetworkImage(_user.photoUrl),
//                                   fit: BoxFit.cover),
//                             )),
//                       ),
                      
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Column(
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 StreamBuilder(
//                                   stream: _repository
//                                       .fetchStats(
//                                           uid: _user.uid, label: 'posts')
//                                       .asStream(),
//                                   builder: ((context,
//                                       AsyncSnapshot<List<DocumentSnapshot>>
//                                           snapshot) {
//                                     if (snapshot.hasData) {
//                                       return detailsWidget(
//                                           snapshot.data.length.toString(),
//                                           'posts');
//                                     } else {
//                                       return Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }
//                                   }),
//                                 ),
//                                 StreamBuilder(
//                                   stream: _repository
//                                       .fetchStats(
//                                           uid: _user.uid, label: 'followers')
//                                       .asStream(),
//                                   builder: ((context,
//                                       AsyncSnapshot<List<DocumentSnapshot>>
//                                           snapshot) {
//                                     if (snapshot.hasData) {
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 24.0),
//                                         child: detailsWidget(
//                                             snapshot.data.length.toString(),
//                                             'followers'),
//                                       );
//                                     } else {
//                                       return Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }
//                                   }),
//                                 ),
//                                 StreamBuilder(
//                                   stream: _repository
//                                       .fetchStats(
//                                           uid: _user.uid, label: 'following')
//                                       .asStream(),
//                                   builder: ((context,
//                                       AsyncSnapshot<List<DocumentSnapshot>>
//                                           snapshot) {
//                                     if (snapshot.hasData) {
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 20.0),
//                                         child: detailsWidget(
//                                             snapshot.data.length.toString(),
//                                             'following'),
//                                       );
//                                     } else {
//                                       return Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }
//                                   }),
//                                 ),
//                               ],
//                             ),
//                             GestureDetector(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 12.0, left: 20.0, right: 20.0),
//                                 child: Container(
//                                   width: 210.0,
//                                   height: 30.0,
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(4.0),
//                                       border: Border.all(color: Colors.grey)),
//                                   child: Center(
//                                     child: Text('Edit Profile',
//                                         style: TextStyle(color: Colors.black)),
//                                   ),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.push(context, MaterialPageRoute(
//                                   builder: ((context) => EditProfileScreen(
//                                     photoUrl: _user.photoUrl,
//                                     email: _user.email,
//                                     bio: _user.bio,
//                                     name: _user.displayName,
//                                     phone: _user.phone
//                                   ))
//                                 ));
//                               },
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 25.0, top: 30.0),
//                     child: Text(_user.displayName,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20.0)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 25.0, top: 10.0),
//                     child: _user.bio.isNotEmpty ? Text(_user.bio) : Container(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12.0),
//                     child: Divider(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         GestureDetector(
//                           child: Icon(
//                             Icons.grid_on,
//                             color: _gridColor,
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _isGridActive = true;
//                               _gridColor = Colors.blue;
//                               _listColor = Colors.grey;
//                             });
//                           },
//                         ),
//                         GestureDetector(
//                           child: Icon(
//                             Icons.stay_current_portrait,
//                             color: _listColor,
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _isGridActive = false;
//                               _listColor = Colors.blue;
//                               _gridColor = Colors.grey;
//                             });
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12.0),
//                     child: Divider(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: postImagesWidget(),
//                   ),
//                 ],
//               )
//             : Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
