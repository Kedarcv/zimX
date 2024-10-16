import 'package:untitled1/consts/colors.dart'; // Ensure this file exists with appropriate class
// Ensure this file exists
import 'package:untitled1/provider/dark_theme_provider.dart'; // Ensure this file exists
// Ensure this file exists
// Ensure this file exists
// Ensure this file exists
// Ensure this file exists
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid = '';
  String _name = '';
  String _email = '';
  String _joinedAt = '';
  String _userImageUrl = '';
  String _phoneNumber = '';
  String _userItem = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _uid = user.uid;

      if (!user.isAnonymous) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc.get('name') ?? '';
            _email = user.email ?? '';
            _joinedAt = userDoc.get('joinedAt') ?? '';
            _phoneNumber = userDoc.get('phoneNumber')?.toString() ?? '';
            _userImageUrl = userDoc.get('imageUrl') ?? '';
            _userItem = userDoc.get('User Bag') ?? '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorsConsts.starterColor,
                          ColorsConsts.endColor,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: top <= 110.0 ? 1.0 : 0,
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Container(
                              height: kToolbarHeight / 1.8,
                              width: kToolbarHeight / 1.8,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 1.0,
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(_userImageUrl.isEmpty
                                      ? 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'
                                      : _userImageUrl),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              _name.isEmpty ? 'Guest' : _name,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      background: Image(
                        image: NetworkImage(_userImageUrl.isEmpty
                            ? 'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'
                            : _userImageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),

                    // Add additional user-related widgets here if needed.
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
