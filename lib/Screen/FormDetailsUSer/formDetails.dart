import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/wrapper/Wrapper.dart';
import 'package:sellerapp/Screen/locations/user_location.dart';
import 'package:sellerapp/Screen/FormDetailsUser/validator.dart';
import 'package:sellerapp/Screen/widget/commonwidgets.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/auth.dart';
import 'package:sellerapp/service/streamfiles.dart';
import 'package:location/location.dart';
import 'package:sellerapp/MainFinal.dart';

class FormDetails extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _FormDetailsState createState() => _FormDetailsState();
}

enum Page { service, local }
Page _selectedPage = Page.service;

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
Color active = Colors.deepPurple[400];
MaterialColor notActive = Colors.grey;
final TextEditingController _details = TextEditingController();
final TextEditingController _email = TextEditingController();
final TextEditingController _address = TextEditingController();
// final TextEditingController _wirehouse = TextEditingController();
final TextEditingController _refercode = TextEditingController();
final TextEditingController _serviceType = TextEditingController();
final TextEditingController _bussiness = TextEditingController();
final TextEditingController _phoneNumber = TextEditingController();
final TextEditingController _pan = TextEditingController();
final TextEditingController _name = TextEditingController();
final TextEditingController _gstinORtin = TextEditingController();
final TextEditingController _state = TextEditingController();
final TextEditingController _pincode = TextEditingController();
final TextEditingController _city = TextEditingController();
final TextEditingController _ifscCode = TextEditingController();
final TextEditingController _accountNumber = TextEditingController();
final TextEditingController _branch = TextEditingController();
final TextEditingController _acState = TextEditingController();
final TextEditingController _bankName = TextEditingController();
final TextEditingController _acHolderName = TextEditingController();
final TextEditingController _acCity = TextEditingController();
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
Geoflutterfire geo = Geoflutterfire();
Location location = new Location();
bool submitBtn = false;
bool monVal = false;
bool verificationDone = false;
bool serviceBool = false;
String get email => _email.text;
String get details => _details.text;
String get phoneNumber => _phoneNumber.text;
String get address => _address.text;
String get bussinedd => _bussiness.text;
String get pan => _pan.text;
String get refercode => _refercode.text;
// String get wireHouse => _wirehouse.text;
String get serviceType => _serviceType.text;
String get name => _name.text;
String get gstinOrtin => _gstinORtin.text;
String get city => _city.text;
String get state => _state.text;
String get pinCode => _pincode.text;
String get acCity => _acCity.text;
String get acHolderName => _acHolderName.text;
String get bankName => _bankName.text;
String get ifscCode => _ifscCode.text;
String get acState => _acState.text;
String get acBranch => _branch.text;
String get acBankNumber => _accountNumber.text;

class _FormDetailsState extends State<FormDetails> {
  String category;
  // void _onShopDropItemSelected(String newValueSelected) {
  //   setState(() {
  //     this.category = newValueSelected;
  //   });
  // }
  GeoFirePoint locationS;
  @override
  void initState() {
    super.initState();
  }

