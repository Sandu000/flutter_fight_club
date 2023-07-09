import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback voidCallback;
  final Color color;

  const ActionButton(
      {super.key,
        required this.text,
        required this.voidCallback,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
          color: color,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          height: 40,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: FightClubColors.whiteText),
          )
      ),
    );
  }
}