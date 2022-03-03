part of 'characters_cubit.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class GetCharactersLoading extends CharactersState {}
class GetCharactersSuccess extends CharactersState {
  final List<Character> characters;
  GetCharactersSuccess(this.characters);
}
class GetCharactersError extends CharactersState {
  final String error;
  GetCharactersError(this.error);
}

class GetQuotesLoading extends CharactersState {}
class GetQuotesSuccess extends CharactersState {
  final List<Quote> quotes;
  GetQuotesSuccess(this.quotes);
}
class GetQuotesError extends CharactersState {
  final String error;
  GetQuotesError(this.error);
}
