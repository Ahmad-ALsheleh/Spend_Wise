import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

/// شريط التنقل السفلي: Home · History · Analytics.
/// العنصر المحدد: أيقونة ممتلئة فوق خلفية فاتحة ونص عريض.
/// زر + منفصل (AddFab) حتى يبقى قابلاً للضغط بالكامل ويتبع اتجاه اللغة.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // 0 = Home, 1 = History, 2 = Analytics
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final strings = AppStrings.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.navBar,
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: strings.navHome,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.description_outlined,
                selectedIcon: Icons.description,
                label: strings.navHistory,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.pie_chart_outline_rounded,
                selectedIcon: Icons.pie_chart_rounded,
                label: strings.navAnalytics,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final foreground = selected ? colors.textPrimary : colors.textSecondary;
    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected ? colors.highlight : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  selected ? selectedIcon : icon,
                  color: foreground,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
