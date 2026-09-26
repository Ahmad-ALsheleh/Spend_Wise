import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// شريط تنقل سفلي مستقل تمامًا عن أي شاشة.
/// يستقبل الفهرس الحالي ودالة تغيير + دالة الضغط على زر الإضافة العائم.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // 0 = Home, 1 = History, 2 = Analytics
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.description_outlined,
                  label: 'History',
                  selected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: Icons.pie_chart_outline_rounded,
                  label: 'Analytics',
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
          Positioned(
            top: -26,
            right: 16,
            child: _AddFab(onPressed: onAddPressed),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentMint.withOpacity(0.35) : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.accentMint,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentMint.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.black87, size: 28),
        ),
      ),
    );
  }
}