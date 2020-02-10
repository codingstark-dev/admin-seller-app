import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sellerapp/Screen/Home/Admin.dart';
import 'package:sellerapp/Screen/FormDetailsUser/validator.dart';
import 'package:sellerapp/Screen/widget/commonwidgets.dart';
import 'package:sellerapp/model/user.dart';
import 'package:sellerapp/service/streamfiles.dart';

class BankDetailsSubmit extends StatefulWidget with EmailAndPasswordValidators {
  BankDetailsSubmit({Key key}) : super(key: key);

  @override
  _BankDetailsSubmitState createState() => _BankDetailsSubmitState();
}

class _BankDetailsSubmitState extends State<BankDetailsSubmit> {
  final TextEditingController _ifscCode = TextEditingController();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _acHolderName = TextEditingController();
  final TextEditingController _branch = TextEditingController();

  String get acBranch => _branch.text;
  String get acBankNumber => _accountNumber.text;
  String get acHolderName => _acHolderName.text;
  String get bankName => _bankName.text;
  String get ifscCode => _ifscCode.text;
  Color active = Colors.deepPurple[400];
  bool submitBtn = false;
  bool monVal = false;
  bool verificationDone = false;
  bool serviceBool = false;

  @override
  Widget build(BuildContext context) {
    bool submitBtn = widget.branchValidator.isValid(acBranch) &&
        widget.accountNumberValidator.isValid(acBankNumber) &&
        widget.acHolderNameinValidator.isValid(acHolderName) &&
        widget.ifscCodeValidator.isValid(ifscCode) &&
        widget.bankNameValidator.isValid(bankName) &&
        monVal;

    Widget _loadscreen(BuildContext context) {
      bool acHolderNameVaild =
          submitBtn && !widget.acHolderNameinValidator.isValid(acHolderName);
      bool acBankName =
          submitBtn && !widget.bankNameValidator.isValid(bankName);
      bool ifscVaild = submitBtn && !widget.ifscCodeValidator.isValid(ifscCode);
      bool accountNumberVaild =
          submitBtn && !widget.accountNumberValidator.isValid(acBankNumber);
      bool acBranchVaild =
          submitBtn && !widget.addressValidator.isValid(acBranch);
      return ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Remember Star (*) Field Must important\nPlease Fill The Form Properly\nIf Any Trouble Or Problem Contact Us",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Bank Details",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldWidget(
                      errorText:
                          acHolderNameVaild ? widget.invalidDetailsError : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(55),
                        BlacklistingTextInputFormatter("  ")
                      ],
                      textInputType: TextInputType.multiline,
                      textEditingController: _acHolderName,
                      obscureText: false,
                      hintText: "Account Holder Name *",
                      onChanged: (acname) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldWidget(
                      errorText: accountNumberVaild
                          ? widget.invalidDetailsError
                          : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(21),
                        BlacklistingTextInputFormatter(" ")
                      ],
                      textInputType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      textEditingController: _accountNumber,
                      obscureText: false,
                      hintText: "Account Number *",
                      onChanged: (acnumber) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldWidget(
                      errorText: ifscVaild ? widget.invalidDetailsError : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        BlacklistingTextInputFormatter(" ")
                      ],
                      textInputType: TextInputType.multiline,
                      textEditingController: _ifscCode,
                      obscureText: false,
                      hintText: "IFSC Code *",
                      onChanged: (ifsc) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldWidget(
                      errorText: acBankName ? widget.invalidDetailsError : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                        BlacklistingTextInputFormatter("  ")
                      ],
                      textInputType: TextInputType.multiline,
                      textEditingController: _bankName,
                      obscureText: false,
                      hintText: "Bank Name *",
                      onChanged: (acbankname) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldWidget(
                      errorText:
                          acBranchVaild ? widget.invalidDetailsError : null,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                        BlacklistingTextInputFormatter("  ")
                      ],
                      textInputType: TextInputType.multiline,
                      textEditingController: _branch,
                      obscureText: false,
                      hintText: "Branch *",
                      onChanged: (branch) {
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
                      )),
                  OutlineButton(
                    splashColor: active,
                    onPressed: submitBtn ? lolos : null,
                    child: Text("Submit Form Details"),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              )
            ],
          ),
        ],
      );
    }

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: active,
          title: Text("Bank Detail Submission"),
          centerTitle: true,
          elevation: 0,
        ),
        body: _loadscreen(context));
  }

  @override
  void dispose() {
    super.dispose();
    _accountNumber.clear();
    _acHolderName.clear();
    _bankName.clear();
    _branch.clear();
    _ifscCode.clear();
  }

  lolos() async {
    final user = Provider.of<User>(context);
    setState(() {
      submitBtn = true;
      DatabaseService(uid: user.uid).addDataToDb({
        "BankDetailsBool": true,
        "Bank Details": {
          "Account Holder Name": acHolderName,
          "Account Number": acBankNumber,
          "Ifsc Code": ifscCode,
          "Bank Name": bankName,
          "Branch": acBranch,
        }
      }).whenComplete(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Admin()));
      });
    });
  }
}
