// equipment_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_portfolio_app/recipes/models/recipe.dart'; // for EquipmentItem

class EquipmentWidget extends StatefulWidget {
  final List<EquipmentItem> equipment;
  final bool isEditable;
  final Function(List<EquipmentItem>)? onEquipmentChanged;

  const EquipmentWidget({
    Key? key,
    required this.equipment,
    this.isEditable = false,
    this.onEquipmentChanged,
  }) : super(key: key);

  @override
  _EquipmentWidgetState createState() => _EquipmentWidgetState();
}

class _EquipmentWidgetState extends State<EquipmentWidget> {
  late List<EquipmentItem> _editableEquipment;

  @override
  void initState() {
    super.initState();
    _editableEquipment = List.from(widget.equipment);
  }

  @override
  void didUpdateWidget(covariant EquipmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isEditable && widget.isEditable ||
        oldWidget.equipment != widget.equipment) {
      _editableEquipment = List.from(widget.equipment);
    }
  }

  void _onItemChanged(String id, String newValue) {
    final updatedList = _editableEquipment.map((item) {
      return item.id == id ? item.copyWith(name: newValue) : item;
    }).toList();

    setState(() {
      _editableEquipment = updatedList;
    });
    widget.onEquipmentChanged?.call(updatedList);
  }

  void _addEquipment() {
    final updatedList = List<EquipmentItem>.from(_editableEquipment)
      ..add(EquipmentItem(name: 'New Equipment'));

    setState(() {
      _editableEquipment = updatedList;
    });
    widget.onEquipmentChanged?.call(updatedList);
  }

  void _removeEquipment(String id) {
    final updatedList =
        _editableEquipment.where((item) => item.id != id).toList();

    setState(() {
      _editableEquipment = updatedList;
    });
    widget.onEquipmentChanged?.call(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    if (_editableEquipment.isEmpty && !widget.isEditable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Equipment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• No equipment listed', style: TextStyle(fontSize: 16)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Equipment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ..._editableEquipment.map((item) {
          return Padding(
            key: ValueKey(item.id),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: widget.isEditable
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: item.name,
                          onChanged: (value) =>
                              _onItemChanged(item.id, value),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _removeEquipment(item.id),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
          );
        }).toList(),

        if (widget.isEditable)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton.icon(
              onPressed: _addEquipment,
              icon: const Icon(Icons.add),
              label: const Text('Add Equipment'),
            ),
          ),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';

// class EquipmentWidget extends StatelessWidget {
//   final List<String>? equipment;

//   const EquipmentWidget({Key? key, this.equipment}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (equipment == null || equipment!.isEmpty) {
//       return const Text('Unknown');
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Equipment',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...equipment!.map((item) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('• ', style: TextStyle(fontSize: 16)),
//                 Expanded(
//                   child: Text(
//                     item,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }