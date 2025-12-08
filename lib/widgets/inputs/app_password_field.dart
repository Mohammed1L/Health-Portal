import 'package:flutter/material.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? initialValue;
  final Color? fillColor;

  const AppPasswordField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.initialValue,
    this.fillColor,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppTextField(
      labelText: widget.labelText ?? 'Password',
      hintText: widget.hintText ?? 'Enter your password',
      helperText: widget.helperText,
      errorText: widget.errorText,
      controller: widget.controller,
      obscureText: _obscureText,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      autofocus: widget.autofocus,
      initialValue: widget.initialValue,
      fillColor: widget.fillColor,
      prefixIcon: Icon(
        Icons.lock_outline,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        onPressed: _toggleObscureText,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      ),
    );
  }
}

