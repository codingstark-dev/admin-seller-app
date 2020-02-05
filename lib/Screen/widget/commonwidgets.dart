import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function onChanged;
  final Function validator;
  final String errorText;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  TextFieldWidget({
    Key key,
    this.errorText,
    this.onChanged,
    this.focusNode,
    @required this.hintText,
    @required this.obscureText,
    this.textEditingController,
    this.textInputType,
    this.inputFormatters,
    this.validator,
    this.textCapitalization,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final Color active = Colors.deepPurple[400];

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15.0,
    );
    return TextFormField(
        textCapitalization: widget.textCapitalization,
        validator: widget.validator,
        maxLengthEnforced: true,
        enableSuggestions: true,
        keyboardType: widget.textInputType,
        controller: widget.textEditingController,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        style: style,
        inputFormatters: widget.inputFormatters,
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
          errorText: widget.errorText,
          isDense: true,
          hintText: widget.hintText,
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
