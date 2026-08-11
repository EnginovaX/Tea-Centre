import 'package:flutter/material.dart';

enum AppButtonType { primary, filled, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonType type;
  final Widget? icon;
  final bool fullWidth;

  const AppButton({
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.fullWidth = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: type == AppButtonType.outlined
                ? theme.colorScheme.secondary
                : Colors.white,
          ),
        ),
      ],
    );

    Widget finalButton;

    switch (type) {
      case AppButtonType.primary:
        finalButton = ElevatedButton(
          onPressed: onPressed,
          style: theme.elevatedButtonTheme.style,
          child: buttonChild,
        );
        break;
      case AppButtonType.filled:
        finalButton = FilledButton(
          onPressed: onPressed,
          style: theme.filledButtonTheme.style,
          child: buttonChild,
        );
        break;
      case AppButtonType.outlined:
        finalButton = OutlinedButton(
          onPressed: onPressed,
          style: theme.outlinedButtonTheme.style,
          child: buttonChild,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: finalButton,
      );
    }
    return finalButton;
  }
}
