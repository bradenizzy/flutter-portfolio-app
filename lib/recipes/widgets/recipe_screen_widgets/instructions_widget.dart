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
  bool _forceExpand = false;
  List<bool> _expandedSections = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _expandedSections = List.generate(widget.instructions.length, (index) => false);
  }

  @override
  void didUpdateWidget(InstructionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instructions.length != oldWidget.instructions.length ||
        widget.instructions.any((section) => section.steps.length != 
          oldWidget.instructions[widget.instructions.indexOf(section)].steps.length)) {
      _disposeControllers();
      _initializeControllers();
      // Update expanded sections list when number of sections changes
      if (widget.instructions.length != oldWidget.instructions.length) {
        _expandedSections = List.generate(widget.instructions.length, (index) => 
          index < _expandedSections.length ? _expandedSections[index] : false);
      }
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
    _stepControllers[sectionIndex][stepIndex].dispose();
    _stepControllers[sectionIndex].removeAt(stepIndex);
    widget.onDeleteStep?.call(sectionIndex, stepIndex);
  }

  void _addStepController(int sectionIndex) {
    _stepControllers[sectionIndex].add(TextEditingController(text: ''));
    widget.onAddStep?.call(sectionIndex);
  }

  void _addSectionController() {
    _sectionControllers.add(TextEditingController(text: 'New Section'));
    _stepControllers.add([TextEditingController(text: 'New Step')]);
    widget.onAddSection?.call();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Widget _buildSectionHeader(int sectionIndex) {
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
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDeleteSection?.call(sectionIndex),
                ),
              ],
            )
          : Text(
              widget.instructions[sectionIndex].sectionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
    );
  }

  Widget _buildSectionBody(int sectionIndex) {
    final section = widget.instructions[sectionIndex];
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _forceExpand = !_forceExpand;
                    if (_forceExpand) {
                      _expandedSections = List.generate(widget.instructions.length, (index) => true);
                    } else {
                      _expandedSections = List.generate(widget.instructions.length, (index) => false);
                    }
                  });
                },
                child: Text(
                  _forceExpand ? 'Collapse All' : 'See All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _expandedSections[index] = isExpanded;
            });
          },
          expandedHeaderPadding: EdgeInsets.zero,
          children: List.generate(widget.instructions.length, (sectionIndex) {
            final section = widget.instructions[sectionIndex];
            return ExpansionPanel(
              isExpanded: _expandedSections[sectionIndex],
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return _buildSectionHeader(sectionIndex);
              },
              body: _buildSectionBody(sectionIndex),
            );
          }),
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