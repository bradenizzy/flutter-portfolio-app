// scaling_ingredients_widget.dart

import 'package:flutter/material.dart';

class ScalingPickerOverlay extends StatefulWidget {
  final double currentMultiplier; // Current multiplier (from parent)
  final Function(double) onDone; // Callback for when "Done" is tapped
  final VoidCallback onRevert; // Callback for "Revert to Original"

  ScalingPickerOverlay({
    Key? key,
    required this.currentMultiplier,
    required this.onDone,
    required this.onRevert,
  }) : super(key: key);

  @override
  _ScalingPickerOverlayState createState() => _ScalingPickerOverlayState();
}

class _ScalingPickerOverlayState extends State<ScalingPickerOverlay> {
  late int wholeNumber;
  late String fraction;
  
  @override
  void initState() {
    super.initState();
    // Initialize based on current multiplier, or 0 if it's a new selection
    wholeNumber = 0;
    double decimal = widget.currentMultiplier - wholeNumber;
    
    // Find closest fraction
    fraction = _fractions.reduce((a, b) {
      double aDiff = (_fractionToDouble[a] ?? 0.0 - decimal).abs();
      double bDiff = (_fractionToDouble[b] ?? 0.0 - decimal).abs();
      return aDiff < bDiff ? a : b;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate responsive heights
    final pickerHeight = screenHeight * 0.25; // 25% of screen height
    final minPickerHeight = 150.0; // Minimum height
    final maxPickerHeight = 250.0; // Maximum height
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and done button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Scaling ingredients by:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  double multiplier = _calculateMultiplier(wholeNumber, fraction);
                  widget.onDone(multiplier);
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ],
          ),
          // Revert button centered above wheels
          if (widget.currentMultiplier != 1.0) ...[
            Center(
              child: TextButton(
                onPressed: () {
                  widget.onRevert();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Revert to Original",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            height: pickerHeight.clamp(minPickerHeight, maxPickerHeight),
            child: Stack(
              children: [
                // Center highlight overlay
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Whole Number Picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: FixedExtentScrollController(initialItem: wholeNumber),
                        itemExtent: 48,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            wholeNumber = index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 101,
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                "$index",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: wholeNumber == index ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Fraction Picker
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 48,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            fraction = _fractions[index];
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: _fractions.length,
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                _fractions[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: fraction == _fractions[index] ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMultiplier(int wholeNumber, String fraction) {
    double fractionValue = _fractionToDouble[fraction] ?? 0.0;
    if (wholeNumber == 0) {
      return fractionValue;
    }
    return wholeNumber.toDouble() + fractionValue;
  }

  final List<String> _fractions = ["", "1/8", "1/6", "1/5", "1/4", "1/3", "1/2", "2/3", "3/4"];
  final Map<String, double> _fractionToDouble = {
    "1/8": 0.125,
    "1/6": 0.1667,
    "1/5": 0.2,
    "1/4": 0.25,
    "1/3": 0.3333,
    "1/2": 0.5,
    "2/3": 0.6667,
    "3/4": 0.75,
    "": 0.0, // Default fraction
  };
}