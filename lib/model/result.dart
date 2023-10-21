import 'package:kontaktlista/model/contact.dart';

class Result {
  List<Contact> results = [];

  Result({required this.results});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      json['results'].forEach((v) {
        results.add(Contact.fromJson(v));
      });
    }
  }
}