  Widget _loadscreen(BuildContext context) {
    bool panVaild = submitBtn && !widget.panValidator.isValid(pan);
    bool nameVaild = submitBtn && !widget.nameValidator.isValid(name);
    bool phoneValid =
        submitBtn && !widget.phoneNumberValidator.isValid(phoneNumber);
    bool detailsValid = submitBtn && !widget.detailsValidator.isValid(details);
    bool addressVaild = submitBtn && !widget.addressValidator.isValid(address);
    bool cityValid = submitBtn && !widget.cityValidator.isValid(city);
    bool stateVaild = submitBtn && !widget.stateValidator.isValid(state);
    bool pincodeVaild = submitBtn && !widget.pinCodeValidator.isValid(pinCode);
    bool gstinOrtinValid =
        submitBtn && !widget.gstinOrtinValidator.isValid(gstinOrtin);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Local Details Submission",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Remember Star (*) Field Must important",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                )),
          ),
          Divider(),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'Enter Your Full Name';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                    BlacklistingTextInputFormatter("  "),
                  ],
                  errorText: nameVaild ? widget.invalidNameError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _name,
                  obscureText: false,
                  hintText: "Your Full Name Same As (Pan Card Name) *",
                  onChanged: (name) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value.length < 10) {
                      return 'Enter Right 10 Digit Pan Card Number';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    BlacklistingTextInputFormatter(" ")
                  ],
                  errorText: panVaild ? widget.invalidPanlError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _pan,
                  obscureText: false,
                  hintText: "Enter Your Pan Number Correctly *",
                  onChanged: (pan) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 10) {
                      return 'Enter 10 Digit Phone Number';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    BlacklistingTextInputFormatter(" "),
                  ],
                  errorText: phoneValid ? widget.invalidPhoneNumberError : null,
                  textInputType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  textEditingController: _phoneNumber,
                  obscureText: false,
                  hintText: "Your Phone Number *",
                  onChanged: (number) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                    BlacklistingTextInputFormatter(" ")
                  ],
                  errorText:
                      gstinOrtinValid ? widget.invalidGstinOrTinError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _gstinORtin,
                  obscureText: false,
                  hintText: "Enter Your GST or TIN Number (Optional)",
                  onChanged: (gstinORtin) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 3) {
                      return 'Enter Your State Name Properly';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                    BlacklistingTextInputFormatter("  "),
                  ],
                  errorText: stateVaild ? widget.stateError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _state,
                  obscureText: false,
                  hintText: "Your State Name *",
                  onChanged: (state) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 10) {
                      return 'Enter Full Address give in your pan card';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                    BlacklistingTextInputFormatter("  "),
                  ],
                  errorText: addressVaild ? widget.invalidAddressError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _address,
                  obscureText: false,
                  hintText: "Your Bussiness Correct Address *",
                  onChanged: (address) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'Enter Correct Pin Code';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    BlacklistingTextInputFormatter(" "),
                  ],
                  errorText: pincodeVaild ? widget.pinCodeError : null,
                  textInputType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  textEditingController: _pincode,
                  obscureText: false,
                  hintText: "Your Area PinCode *",
                  onChanged: (pincode) {
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.length < 2) {
                      return 'Enter Proper City Name';
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                    BlacklistingTextInputFormatter("  "),
                  ],
                  errorText: cityValid ? widget.cityError : null,
                  textInputType: TextInputType.multiline,
                  textEditingController: _city,
                  obscureText: false,
                  hintText: "Your City Name *",
                  onChanged: (cityname) {
                    setState(() {});
                  },
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream:,
              //   builder: (context, snapshot) {
              //     return DropdownButton(
              //       items: categoriesDropDown,
              //       onChanged: changeSelectedCategory,
              //       value: _currentCategory,
              //     );
              //   }
              // ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFieldWidget(
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value.length < 3) {
                            return 'Enter Proper Shop Name';
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                          BlacklistingTextInputFormatter("  "),
                        ],
                        errorText:
                            detailsValid ? widget.invalidDetailsError : null,
                        textInputType: TextInputType.multiline,
                        textEditingController: _details,
                        obscureText: false,
                        hintText: "Your Shop Name *",
                        onChanged: (service) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Local Market")
                            .snapshots(),
                        builder: (context, snapshot) {
                          // List<DropdownMenuItem> servicess = [];
                          // final List<DocumentSnapshot> documentss =
                          //     snapshot?.data?.documents;
                          if (!snapshot.hasData ||
                              snapshot.data.documents.length == 0) {
                            return Center(child: CircularProgressIndicator());
                          }
                          // return InputDecorator(
                          //   decoration: InputDecoration(
                          //     //labelText: 'Activity',
                          //     hintText: 'Choose an category',
                          //     hintStyle: TextStyle(
                          //       color: active,
                          //       fontSize: 16.0,
                          //       fontFamily: "OpenSans",
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                          //   isEmpty: category == null,
                          //   child:

                          return DropdownButton(
                            value: category,
                            isExpanded: true,
                            hint: Text("Service"),
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Your Service Is $newValue',
                                    style: TextStyle(color: active),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                category = newValue;
                                serviceBool = true;
                                // _onShopDropItemSelected(newValue);
                              });
                            },
                            items: snapshot.data != null
                                ? snapshot.data.documents.map((f) {
                                    return DropdownMenuItem(
                                      value: f.documentID.toString(),
                                      child: Text(f.documentID.toString()),
                                    );
                                  }).toList()

                                //  snapshot.data != null
                                //     ? snapshot.data.documents
                                //         .map((DocumentSnapshot document) {
                                //         // final List<DocumentSnapshot> documents =
                                //         //     document.data["local"];

                                //           return DropdownMenuItem(
                                //               value: document["locals"].toString(),
                                //               child: new Container(
                                //                 height: 100.0,
                                //                 child: new Text(
                                //                   document.data["locals"][i].toString(),
                                //                 ),
                                //               ));

                                //       }).toList()

                                : DropdownMenuItem(
                                    value: 'null',
                                    child: new Container(
                                      height: 100.0,
                                      child: new Text('null'),
                                    ),
                                  ),
                          );
                          // );
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    BlacklistingTextInputFormatter(" ")
                  ],
                  textInputType: TextInputType.multiline,
                  textEditingController: _refercode,
                  obscureText: false,
                  hintText: "Enter Refferal Code (Optional)",
                  onChanged: (refferal) {
                    setState(() {});
                  },
                ),
              ),

              ListTile(
                  leading: CheckBoxWidget(
                    valueBool: monVal,
                    onChanged: (value) {
                      setState(() {
                        monVal = value;
                      });
                    },
                  ),
                  title: Text(
                    "Agree Our Term Conditons",
                    style: TextStyle(color: active),
                  ))
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _details.clear();
    _email.clear();
    _address.clear();
    _refercode.clear();
    _serviceType.clear();
    _bussiness.clear();
    _phoneNumber.clear();
    _pan.clear();
    _name.clear();
    _gstinORtin.clear();
    _state.clear();
    _pincode.clear();
    _city.clear();
    _ifscCode.clear();
    _accountNumber.clear();
    _branch.clear();
    _acState.clear();
    _bankName.clear();
    _acHolderName.clear();
    _acCity.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool submitBtn = widget.nameValidator.isValid(name) &&
        widget.phoneNumberValidator.isValid(phoneNumber) &&
        widget.addressValidator.isValid(address) &&
        widget.detailsValidator.isValid(details) &&
        widget.stateValidator.isValid(state) &&
        widget.pinCodeValidator.isValid(pinCode) &&
        widget.cityValidator.isValid(city) &&
        widget.panValidator.isValid(pan) &&
        serviceBool &&
        monVal;

    // final primaryText = _selectedPage == Page.service ? "Bussiness" : "Local";

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        backgroundColor: active,
        title: Text("Form Submitions"),
        centerTitle: true,
        elevation: 0,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text("Double Tap To Exit"),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    _loadscreen(context),
                    // FlatButton(
                    //   colorBrightness: Brightness.light,
                    //   onPressed: () {
                    //     setState(() => _selectedPage =
                    //         _selectedPage == Page.service
                    //             ? Page.local
                    //             : Page.service);
                    //     submitBtn = false;
                    //     _email.clear();
                    //     _details.clear();
                    //     _address.clear();
                    //     _bussiness.clear();
                    //     _gstinORtin.clear();
                    //     _name.clear();
                    //     _pan.clear();
                    //     _phoneNumber.clear();
                    //     _refercode.clear();
                    //     _acCity.clear();
                    //     _accountNumber.clear();
                    //     _acHolderName.clear();
                    //     _acState.clear();
                    //     _bankName.clear();
                    //     _branch.clear();
                    //     _city.clear();
                    //     _ifscCode.clear();
                    //     _pincode.clear();
                    //     _state.clear();
                    //   },
                    //   child: Text("Switch To $primaryText Plan"),
                    // ),
                    OutlineButton(
                      splashColor: active,
                      onPressed: 
                          isValidPan(pan) && submitBtn ? lolos : null,
                      child: Text("Submit Form Details"),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  lolos() async {
    final pos = await location.getLocation();

    GeoFirePoint point =
        geo.point(latitude: pos?.latitude, longitude: pos?.longitude);
    final auth = Provider.of<AuthService>(context);
    bool result = await auth.refferal(refercode, name);
    final user = Provider.of<User>(context);
    if (_formKey.currentState.validate()) {
      if (result == false) {
        Fluttertoast.showToast(
            msg: "Invalid Refer Code Please Check It Properly");
      } else if (category != null) {
        DatabaseService(uid: user.uid).addDataToDb({
          "name": name,
          "usedReferCode": refercode,
          "PhoneNumber": phoneNumber,
          "Pan Number": pan,
          "Address": address,
          "Shop Name": details,
          "ServiceCategory": category,
          "Verification": false,
          "formstatus": true,
          "State": state,
          "PinCode": pinCode,
          "City": city,
          "GstorTin Number": gstinOrtin,
          "BankDetailsBool": false,
          "location": point?.data
        });
        auth.refferal(refercode, name);
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainFinal()));
      } else {
        Fluttertoast.showToast(msg: "Please Select Your Service");
      }
    } else {
      Fluttertoast.showToast(msg: "Please Fill From Properly");
    }
  }

  bool isValidPan(String val) {
    final RegExp regex =
        new RegExp(r"[A-Z]{3}[ABCFGHLJPTF]{1}[A-Z]{1}[0-9]{4}[A-Z]{1}");
    var result = regex.hasMatch(val);
    if (val.length == 10) {
      if (result == false) {
        Fluttertoast.showToast(
            timeInSecForIos: 1,
            msg: "Please Enter Vaild Pan Card Number!",
            toastLength: Toast.LENGTH_SHORT);
      }
    }
    return result;
  }
}
