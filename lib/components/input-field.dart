import 'package:app/public/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final Function validator;
  final Function onChanged;
  final String placeHolder;
  final String labelText;
  final TextInputType textInputType;
  final int lines;
  final bool autoFocus;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final Widget prefixIcon;
  final bool enabled;
  final Widget suffixIcon;
  final bool obscureText;
  InputField(
      {Key key,
      @required this.placeHolder,
      @required this.controller,
      this.labelText,
      this.validator,
      this.textInputType = TextInputType.text,
      this.lines = 1,
      this.autoFocus = false,
      this.focusNode,
      this.inputFormatters,
      this.prefixIcon,
      this.enabled = true,
      this.onChanged,
      this.suffixIcon,
      this.obscureText = false})
      : super(key: key);

  _InputFielddState createState() => _InputFielddState();
}

class _InputFielddState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        controller: widget.controller,
        maxLines: widget.lines,
        autocorrect: false,
        autofocus: widget.autoFocus,
        keyboardType: widget.textInputType,
        focusNode: widget.focusNode,
        cursorColor: MainGrey,
        obscureText: widget.obscureText,
        style: TextStyle(color: MainGrey),
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            border: new UnderlineInputBorder(
              borderSide: BorderSide(color: MainGreen),
            ),
            focusedBorder: new UnderlineInputBorder(
              borderSide: BorderSide(color: MainGreen),
            ),
            enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(color: MainGreen),
            ),
            disabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(color: MainGreen),
            ),
            suffixIcon: widget.suffixIcon,
            hintStyle: TextStyle(color: MainGrey, fontSize: 12.0),
            hintText: widget.placeHolder,
            labelStyle: TextStyle(color: MainGrey),
            labelText:
                widget.labelText == '' ? widget.placeHolder : widget.labelText),
      ),
    );
  }
}
