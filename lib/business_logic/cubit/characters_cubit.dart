import 'package:bloc/bloc.dart';
import 'package:breaking_bad/data/models/character.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:breaking_bad/data/reposetories/characters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository repository;

  CharactersCubit(this.repository) : super(CharactersInitial());
  List<Character> characters = [];

  Future<void> getAllCharacters() async {
    emit(GetCharactersLoading());
    await repository.getCharacters().then((characters) {
      print(characters.length);
      this.characters.addAll(characters);
      emit(GetCharactersSuccess(characters));
    }).catchError((error) {
      print('error ${error.toString()}');
      emit(GetCharactersError(error.toString()));
    });
  }

  List<Quote> quotes = [];

  Future<void> getAllQuotes(String characterName) async {
    emit(GetQuotesLoading());
    await repository.getQuotes(characterName).then((quotes) {
      print(quotes.length);
      this.quotes.addAll(quotes);
      emit(GetQuotesSuccess(quotes));
    }).catchError((error) {
      print('error ${error.toString()}');
      emit(GetQuotesError(error.toString()));
    });
  }
}
