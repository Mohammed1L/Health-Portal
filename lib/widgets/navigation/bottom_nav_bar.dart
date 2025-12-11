import 'package:flutter/material.dart';

enum NavItem {
  home,
  appointments,
  results,
  profile,
  more,
}

class BottomNavBar extends StatelessWidget {
  final NavItem currentIndex;
  final Function(NavItem) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D4A2E) : Colors.white; // Dark green for dark mode

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: 'الرئيسية',
                  index: NavItem.home,
                  isActive: currentIndex == NavItem.home,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.calendar_today,
                  label: 'المواعيد',
                  index: NavItem.appointments,
                  isActive: currentIndex == NavItem.appointments,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.description,
                  label: 'النتائج',
                  index: NavItem.results,
                  isActive: currentIndex == NavItem.results,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'ملفي',
                  index: NavItem.profile,
                  isActive: currentIndex == NavItem.profile,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.more_horiz,
                  label: 'المزيد',
                  index: NavItem.more,
                  isActive: currentIndex == NavItem.more,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required NavItem index,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? const Color(0xFF00A86B)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600]),
                  size: 24,
                ),

              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF00A86B)
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600]),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

