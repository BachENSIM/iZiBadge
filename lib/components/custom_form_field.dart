import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';

class CustomFormField extends StatelessWidget {
  final bool isObscure;
  final bool isCapitalized;
  final bool isLabelEnabled;
  final int maxLines;
  final TextEditingController _txtCtl;
  final FocusNode _txtFocusNode;
  final TextInputType _inputType;
  final TextInputAction _inputAction;
  final String _hint, _label;
  final Function(String) _validator;

  const CustomFormField({
    Key? key,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    required TextInputAction inputAction,
    required String label,
    required String hint,
    required Function(String value) validator,
    this.isObscure = false,
    this.isCapitalized = false,
    this.maxLines = 1,
    this.isLabelEnabled = true,
  })  : _txtCtl = controller,
        _txtFocusNode = focusNode,
        _inputType = inputType,
        _inputAction = inputAction,
        _label = label,
        _hint = hint,
        _validator = validator,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: _txtCtl,
      focusNode: _txtFocusNode,
      keyboardType: _inputType,
      obscureText: isObscure,
      textCapitalization:
          isCapitalized ? TextCapitalization.words : TextCapitalization.none,
      textInputAction: _inputAction,
      // cursorColor: CustomColors.accentLight,
      validator: (value) => _validator(value!),
      decoration: InputDecoration(
        labelText: isLabelEnabled ? _label : null,
        // labelStyle: TextStyle(color: CustomColors.accentLight),
        hintText: _hint,
        hintStyle: TextStyle(
            // color: CustomColors.primaryText.withOpacity(0.5),
            ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            //color: CustomColors.accentDark,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              //color: CustomColors.textPrimary.withOpacity(0.5),
              ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
