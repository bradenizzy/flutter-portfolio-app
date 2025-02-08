// equipment_widget.dart

import 'package:flutter/material.dart';

class EquipmentWidget extends StatelessWidget {
  final List<String>? equipment;

  const EquipmentWidget({Key? key, this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (equipment == null || equipment!.isEmpty) {
      return const Text('Unknown');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Equipment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...equipment!.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}