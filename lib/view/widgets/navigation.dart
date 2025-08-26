import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  double _barPosition = 0;

  @override
  void didUpdateWidget(covariant CustomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _barPosition = MediaQuery.of(context).size.width / 5 * widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4FC3F7),
            Color(0xFF29B6F6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.translate,
                label: 'Translate',
                index: 1,
                isSelected: widget.currentIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.chat,
                label: 'AI Chat',
                index: 2,
                isSelected: widget.currentIndex == 2,
              ),
              _buildNavItem(
                icon: Icons.menu_book,
                label: 'Phrasebook',
                index: 3,
                isSelected: widget.currentIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                index: 4,
                isSelected: widget.currentIndex == 4,
              ),
            ],
          ),
          AnimatedPositioned(
            bottom: 0,
            left: _barPosition,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 3,
              width: MediaQuery.of(context).size.width / 5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        setState(() {
          _barPosition = MediaQuery.of(context).size.width / 5 * index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
