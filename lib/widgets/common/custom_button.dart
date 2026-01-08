import 'package:flutter/material.dart';
import 'package:get_right/theme/color_constants.dart';
import 'package:get_right/theme/text_styles.dart';

/// Modern elevated button with enhanced visual hierarchy and micro-interactions
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final Widget? icon;
  final bool isPrimary;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.icon,
    this.isPrimary = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final actualBackgroundColor = widget.backgroundColor ?? (widget.isPrimary ? AppColors.accent : AppColors.accent);
    final isGrayButton = actualBackgroundColor == AppColors.secondary;
    final isGreenButton = actualBackgroundColor == AppColors.accent;
    final actualTextColor =
        widget.textColor ??
        (isGrayButton
            ? AppColors.onSecondary
            : isGreenButton
            ? AppColors.onAccent
            : AppColors.onBackground);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.onPressed != null && !widget.isLoading ? _onTapDown : null,
        onTapUp: widget.onPressed != null && !widget.isLoading ? _onTapUp : null,
        onTapCancel: widget.onPressed != null && !widget.isLoading ? _onTapCancel : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.isFullWidth ? double.infinity : null,
          height: widget.height ?? 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: widget.onPressed == null || widget.isLoading
                ? isGreenButton
                      ? LinearGradient(colors: [AppColors.accent, AppColors.accent], begin: Alignment.topLeft, end: Alignment.bottomRight)
                      : null
                : isGreenButton
                ? LinearGradient(colors: [AppColors.accent, AppColors.accent.withOpacity(0.85)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            color: widget.onPressed == null || widget.isLoading
                ? actualBackgroundColor
                : isGreenButton
                ? null
                : actualBackgroundColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              splashColor: actualTextColor.withOpacity(0.1),
              highlightColor: actualTextColor.withOpacity(0.05),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: actualTextColor, strokeWidth: 2.5))
                    : widget.icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconTheme(
                            data: IconThemeData(color: actualTextColor, size: 22),
                            child: widget.icon!,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.text,
                            style: AppTextStyles.buttonLarge.copyWith(color: actualTextColor, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                          ),
                        ],
                      )
                    : Text(
                        widget.text,
                        style: AppTextStyles.buttonLarge.copyWith(color: actualTextColor, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern outlined button with enhanced visuals
class CustomOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final Widget? icon;

  const CustomOutlineButton({super.key, required this.text, this.onPressed, this.isFullWidth = true, this.borderColor, this.textColor, this.height, this.icon});

  @override
  State<CustomOutlineButton> createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final actualBorderColor = widget.borderColor ?? AppColors.primaryGray.withOpacity(0.4);
    final actualTextColor = widget.textColor ?? AppColors.onBackground;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.isFullWidth ? double.infinity : null,
        height: widget.height ?? 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _isHovered ? AppColors.accent : actualBorderColor, width: 2),
          color: _isHovered ? AppColors.accent.withOpacity(0.05) : Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            splashColor: AppColors.accent.withOpacity(0.1),
            highlightColor: AppColors.accent.withOpacity(0.05),
            child: Center(
              child: widget.icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme(
                          data: IconThemeData(color: _isHovered ? AppColors.accent : actualTextColor, size: 22),
                          child: widget.icon!,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.text,
                          style: AppTextStyles.buttonLarge.copyWith(
                            color: _isHovered ? AppColors.accent : actualTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.text,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: _isHovered ? AppColors.accent : actualTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
