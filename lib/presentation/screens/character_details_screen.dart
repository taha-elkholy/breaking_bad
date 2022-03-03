import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad/constants/my_colors.dart';
import 'package:breaking_bad/data/models/character.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({required this.character, Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo(
                          'Job : ', character.jobOccupation.join(' / ')),
                      divider(270),
                      characterInfo('Appeared in : ', character.category),
                      divider(200),
                      if (character.appearance.isNotEmpty)
                        characterInfo(
                            'Seasons : ', character.appearance.join(' / ')),
                      if (character.appearance.isNotEmpty) divider(230),
                      characterInfo('Status : ', character.status),
                      divider(250),
                      if (character.betterCallSaulAppearance.isNotEmpty)
                        characterInfo('Better Call Soul seasons : ',
                            character.betterCallSaulAppearance.join(' / ')),
                      if (character.betterCallSaulAppearance.isNotEmpty)
                        divider(100),
                      characterInfo('Actor/Actress : ', character.name),
                      divider(190),
                      const SizedBox(height: 20),
                      Builder(
                        builder: (context) {
                          BlocProvider.of<CharactersCubit>(context).getAllQuotes(character.name);

                          return BlocBuilder<CharactersCubit, CharactersState>(
                            builder: (context, state) {
                              return checkForQuote(state);
                            },
                          );
                        }
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 300)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 500,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.name,
          style: const TextStyle(color: MyColors.myWhit),
        ),
        background: Hero(
            tag: character.charId,
            child: Image.network(
              character.image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: title,
              style: const TextStyle(
                  color: MyColors.myWhit,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          TextSpan(
              text: value,
              style: const TextStyle(color: MyColors.myWhit, fontSize: 16)),
        ]));
  }

  Widget divider(double endIndent) {
    return Divider(
      thickness: 2,
      height: 30,
      endIndent: endIndent,
      color: MyColors.myYellow,
    );
  }

  Widget checkForQuote(CharactersState state) {
    List<Quote> quotes = [];
    if (state is GetQuotesSuccess) {
      if (state.quotes.isNotEmpty) {
        quotes = state.quotes;
        int quoteIndex = Random().nextInt(quotes.length - 1);
        return Center(
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: MyColors.myWhit, fontSize: 20, shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.white,
                offset: Offset(0, 0),
              )
            ]),
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              FlickerAnimatedText(quotes[quoteIndex].quote)
            ]),
          ),
        );
      } else {
        return Container();
      }
    } else if (state is GetQuotesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container();
    }
  }
}
