import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
              const SizedBox(height: 4),
              Text('$count', style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}
