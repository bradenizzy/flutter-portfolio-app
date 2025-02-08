// instruction_callbacks.dart

import 'package:flutter_portfolio_app/recipes/models/recipe.dart';

class InstructionCallbacks {
  static void updateSectionTitle(Recipe recipe, Function setState, int sectionIndex, String newTitle) {
    setState(() {
      recipe.instructions[sectionIndex] = InstructionSection(
        sectionTitle: newTitle,
        steps: recipe.instructions[sectionIndex].steps,
      );
    });
  }

  static void updateStep(Recipe recipe, Function setState, int sectionIndex, int stepIndex, String newStep) {
    setState(() {
      recipe.instructions[sectionIndex].steps[stepIndex] = newStep;
    });
  }

  static void deleteSection(Recipe recipe, Function setState, int sectionIndex) {
    setState(() {
      recipe.instructions.removeAt(sectionIndex);
    });
  }

  static void deleteStep(Recipe recipe, Function setState, int sectionIndex, int stepIndex) {
    setState(() {
      recipe.instructions[sectionIndex].steps.removeAt(stepIndex);
    });
  }

  static void addSection(Recipe recipe, Function setState) {
    setState(() {
      recipe.instructions.add(InstructionSection(
        sectionTitle: 'New Section',
        steps: ['New Step'],
      ));
    });
  }

  static void addStep(Recipe recipe, Function setState, int sectionIndex) {
    setState(() {
      recipe.instructions[sectionIndex].steps.add('New Step');
    });
  }
}