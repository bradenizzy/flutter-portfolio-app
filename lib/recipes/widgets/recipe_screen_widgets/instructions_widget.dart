// instructions_widget.dart

import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class InstructionsWidget extends StatefulWidget {
  final List<InstructionSection> instructions;
  final bool isEditable;
  final Function(int, String)? onSectionTitleChanged;
  final Function(int, int, String)? onStepChanged;
  final Function(int)? onDeleteSection;
  final Function(int, int)? onDeleteStep;
  final VoidCallback? onAddSection;
  final Function(int)? onAddStep;

  const InstructionsWidget({
    Key? key,
    required this.instructions,
    this.isEditable = false,
    this.onSectionTitleChanged,
    this.onStepChanged,
    this.onDeleteSection,
    this.onDeleteStep,
    this.onAddSection,
    this.onAddStep,
  }) : super(key: key);

  @override
  State<InstructionsWidget> createState() => _InstructionsWidgetState();
}

class _InstructionsWidgetState extends State<InstructionsWidget> {
  late List<List<TextEditingController>> _stepControllers;
  late List<TextEditingController> _sectionControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(InstructionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instructions.length != oldWidget.instructions.length ||
        widget.instructions.any((section) => section.steps.length != 
          oldWidget.instructions[widget.instructions.indexOf(section)].steps.length)) {
      _disposeControllers();
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _sectionControllers = List.generate(
      widget.instructions.length,
      (index) => TextEditingController(text: widget.instructions[index].sectionTitle),
    );

    _stepControllers = List.generate(
      widget.instructions.length,
      (sectionIndex) => List.generate(
        widget.instructions[sectionIndex].steps.length,
        (stepIndex) => TextEditingController(
          text: widget.instructions[sectionIndex].steps[stepIndex],
        ),
      ),
    );
  }

  void _disposeControllers() {
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    for (var sectionControllers in _stepControllers) {
      for (var controller in sectionControllers) {
        controller.dispose();
      }
    }
  }

  void _updateControllersAfterDelete(int sectionIndex, int stepIndex) {
    // Dispose the controller for the deleted step
    _stepControllers[sectionIndex][stepIndex].dispose();
    
    // Remove the controller from the list
    _stepControllers[sectionIndex].removeAt(stepIndex);
    
    // Call the parent's delete callback
    widget.onDeleteStep?.call(sectionIndex, stepIndex);
  }

  void _addStepController(int sectionIndex) {
    // Add a new controller for the new step
    _stepControllers[sectionIndex].add(TextEditingController(text: ''));
    
    // Call the parent's add callback
    widget.onAddStep?.call(sectionIndex);
  }

  void _addSectionController() {
    // Add new controllers for the new section
    _sectionControllers.add(TextEditingController(text: 'New Section'));
    _stepControllers.add([TextEditingController(text: 'New Step')]);
    
    // Call the parent's add callback
    widget.onAddSection?.call();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Instructions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ExpansionPanelList.radio(
          children: List.generate(widget.instructions.length, (sectionIndex) {
            final section = widget.instructions[sectionIndex];
            return ExpansionPanelRadio(
              value: '$sectionIndex-${section.sectionTitle}',
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: widget.isEditable
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _sectionControllers[sectionIndex],
                                onChanged: (value) => widget.onSectionTitleChanged?.call(sectionIndex, value),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Section Title',
                                ),
                              ),
                            ),
                            if (widget.isEditable)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => widget.onDeleteSection?.call(sectionIndex),
                              ),
                          ],
                        )
                      : Text(
                          section.sectionTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                );
              },
              body: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: section.steps.length,
                    itemBuilder: (context, stepIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stepIndex + 1}. ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: widget.isEditable
                                  ? TextField(
                                      controller: _stepControllers[sectionIndex][stepIndex],
                                      onChanged: (value) => widget.onStepChanged?.call(
                                        sectionIndex,
                                        stepIndex,
                                        value,
                                      ),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: null,
                                    )
                                  : Text(section.steps[stepIndex]),
                            ),
                            if (widget.isEditable)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _updateControllersAfterDelete(sectionIndex, stepIndex),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (widget.isEditable)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _addStepController(sectionIndex),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Step'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addSectionController,
              icon: const Icon(Icons.add),
              label: const Text('Add Instructions Section'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
      ],
    );
  }
}