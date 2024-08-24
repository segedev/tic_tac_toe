import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/game_view_model.dart';

class DifficultySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameViewModel = context.watch<GameViewModel>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(
            maxWidth: 204,
            minWidth: 204,
            maxHeight: 156,
            minHeight: 156,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              // color: controller.selectedOption.value == 'Co-Owner'
              //     ? AppColors.primary
              //     : AppColors.newBorderColor,
              color: const Color.fromARGB(255, 6, 46, 78),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Center(
            child: Text('Easy'),
          ),
        ),
        RadioListTile<Difficulty>(
          title: Text('Easy'),
          value: Difficulty.easy,
          groupValue: gameViewModel.difficulty,
          onChanged: (difficulty) {
            gameViewModel.setDifficulty(difficulty!);
          },
        ),
        RadioListTile<Difficulty>(
          title: Text('Medium'),
          value: Difficulty.medium,
          groupValue: gameViewModel.difficulty,
          onChanged: (difficulty) {
            gameViewModel.setDifficulty(difficulty!);
          },
        ),
        RadioListTile<Difficulty>(
          title: Text('Hard'),
          value: Difficulty.hard,
          groupValue: gameViewModel.difficulty,
          onChanged: (difficulty) {
            gameViewModel.setDifficulty(difficulty!);
          },
        ),
      ],
    );
  }
}
