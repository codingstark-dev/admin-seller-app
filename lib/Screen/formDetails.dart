import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/Wrapper.dart';
import 'package:sellerapp/Screen/validator.dart';
import 'package:sellerapp/Screen/widget/commonwidgets.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/auth.dart';
import 'package:sellerapp/service/streamfiles.dart';

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
final TextEditingController _wirehouse = TextEditingController();
final TextEditingController _refercode = TextEditingController();
final TextEditingController _serviceType = TextEditingController();
final TextEditingController _bussiness = TextEditingController();
final TextEditingController _phoneNumber = TextEditingController();
final TextEditingController _pan = TextEditingController();
final TextEditingController _name = TextEditingController();
final TextEditingController _gstinORtin = TextEditingController();

bool submitBtn = false;
bool monVal = false;
bool tuVal = false;
bool wedVal = false;
bool verificationDone = false;

String get email => _email.text;
String get details => _details.text;
String get phoneNumber => _phoneNumber.text;
String get address => _address.text;
String get bussinedd => _bussiness.text;
String get pan => _pan.text;
String get refercode => _refercode.text;
String get wireHouse => _wirehouse.text;
String get serviceType => _serviceType.text;
String get name => _name.text;
String get gstinOrtin => _gstinORtin.text;

class _FormDetailsState extends State<FormDetails> {
  Widget _loadscreen(BuildContext context) {
    switch (_selectedPage) {
      case Page.service:
        bool emailValid = submitBtn && !widget.emailValidator.isValid(email);
        bool nameVaild = submitBtn && !widget.nameValidator.isValid(name);
        bool phoneValid =
            submitBtn && !widget.phoneNumberValidator.isValid(phoneNumber);
        bool detailsValid =
            submitBtn && !widget.detailsValidator.isValid(details);
        bool addressVaild =
            submitBtn && !widget.addressValidator.isValid(address);
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Service Details Submission",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(40),
                      BlacklistingTextInputFormatter(" "),
                    ],
                    errorText: emailValid ? widget.invalidEmailError : null,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _email,
                    obscureText: false,
                    hintText: "Your Email ID *",
                    onChanged: (email) {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      BlacklistingTextInputFormatter(" "),
                    ],
                    errorText:
                        phoneValid ? widget.invalidPhoneNumberError : null,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(60),
                      BlacklistingTextInputFormatter("  "),
                    ],
                    errorText: addressVaild ? widget.invalidAddressError : null,
                    textInputType: TextInputType.multiline,
                    textEditingController: _address,
                    obscureText: false,
                    hintText: "Your Correct Address *",
                    onChanged: (address) {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(40),
                      BlacklistingTextInputFormatter("  "),
                    ],
                    errorText: detailsValid ? widget.invalidDetailsError : null,
                    textInputType: TextInputType.multiline,
                    textEditingController: _details,
                    obscureText: false,
                    hintText: "Your Service Details *",
                    onChanged: (service) {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWidget(
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
        );
        break;
      case Page.local:
        bool emailValid = submitBtn && !widget.emailValidator.isValid(email);
        bool panVaild = submitBtn && !widget.panValidator.isValid(pan);
        bool gstinOrtinValid =
            submitBtn && !widget.gstinOrtinValidator.isValid(gstinOrtin);
        bool nameVaild = submitBtn && !widget.nameValidator.isValid(name);
        bool phoneValid =
            submitBtn && !widget.phoneNumberValidator.isValid(phoneNumber);
        bool detailsValid =
            submitBtn && !widget.detailsValidator.isValid(details);
        bool addressVaild =
            submitBtn && !widget.addressValidator.isValid(address);
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Service Details Submission",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                  BlacklistingTextInputFormatter("  "),
                ],
                errorText: nameVaild ? widget.invalidNameError : null,
                textInputType: TextInputType.multiline,
                textEditingController: _name,
                obscureText: false,
                hintText: "Your Full Name Same As (Aadhaar Name) *",
                onChanged: (name) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                  BlacklistingTextInputFormatter(" "),
                ],
                errorText: emailValid ? widget.invalidEmailError : null,
                textInputType: TextInputType.emailAddress,
                textEditingController: _email,
                obscureText: false,
                hintText: "Your Email ID *",
                onChanged: (email) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
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
                inputFormatters: [
                  LengthLimitingTextInputFormatter(60),
                  BlacklistingTextInputFormatter("  "),
                ],
                errorText: addressVaild ? widget.invalidAddressError : null,
                textInputType: TextInputType.multiline,
                textEditingController: _address,
                obscureText: false,
                hintText: "Your Correct Address *",
                onChanged: (address) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                  BlacklistingTextInputFormatter("  "),
                ],
                errorText: detailsValid ? widget.invalidDetailsError : null,
                textInputType: TextInputType.multiline,
                textEditingController: _details,
                obscureText: false,
                hintText: "Your Service Details *",
                onChanged: (details) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                  BlacklistingTextInputFormatter(" ")
                ],
                errorText:
                    gstinOrtinValid ? widget.invalidGstinOrTinError : null,
                textInputType: TextInputType.multiline,
                textEditingController: _gstinORtin,
                obscureText: false,
                hintText: "Enter Your GSTIN or TIN *",
                onChanged: (gstinORtin) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldWidget(
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
        );
        break;
      default:
        return Container();
    }
  }

  lolos() async {
    final auth = Provider.of<AuthService>(context);
    bool result = await auth.refferal(refercode, name);
    final user = Provider.of<User>(context);
    setState(() {
      submitBtn = true;
      if (result == false) {
        Fluttertoast.showToast(
            msg: "Invalid Refer Code Please Check It Properly");
      } else {
        DatabaseService(uid: user.uid).addDataToDb(_selectedPage == Page.service
            ? {
                "name": name,
                "SecEmail": email,
                "usedReferCode": refercode,
                "PhoneNumber": phoneNumber,
                "Address": address,
                "ServiceDetails": details,
                "Verification": false,
                "formstatus": true
              }
            : {
                "name": name,
                "SecEmail": email,
                "usedReferCode": refercode,
                "PhoneNumber": phoneNumber,
                "Address": address,
                "ServiceDetails": details,
                "GstinOrTin": gstinOrtin,
                "Pan Card": pan,
                "Verification": false,
                "formstatus": true
              });
        auth.refferal(refercode, name);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.clear();
    _details.clear();
    _address.clear();
    _bussiness.clear();
    _gstinORtin.clear();
    _name.clear();
    _pan.clear();
    _phoneNumber.clear();
    _refercode.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool submitBtn = _selectedPage == Page.service
        ? widget.emailValidator.isValid(email) &&
            widget.nameValidator.isValid(name) &&
            widget.phoneNumberValidator.isValid(phoneNumber) &&
            widget.addressValidator.isValid(address) &&
            widget.detailsValidator.isValid(details) &&
            monVal
        : widget.emailValidator.isValid(email) &&
            widget.nameValidator.isValid(name) &&
            widget.phoneNumberValidator.isValid(phoneNumber) &&
            widget.addressValidator.isValid(address) &&
            widget.detailsValidator.isValid(details) &&
            widget.gstinOrtinValidator.isValid(gstinOrtin) &&
            widget.panValidator.isValid(pan) &&
            monVal;
    final primaryText = _selectedPage == Page.service ? "Bussiness" : "Local";

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
                    FlatButton(
                      colorBrightness: Brightness.light,
                      onPressed: () {
                        setState(() => _selectedPage =
                            _selectedPage == Page.service
                                ? Page.local
                                : Page.service);
                        submitBtn = false;
                        _email.clear();
                        _details.clear();
                        _address.clear();
                        _bussiness.clear();
                        _gstinORtin.clear();
                        _name.clear();
                        _pan.clear();
                        _phoneNumber.clear();
                        _refercode.clear();
                      },
                      child: Text("Switch To $primaryText Plan"),
                    ),
                    FlatButton(
                      onPressed:
                          isValidEmail(email) && submitBtn ? lolos : null,
                      child: Text("Submit Form Details"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String val) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(val);
  }
}
