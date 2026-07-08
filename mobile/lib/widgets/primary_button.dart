import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  double _scale = 1.0;
  final double maxWidth = 280;

  void _setPressed(bool pressed) {
    if (widget.onPressed == null) return;
    setState(() => _scale = pressed ? 0.97 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTapDown: (_) => _setPressed(true),
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 90),
                curve: Curves.easeOut,
                child: ElevatedButton.icon(
                  onPressed: widget.onPressed,
                  icon: widget.icon == null
                      ? const SizedBox.shrink()
                      : Icon(widget.icon, color: AppTheme.bg, size: 18),
                  label: Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppTheme.bg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: AppTheme.primary.withValues(
                      alpha: 0.4,
                    ),
                    overlayColor: Colors.black.withValues(alpha: 0.12),
                    elevation: 3,
                    shadowColor: AppTheme.primary.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
