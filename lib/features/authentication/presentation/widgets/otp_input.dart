import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_tokens.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.onChanged,
    required this.onCompleted,
    super.key,
    this.enabled = true,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final bool enabled;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> {
  static const length = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  String get value => _controllers.map((controller) => controller.text).join();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNodes.first.requestFocus(),
    );
  }

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged('');
  }

  void _handleChange(int index, String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      _controllers[index].text = digits[0];
      for (
        var offset = 0;
        offset < digits.length && index + offset < length;
        offset++
      ) {
        _controllers[index + offset].text = digits[offset];
      }
      final next = (index + digits.length).clamp(0, length - 1);
      _focusNodes[next].requestFocus();
    } else if (digits.isNotEmpty && index < length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (digits.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    final code = value;
    widget.onChanged(code);
    if (code.length == length) widget.onCompleted(code);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AutofillGroup(
    child: Row(
      textDirection: TextDirection.ltr,
      children: List.generate(
        length,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == length - 1 ? 0 : AppSpacing.xs,
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              enabled: widget.enabled,
              autofocus: index == 0,
              autofillHints: index == 0
                  ? const [AutofillHints.oneTimeCode]
                  : null,
              keyboardType: TextInputType.number,
              textInputAction: index == length - 1
                  ? TextInputAction.done
                  : TextInputAction.next,
              textAlign: TextAlign.center,
              maxLength: index == 0 ? length : 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              decoration: const InputDecoration(counterText: ''),
              onChanged: (value) => _handleChange(index, value),
            ),
          ),
        ),
      ),
    ),
  );
}
