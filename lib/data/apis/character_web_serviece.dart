import 'package:breaking_bad/constants/strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CharacterWebService {
  late Dio dio;

  CharacterWebService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }
  Future<List<dynamic>?> getCharacters() async {
    late List<dynamic>? list;
    await dio.get('characters').then((value) {
      if (kDebugMode) {
        print('web service get data success');
      }
      list= value.data;
    }).catchError((error) {
      if (kDebugMode) {
        print('web service get data error: $error');
      }
    });
    return list;
  }

  Future<List<dynamic>?> getQuotes(String characterName) async {
    late List<dynamic>? quotes;
    await dio.get('quote',
    queryParameters: {
      'author' : characterName,
    }
    ).then((value) {
      if (kDebugMode) {
        print('web service get quotes success');
      }
      quotes= value.data;
    }).catchError((error) {
      if (kDebugMode) {
        print('web service get quotes error: $error');
      }
    });
    return quotes;
  }
}
