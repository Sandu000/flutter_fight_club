import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);
  @override
  State<FightPage> createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  int yourLives = maxLives;
  int enemyLives = maxLives;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();
  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors.background,
        body: SafeArea(
          child: Column(
            children: [
              FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemyLivesCount: enemyLives,
              ),
              const SizedBox(height: 30),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ColoredBox(
                      color: FightClubColors.darkPurple,
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(centerText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: FightClubColors.darkGreyText),
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
              const SizedBox(height: 30),
              ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              ActionButton(
                  text: yourLives == 0 || enemyLives == 0
                      ? "Back"
                      : "Go",
                  voidCallback: _onGoButtonClicked,
                  color: _getGoButtonColor()),
              const SizedBox(height: 16),
            ],
          ),
        ));
  }




  Color _getGoButtonColor() {
    if (yourLives == 0 || enemyLives == 0) {
      return FightClubColors.blackButton;
    } else if (defendingBodyPart == null && attackingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemyLives == 0) {
      Navigator.of(context).pop();
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemyLives -= 1;
        }

        if (youLoseLife) {
          yourLives -= 1;
        }
        final FightResult? fightResult = FightResult.calculateResult(yourLives, enemyLives);
        if(fightResult != null){
          SharedPreferences.getInstance().then((sharedPreferences){
            sharedPreferences.setString("last_fight_result", fightResult.result);
          });
        }
        centerText = _calculateCenterText(youLoseLife, enemyLoseLife);
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  String _calculateCenterText(final bool youLoseLife, final bool enemyLoseLife) {
    if(enemyLives == 0 && yourLives == 0){
      return "Draw";
    }else if(yourLives == 0){
      return "You lost";
    }else if(enemyLives == 0){
      return "You won";
    }else{
      final String first =  enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
          :"You attack was blocked.";
      final String secound =  youLoseLife
          ? "Enemy hit you ${whatEnemyAttacks.name.toLowerCase()}."
          :"Enemy's attack was blocked.";
      return "$first\n$secound";
    }

}

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemyLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemyLivesCount;

  const FightersInfo({
    super.key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemyLivesCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.white, FightClubColors.darkPurple])
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                    color: FightClubColors.darkPurple
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: yourLivesCount),
              Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "You",
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92)
                ],
              ),
              SizedBox(height: 44, width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FightClubColors.blueButton
                  ),
                  child: Center(
                    child: Text(
                      "vs",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Image.asset(FightClubImages.enemyAvatar, width: 92, height: 92)
                  ],
                ),
              ),
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: enemyLivesCount)
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  const ControlsWidget(
      {super.key,
        this.defendingBodyPart,
        this.attackingBodyPart,
        required this.selectDefendingBodyPart,
        required this.selectAttackingBodyPart});

  final BodyPart? defendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                "Defend".toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyValueSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyValueSetter: selectDefendingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyValueSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text(
                "Attack".toUpperCase(),
                style: const TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                  bodyPart: BodyPart.head,
                  selected: attackingBodyPart == BodyPart.head,
                  bodyValueSetter: selectAttackingBodyPart),
              const SizedBox(height: 14),
              BodyPartButton(
                  bodyPart: BodyPart.torso,
                  selected: attackingBodyPart == BodyPart.torso,
                  bodyValueSetter: selectAttackingBodyPart),
              const SizedBox(height: 14),
              BodyPartButton(
                  bodyPart: BodyPart.legs,
                  selected: attackingBodyPart == BodyPart.legs,
                  bodyValueSetter: selectAttackingBodyPart),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget(
      {Key? key,
        required this.overallLivesCount,
        required this.currentLivesCount})
      : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(overallLivesCount, (index) {
          if (index < currentLivesCount) {
            return Padding(
              padding: EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4 : 0),
              child: Image.asset(
                FightClubIcons.heartFull,
                width: 18,
                height: 18,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4 : 0),
              child: Image.asset(
                FightClubIcons.heartEmpty,
                width: 18,
                height: 18,
              ),
            );
          }
        }));
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyValueSetter;

  const BodyPartButton(
      {super.key,
        required this.bodyPart,
        required this.selected,
        required this.bodyValueSetter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyValueSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? FightClubColors.blueButton
                : Colors.transparent,
            border: ! selected ?Border.all(color: FightClubColors.darkGreyText, width: 2) : null,
          ),
          child: Center(
              child: Text(bodyPart.name.toUpperCase(),
                  style: TextStyle(
                      color: selected
                          ? FightClubColors.whiteText
                          : FightClubColors.darkGreyText))),
        ),
      ),
    );
  }
}