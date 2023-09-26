// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:flutter/material.dart';

class RegisterHeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showIcon;
  final IconData _icon;

  const RegisterHeaderWidget(this._height, this._showIcon, this._icon,{Key? key})
      : super(key: key);

  @override
  _RegisterHeaderWidgetState createState() =>
      _RegisterHeaderWidgetState(_height, _showIcon, _icon);
}

class _RegisterHeaderWidgetState extends State<RegisterHeaderWidget> {
  final double _height;
  final bool _showIcon;
  final IconData _icon;



  _RegisterHeaderWidgetState(this._height, this._showIcon, this._icon);

  late Role _selectedRole;
  final List<Role> roles = [
    Role(name: 'User', icon: Icons.person),
    Role(name: 'Manager', icon: Icons.manage_accounts),
    Role(name: 'Rider', icon: Icons.electric_bike_outlined),
    Role(name: 'Admin', icon: Icons.admin_panel_settings),


  ];

  @override
  void initState() {
    super.initState();
    _selectedRole = roles.first;
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5, _height - 60),
              Offset(width / 5 * 4, _height + 20),
              Offset(width, _height - 18)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: ShapeClipper([
              Offset(width / 3, _height + 20),
              Offset(width / 10 * 8, _height - 60),
              Offset(width / 5 * 4, _height - 60),
              Offset(width, _height - 20)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - 40),
              Offset(width / 5 * 4, _height - 80),
              Offset(width, _height - 20)
            ]),
          ),
          Visibility(
            visible: _showIcon,
            child: Container(
                height: _height - 40,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width*0.15,
                    ),
                    Container(

                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        top: 20.0,
                        right: 5.0,
                        bottom: 20.0,
                      ),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                        border: Border.all(width: 5, color: Colors.white),
                      ),
                      child: Icon(
                        _icon,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),

                    Container(
                      width: width*0.1,
                      child: PopupMenuButton<Role>(
                        icon: Icon(Icons.menu,color: Colors.white,),
                        onSelected: (Role value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return roles.map((Role role) {
                            return PopupMenuItem<Role>(
                              value: role,
                              child: Row(
                                children: [
                                  Icon(role.icon),
                                  SizedBox(width: 8.0),
                                  Text(role.name),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class Role {
  final String name;
  final IconData icon;

  Role({required this.name, required this.icon});
}
/*
Future<void> _signInWithEmailAndPassword() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Check the user's role in Firestore and navigate to the appropriate screen
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        if (data['role'] == 'student') {
          Navigator.pushNamed(context, '/student');
        } else if (data['role'] == 'teacher') {
          Navigator.pushNamed(context, '/teacher');
        } else if (data['role'] == 'admin') {
          Navigator.pushNamed(context, '/admin');
        }
      }
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}*/
