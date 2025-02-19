import 'package:flutter/material.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Icon? leadingIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final bool readOnly;
  final bool autofocus; // <-- Added autofocus
  final FocusNode? focusNode; // <-- Added FocusNode
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final InputDecoration? customDecoration;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? enabledBorderColor;

  const CommonTextFieldWidget({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.leadingIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.autofocus = false, // <-- Default is false
    this.focusNode,
    this.onChanged,
    this.validator,
    this.onTap,
    this.customDecoration,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.enabledBorderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) leadingIcon!,
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            maxLines: maxLines,
            readOnly: readOnly,
            autofocus: autofocus, // <-- Set autofocus
            focusNode: focusNode,
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
            decoration: customDecoration ??
                InputDecoration(
                  hintText: hintText,
                  labelText: labelText,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: focusedBorderColor!, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: errorBorderColor!, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: enabledBorderColor!, width: 1.0),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
