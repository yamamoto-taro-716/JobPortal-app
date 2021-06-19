import 'package:app/public/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
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
  final Color borderColor;
  final Color backColor;
  final bool readOnly;
  final double height;
  final Alignment alignment;
  final double paddingTop;
  CustomInputField(
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
      this.borderColor = MainBlue,
      this.backColor = WeakGrey,
      this.readOnly = false,
      this.alignment = Alignment.center,
      this.height = 40.0,
      this.paddingTop = 0,
      this.obscureText = false})
      : super(key: key);

  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  var outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(24.0)),
      borderSide: BorderSide(
        color: MainTrans,
      ));
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        alignment: widget.alignment,
        decoration: BoxDecoration(
          color: widget.backColor,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        padding: EdgeInsets.only(
            left: 12.0, right: 0, top: widget.paddingTop, bottom: 0),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
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
          style: TextStyle(color: MainBlack),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: widget.prefixIcon,
              border: outlineBorder,
              focusedBorder: outlineBorder,
              enabledBorder: outlineBorder,
              disabledBorder: new UnderlineInputBorder(
                borderSide: BorderSide(color: MainTrans),
              ),
              suffixIcon: widget.suffixIcon,
              hintStyle: TextStyle(color: MainGrey, fontSize: 14.0),
              hintText: widget.placeHolder,
              labelStyle: TextStyle(color: MainGrey),
              labelText: widget.labelText == ''
                  ? widget.placeHolder
                  : widget.labelText),
        ));
  }
}
