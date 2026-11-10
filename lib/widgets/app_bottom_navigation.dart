import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (label: 'Beranda', icon: Icons.home_rounded),
    (label: 'Jelajahi', icon: Icons.explore_rounded),
    (label: 'Peta', icon: Icons.location_on_outlined),
    (label: 'Tiket', icon: Icons.confirmation_number_outlined),
    (label: 'Profil', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x180C192C),
              blurRadius: 22,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var index = 0; index < _items.length; index++)
              Expanded(child: _buildItem(index)),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    final selected = selectedIndex == index;
    final color = selected ? const Color(0xFF0C192C) : const Color(0xFF94A3B8);

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: selected ? null : () => onSelected(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: selected ? 34 : 30,
                height: selected ? 34 : 30,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0C192C)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 19,
                  color: selected ? Colors.white : color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 9,
                  height: 1,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
