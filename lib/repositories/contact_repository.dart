import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/model/result.dart';

abstract class CrudInterface {
  Future<bool> insert(Contact address);
  Future<bool> update(Contact address);
  Future<bool> delete(Contact address);
  Future<List<Contact>> fetch();
}

class ContactRepository implements CrudInterface {
  final _dio = Dio();

  ContactRepository() {
    _dio.options.headers['X-Parse-Application-Id'] =
        dotenv.get('X-Parse-Application-Id');
    _dio.options.headers['X-Parse-REST-API-Key'] =
        dotenv.get('X-Parse-REST-API-Key');
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }

  @override
  Future<bool> delete(Contact address) async {
    var result = await _dio.delete('/Contacts/${address.getObjectId}');
    return (result.statusCode ?? 0) >= 200 && (result.statusCode ?? 0) <= 300;
  }

  @override
  Future<List<Contact>> fetch() async {
    var result = await _dio.get('/Contacts');
    return Result.fromJson(result.data).results;
  }

  @override
  Future<bool> insert(Contact address) async {
    try {
      print('tentando insert...');
      var result = await _dio.post('/Contacts', data: address.toMap());

      return (result.statusCode ?? 0) == 200;
    } on Exception catch (e) {
      print('deu ruim insert...');
      return false;
    }
  }

  @override
  Future<bool> update(Contact contact) async {
    try {
      var result = await _dio.put('/Contacts/${contact.getObjectId}',
          data: contact.toMap());
      return (result.statusCode ?? 0) == 200;
    } on Exception catch (e) {
      return false;
    }
  }
}
