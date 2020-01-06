import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Manage/addProduct.dart';
import 'package:sellerapp/Screen/Notfication.dart';
import 'package:sellerapp/Screen/productList.dart';
import 'package:sellerapp/Screen/settings.dart';
import 'package:sellerapp/model/db/brand.dart';
import 'package:sellerapp/model/db/category.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/dbapi.dart';
import 'LoginOrSignUp/Signup.dart';
import 'package:sellerapp/service/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum Page { dashboard, manage } // look here

class Admin extends StatefulWidget {
  Admin({this.username, this.emailIds, this.imageUrls, this.usernameSign});

  final String emailIds;
  final String imageUrls;
  final String username;
  final String usernameSign;

  @override
  _AdminState createState() => _AdminState();
}

var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);
var _txtEdit = _txt.copyWith(color: Colors.black26, fontSize: 15.0);

/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);

class _AdminState extends State<Admin> {
  Color active = Colors.deepPurple[400];
  final authService = AuthService();
  TextEditingController brandController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  MaterialColor notActive = Colors.grey;

  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();
  Page _selectedPage = Page.dashboard;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: notifiy
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> massage) async {
        print("Massage: $massage");
      },
      onResume: (Map<String, dynamic> massage) async {
        print("Massage: $massage");
      },
      onLaunch: (Map<String, dynamic> massage) async {
        print("Massage: $massage");
      },
      // onBackgroundMessage: (Map<String, dynamic> massage) async {
      //   print("Massage: $massage");
      // },
    );
  }

  Text buildText(username, User user, String usernameindb) {
    setState(() {});
    if (username != null) {
      return Text(
        username,
        style: _txtName,
      );
      // } else if ( username == null) {
      //   return Text(
      //     "Guest person",
      //     style: _txtName,
      //   );
      // } else if(authService.signAnon() != null){
      //   return Text(
      //     "Hello",
      //     style: _txtName,
      //   );
    } else {
      var email = user?.emailId;
      return Text(
          (email == null)
              ? "Guest person"
              : (email != null) ? usernameindb ?? "" : "Something Wents Wrong",
          style: _txtName);
    }
  }

  void _categoryAlert(BuildContext context) {
    var alert = AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          inputFormatters: [
            BlacklistingTextInputFormatter(" "),
            LengthLimitingTextInputFormatter(8)
          ],
          controller: categoryController,
          validator: (value) {
            assert(value != null);
            if (value.isEmpty) {
              return 'category cannot be empty';
            } else {
              return "Samething Went Wrong";
            }
          },
          decoration: InputDecoration(hintText: "add category"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                _categoryService.createCategory(categoryController.text);
                Fluttertoast.showToast(msg: 'category created');
                categoryController.clear();
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                Fluttertoast.showToast(msg: "Please Enter Category");
              }
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              //Navigator.of(context).pop();
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(
        useRootNavigator: true,
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => alert);
  }

  void _brandAlert(BuildContext context) {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            } else {
              return "Samething Went Wrong";
            }
          },
          decoration: InputDecoration(hintText: "add brand"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (brandController.text.isNotEmpty) {
                _brandService.createBrand(brandController.text);
                Fluttertoast.showToast(msg: 'brand added');
                Navigator.of(context, rootNavigator: true).pop();
                brandController.clear();
              } else {
                Fluttertoast.showToast(msg: "Please Enter Brand");
              }
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final datas = Admin(
      imageUrls: user?.imageUrl,
      username: (user?.name == "") ? null : user?.name,
      emailIds: (user?.emailId == "") ? null : user?.emailId,
    );
    UserDetails userDetails = Provider.of<UserDetails>(context, listen: false);
    // var ldos = Provider.of<List<UserDetails>>(context);
    var profile = Padding(
      padding: EdgeInsets.only(
        top: 140.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.5),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(datas.imageUrls ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROEN04MBFWtD4MOMdV2TTH8rWsjlI1U0ZFVZMQoP1S6SwMDq9N&s" ??
                            ""),
                        fit: BoxFit.fill)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: buildText(datas?.username, user, userDetails?.userName),
              ),
              InkWell(
                onTap: () {
                  if (datas.emailIds == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Signup()));
                  } else if (datas.emailIds != null) {
                    Fluttertoast.showToast(msg: "Our Feature is Coming soon");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    datas.emailIds ?? "Click Here To SignUp",
                    style: _txtEdit,
                  ),
                ),
              )

              // FlatButton(
              //   child: Text("data"),
              //   onPressed: () {
              //   },
              // )
            ],
          ),
          Container(),
        ],
      ),
    );

    Widget _loadScreen(BuildContext context) {
      switch (_selectedPage) {
        case Page.dashboard:
          //   List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
          //   String _selectedLocation; // Option 2

          return SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: InkWell(
                          onTap: () {},
                          child: Text(
                              "Shri Ram Janmbhumi, Sai Nagar, Ayodhya, Uttar Pradesh 224123")),
                      // leading: Icon(
                      //   Icons.location_searching,
                      //   color: active,
                      // ),
                      subtitle: InkWell(
                          onTap: () {},
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Text("128 Days Left"),
                                Text(
                                  "#1-Premium Package",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )),
                      dense: true,
                      trailing: Container(
                          child: InkWell(
                        onTap: () {
                          print("App");
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.location_on,
                                  color: active,
                                ),
                              ),
                              // Expanded(child: Text("10 KM")),
                              Expanded(
                                flex: 3,
                                child: DropdownButton<String>(
                                  items: <String>[
                                    '10Km',
                                    '20Km',
                                    '30Km',
                                    '40Km'
                                  ].map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (_) {},
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                          //     Icon(
                          //   Icons.location_on,
                          //   color: active,
                          // )
                          ),
                      // subtitle: Container(
                      //   alignment: Alignment.centerRight,
                      //   child: DropdownButton(
                      //     hint: Text('5km'), // Not necessary for Option 1
                      //     value: _selectedLocation,
                      //     onChanged: (newValue) {
                      //       setState(() {
                      //         _selectedLocation = newValue;
                      //       });
                      //     },
                      //     items: _locations.map((location) {
                      //       return DropdownMenuItem(
                      //         child: new Text(location),
                      //         value: location,
                      //       );
                      //     }).toList(),
                      //   ),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("ProductListID")
                        .document(user.uid)
                        .collection(user.uid)
                        .where("PersonID", isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data.documents.length > 0) {
                        return Expanded(
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                  child: Card(
                                      child: ListTile(
                                          title: FlatButton.icon(
                                              onPressed: () async {
                                                DeviceInfoPlugin deviceInfo =
                                                    DeviceInfoPlugin();
                                                AndroidDeviceInfo androidInfo =
                                                    await deviceInfo
                                                        .androidInfo;
                                                print(
                                                    'Running on ${androidInfo.product}');

                                                // print(
                                                //     'Running on ${androidInfo.androidId}');
                                                // print(
                                                //     'Running on ${androidInfo.brand}');
                                                // print(
                                                //     'Running on ${androidInfo.device}');
                                                // print(
                                                //     'Running on ${androidInfo.id}');
                                                print(
                                                    'Running on ${androidInfo.model}');
                                                print(
                                                    'Running on ${androidInfo.manufacturer}');
                                                //   print(
                                                // 'Running on ${androidInfo.fingerprint}');
                                              },
                                              icon: Icon(
                                                Icons.category,
                                                color: active,
                                              ),
                                              label: Text("Category")),
                                          subtitle: Text(
                                            '16',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: active, fontSize: 60.0),
                                          )))),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                child: Card(
                                  child: ListTile(
                                      title: FlatButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.people_outline,
                                            color: active,
                                          ),
                                          label: Text("Users")),
                                      subtitle: Text(
                                        '7',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: active, fontSize: 60.0),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                child: Card(
                                  child: ListTile(
                                      title: FlatButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.track_changes,
                                            color: active,
                                          ),
                                          label: Text("Products")),
                                      subtitle: Text(
                                        snapshot.data.documents.length
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: active, fontSize: 60.0),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                child: Card(
                                  child: ListTile(
                                      title: FlatButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.tag_faces,
                                            color: active,
                                          ),
                                          label: Text("Sold")),
                                      subtitle: Text(
                                        '23',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: active, fontSize: 60.0),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                child: Card(
                                  child: ListTile(
                                      title: FlatButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            color: active,
                                          ),
                                          label: Text("Orders")),
                                      subtitle: Text(
                                        '4',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: active, fontSize: 60.0),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 5, 5),
                                child: Card(
                                  child: ListTile(
                                      title: FlatButton.icon(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.close,
                                            color: active,
                                          ),
                                          label: Text("Return")),
                                      subtitle: Text(
                                        '1',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: active, fontSize: 60.0),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 150,
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              backgroundColor: active,
                            )),
                            SizedBox(
                              height: 90,
                            ),
                            Text(
                              "If Want To See Dashboard Add Minimum One Products",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        );
                      }
                    }),
              ],
            ),
          );
          break;
        case Page.manage:
          final authService = Provider.of<AuthService>(context);
          return ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://images.unsplash.com/photo-1455894127589-22f75500213a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=679&q=80"),
                            fit: BoxFit.cover)),
                  ),
                  profile
                ],
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Add product"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AddProduct()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.format_list_numbered),
                title: Text("Products list"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductList();
                  }));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.view_list),
                title: Text("Oders List"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductList();
                  }));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add_circle),
                title: Text("Add category"),
                onTap: () {
                  _categoryAlert(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.category),
                title: Text("Category list"),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text("Add brand"),
                onTap: () {
                  _brandAlert(context); // function using here but not working
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text("brand list"),
                onTap: () {
                  _brandService.getBrands();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Settings()));
                },
              ),
              Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    highlightedBorderColor: Colors.purple,
                    highlightElevation: 1,
                    splashColor: Colors.purple[300],
                    child: Text(
                      "Logout",
                    ),
                    onPressed: () async {
                      showDialog(
                          context: _scaffoldKey.currentContext,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are You Sure?"),
                              content: Text(
                                  "Are You Sure To Logout From This App??"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    dynamic result =
                                        authService.signOut().whenComplete(() {
                                      Navigator.pop(context);
                                    });

                                    if (result == null) {
                                      setState(() {
                                        Fluttertoast.showToast(
                                            msg: "Oops! Samething went wrong!");
                                      });
                                    } else if (result != null) {
                                      setState(() {
                                        Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    new Signup()));
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Succesfull logout!");
                                    }
                                  },
                                  child: Text("Yes"),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                )
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ],
          );
          break;
        default:
          return Container();
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.dashboard);
                    },
                    icon: Icon(
                      Icons.dashboard,
                      color:
                          _selectedPage == Page.dashboard ? active : notActive,
                    ),
                    label: Text('Dashboard')),
              ),
              Expanded(
                child: FlatButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.manage);
                    },
                    icon: Icon(
                      Icons.sort,
                      color: _selectedPage == Page.manage ? active : notActive,
                    ),
                    label: Text('Manage')),
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.grey,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NotificationO()));
                },
              ),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white, // status bar color
          brightness: Brightness.light,
        ),
        body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text("Double Tap To Exit"),
            ),
            child: _loadScreen(context)));
  }
}
