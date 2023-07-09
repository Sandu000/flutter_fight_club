import 'package:flutter/material.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  const _MainPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child:Column(
           children: [
            const SizedBox(height:24),
             Center(
              child: Text(
                "The\nFight\nClub".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    color: FightClubColors.darkGreyText),
                ),
             ),
             Expanded(child:SizedBox()),
             FutureBuilder<String?>(
               future: SharedPreferences.getInstance().then(
                       (sharedPreferences) => sharedPreferences.getString("last_fight_result"),
               ),
               builder: (context, snapshot) {
                 if(!snapshot.hasData || snapshot.data == null) {
                   return const SizedBox();
                 }
                 return Center(child: Text(snapshot.data!));
                 },
             ),
             Expanded(child:SizedBox()),
             ActionButton(
               text: "Start".toUpperCase(),
               voidCallback:(){
                 Navigator.of(context).push(
                     MaterialPageRoute(
                         builder: (context) => FightPage(),
                     ),
                 );
                 },
               color: FightClubColors.blackButton,
             ),
             const SizedBox(height: 16,)
           ],
        ),
      ),
    );
  }
}
