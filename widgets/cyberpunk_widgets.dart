import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cyberpunk_theme.dart';

/// Input field personalizado con estilo cyberpunk
class CyberpunkTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;

  const CyberpunkTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (errorText == null)
                BoxShadow(
                  color: CyberpunkColors.glowPurple.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: maxLines,
            maxLength: maxLength,
            enabled: enabled,
            style: const TextStyle(
              color: CyberpunkColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown personalizado con estilo cyberpunk
class CyberpunkDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String Function(T) displayText;
  final String? errorText;
  final bool enabled;

  const CyberpunkDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    required this.displayText,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (errorText == null)
                BoxShadow(
                  color: CyberpunkColors.glowPurple.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayText(item),
                  style: const TextStyle(
                    color: CyberpunkColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              suffixIcon: const Icon(
                Icons.arrow_drop_down,
                color: CyberpunkColors.primaryMagenta,
              ),
            ),
            dropdownColor: CyberpunkColors.darkSurface,
            style: const TextStyle(
              color: CyberpunkColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

/// Botón principal con efecto cyberpunk
class CyberpunkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool withGradient;
  final double? width;
  final double height;

  const CyberpunkButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.withGradient = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: withGradient ? Colors.transparent : 
                         (backgroundColor ?? CyberpunkColors.primaryPurple),
          foregroundColor: textColor ?? CyberpunkColors.textPrimary,
          elevation: 8,
          shadowColor: CyberpunkColors.glowPurple,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CyberpunkColors.textPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                ],
              ),
      ),
    );

    if (withGradient) {
      button = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: CyberpunkColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: CyberpunkColors.glowMagenta.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: textColor ?? CyberpunkColors.textPrimary,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CyberpunkColors.textPrimary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    return button
        .animate()
        .scale(duration: 200.ms, curve: Curves.easeOut)
        .fadeIn(duration: 300.ms);
  }
}

/// Card personalizada con estilo cyberpunk
class CyberpunkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool withGlow;
  final bool withGradientBorder;

  const CyberpunkCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.withGlow = false,
    this.withGradientBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: margin ?? const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (withGradientBorder) {
      card = card.withGradientBorder();
    }

    if (withGlow) {
      card = card.withGlow();
    }

    return card
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOut);
  }
}

/// Avatar con efecto cyberpunk
class CyberpunkAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final bool withGlow;

  const CyberpunkAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 50,
    this.withGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      backgroundColor: CyberpunkColors.primaryPurple,
      child: imageUrl == null
          ? Text(
              initials.toUpperCase(),
              style: TextStyle(
                color: CyberpunkColors.textPrimary,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
            )
          : null,
    );

    if (withGlow) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: CyberpunkColors.glowMagenta.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: avatar,
      );
    }

    return avatar
        .animate()
        .scale(duration: 300.ms, curve: Curves.elasticOut);
  }
}

/// Indicador de progreso personalizado
class CyberpunkProgressIndicator extends StatelessWidget {
  final double? value;
  final String? label;
  final bool showPercentage;

  const CyberpunkProgressIndicator({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  color: CyberpunkColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Orbitron',
                ),
              ),
              if (showPercentage && value != null)
                Text(
                  '${(value! * 100).round()}%',
                  style: const TextStyle(
                    color: CyberpunkColors.primaryMagenta,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CyberpunkColors.border,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                CyberpunkColors.primaryMagenta,
              ),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.2, duration: 400.ms, curve: Curves.easeOut);
  }
}

/// Badge con estilo cyberpunk
class CyberpunkBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool withGlow;

  const CyberpunkBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.withGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? CyberpunkColors.primaryMagenta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CyberpunkColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: textColor ?? CyberpunkColors.textPrimary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor ?? CyberpunkColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
        ],
      ),
    );

    if (withGlow) {
      badge = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? CyberpunkColors.primaryMagenta)
                  .withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: badge,
      );
    }

    return badge
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(duration: 200.ms, curve: Curves.easeOut);
  }
}

/// Separador con efecto cyberpunk
class CyberpunkDivider extends StatelessWidget {
  final String? text;
  final double height;
  final bool withGlow;

  const CyberpunkDivider({
    super.key,
    this.text,
    this.height = 1,
    this.withGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.transparent, CyberpunkColors.border],
                ),
                boxShadow: withGlow
                    ? [
                        BoxShadow(
                          color: CyberpunkColors.glowPurple.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text!,
              style: const TextStyle(
                color: CyberpunkColors.textMuted,
                fontSize: 14,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CyberpunkColors.border, Colors.transparent],
                ),
                boxShadow: withGlow
                    ? [
                        BoxShadow(
                          color: CyberpunkColors.glowPurple.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: CyberpunkColors.border,
        boxShadow: withGlow
            ? [
                BoxShadow(
                  color: CyberpunkColors.glowPurple.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Loading overlay cyberpunk
class CyberpunkLoadingOverlay extends StatelessWidget {
  final String message;
  final bool isVisible;

  const CyberpunkLoadingOverlay({
    super.key,
    this.message = 'Cargando...',
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: CyberpunkColors.darkBackground.withOpacity(0.8),
      child: Center(
        child: CyberpunkCard(
          padding: const EdgeInsets.all(32),
          withGlow: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CyberpunkColors.primaryMagenta,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  color: CyberpunkColors.textPrimary,
                  fontSize: 16,
                  fontFamily: 'Orbitron',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms);
  }
}
