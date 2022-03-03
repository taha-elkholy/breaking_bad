import 'package:breaking_bad/data/apis/character_web_serviece.dart';
import 'package:breaking_bad/data/models/character.dart';
import 'package:breaking_bad/data/models/quote.dart';
import 'package:flutter/foundation.dart';

class CharactersRepository{
final CharacterWebService webService;

CharactersRepository(this.webService);

Future<List<Character>> getCharacters() async {
  List<Character> characters = [];
  await webService.getCharacters()
      .then((value) {
       if(value != null){
         if(value.isNotEmpty){
           for (var element in value) {
             characters.add(Character.fromJson(element));
           }
           if (kDebugMode) {
             print('repository success');
           }
         }
       }else{
         if (kDebugMode) {
           print('null value returned from web service');
         }
       }
  })
      .catchError((error){
        if (kDebugMode) {
          print('repository error: $error');
        }
  });
  return characters;
}

Future<List<Quote>> getQuotes(String characterName) async {
  List<Quote> quotes = [];
  await webService.getQuotes(characterName)
      .then((value) {
    if(value != null){
      if(value.isNotEmpty){
        for (var element in value) {
          quotes.add(Quote.fromJson(element));
        }
        if (kDebugMode) {
          print('repository Quote success');
        }
      }
    }else{
      if (kDebugMode) {
        print('null Quote value returned from web service');
      }
    }
  })
      .catchError((error){
    if (kDebugMode) {
      print('repository Quote error: $error');
    }
  });
  return quotes;
}

}