import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String change;
  final bool isPositive;
  final VoidCallback? onTap;

  const StockCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.isPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color changeColor =
    isPositive ? const Color(0xFF22D39A) : const Color(0xFFFF5A76);

    return Card(
      color: const Color(0xFF171A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          symbol,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              change,
              style: TextStyle(
                color: changeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}