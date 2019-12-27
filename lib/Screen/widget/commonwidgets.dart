import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function onChanged;
  final String errorText;
  final List<TextInputFormatter> inputFormatters;
  final Color active = Colors.deepPurple[400];
   TextFieldWidget(
      {Key key,
      this.errorText,
      this.onChanged,
      this.focusNode,
      @required this.hintText,
      @required this.obscureText,
      this.textEditingController,
      this.textInputType,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15.0,
    );
    return TextField(
        maxLengthEnforced: true,
        enableSuggestions: true,
        keyboardType: textInputType,
        controller: textEditingController,
        obscureText: obscureText,
        onChanged: onChanged,
        style: style, 
        inputFormatters: inputFormatters,
        cursorColor: active,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: active),
            borderRadius: BorderRadius.circular(32.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(32.0),
          ),
          focusColor: active,
          hoverColor: active,
          fillColor: active,
          errorText: errorText,
          isDense: true,
          hintText: hintText,
        ));
  }
}

class CheckBoxWidget extends StatelessWidget {
 final bool valueBool;
  final Color activeColor;
  final Color checkColor;
  final Function onChanged;
  final MaterialColor active = Colors.purple;
  CheckBoxWidget(
      {Key key,
      @required this.valueBool,
      this.activeColor,
      this.checkColor,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: active,
      value: valueBool,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
