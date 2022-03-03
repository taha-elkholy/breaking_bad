import 'package:breaking_bad/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad/data/apis/character_web_serviece.dart';
import 'package:breaking_bad/data/models/character.dart';
import 'package:breaking_bad/data/reposetories/characters_repository.dart';
import 'package:breaking_bad/presentation/screens/character_details_screen.dart';
import 'package:breaking_bad/presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';

class AppRouter {
  late CharactersRepository repository;

  AppRouter() {
    repository = CharactersRepository(CharacterWebService());
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characterScreen:
        return MaterialPageRoute(builder: (_) {
          return BlocProvider(
            create: (BuildContext context) => CharactersCubit(repository),
            child: const CharactersScreen(),
          );
        });
      case characterDetailsScreen:
        // pass the character as argument
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => CharactersCubit(repository),
                  child: CharacterDetailsScreen(
                    character: character,
                  ),
                ));
    }
  }
}
