import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  
  const AddButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.add,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ],
      ),
    );
  }
}