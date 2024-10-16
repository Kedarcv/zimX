import 'package:untitled1/consts/colors.dart';
import 'package:untitled1/screens/home.dart';
import 'package:untitled1/screens/auth/login.dart';
import 'package:untitled1/screens/auth/sign_up.dart';
import 'package:untitled1/screens/bottom_bar.dart';
import 'package:untitled1/services/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return PageView(
            children: [LandingPage(), BottomBarScreen()],
          );
        },
      ),
    );
  }
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> images = [
    'https://media.istockphoto.com/photos/man-at-the-shopping-picture-id868718238?k=6&m=868718238&s=612x612&w=0&h=ZUPCx8Us3fGhnSOlecWIZ68y3H4rCiTnANtnjHk0bvo=',
    'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
    'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateparse = DateTime.parse(date);
          var formattedDate =
              "${dateparse.day}-${dateparse.month}-${dateparse.year}";
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'imageUrl': authResult.user!.photoURL,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
        }
      }
    }
  }

  void _loginAnonymously() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInAnonymously();
    } catch (error) {
      _globalMethods.authErrorHandle(error.toString(), context);
      print('error occurred ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRoleSelectionDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose your role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (action == 'login') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(userChoice: 'shopper')));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  }
                },
                child: Text('Shopper'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (action == 'login') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(userChoice: 'shop')));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  }
                },
                child: Text('Shop'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      CachedNetworkImage(
        imageUrl: images[1],
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: FractionalOffset(_animation.value, 0),
      ),
      Container(
        margin: EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'ZimXpress',
              style: TextStyle(
                color: Colors.orange[500],
                fontSize: 50,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Welcome ZimXpress, the biggest online store in Zimbabwe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome()));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        shape: StadiumBorder(),
                        side: BorderSide(width: 2, color: Colors.blue),
                      ),
                      child: Text('Just want to explore'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: ColorsConsts.backgroundColor),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _showRoleSelectionDialog(context, 'login');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.user,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.pink.shade400),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side:
                                BorderSide(color: ColorsConsts.backgroundColor),
                          ),
                        )),
                    onPressed: () {
                      _showRoleSelectionDialog(context, 'signup');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign up',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Feather.user_plus,
                          size: 18,
                        )
                      ],
                    )),
              ),
              SizedBox(width: 10),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
              ),
              Text(
                'Or continue with',
                style: TextStyle(color: Colors.black),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () async {
                  bool success =  _googleSignIn() as bool;
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserHome()),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  side: BorderSide(width: 2, color: Colors.red),
                ),
                child: Text('Google +'),
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: () {
                        _loginAnonymously();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(width: 2, color: Colors.deepPurple),
                      ),
                      child: Text('Sign in as a guest'),
                    ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    ]));
  }
}