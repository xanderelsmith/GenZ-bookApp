import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../enums/enums.dart';

extension RegistrationTypeMembers on RegistrationType {
  String? get description => const {
        RegistrationType.GENRE: 'Genre',
        RegistrationType.PUBLISHER: 'Publisher',
        RegistrationType.AUTHOR: 'Author',
      }[this];

  String? get className => const {
        RegistrationType.GENRE: 'Genre',
        RegistrationType.PUBLISHER: 'Publisher',
        RegistrationType.AUTHOR: 'Author',
      }[this];
}

Future<List<ParseObject>?>? doListRegistration(
    RegistrationType registrationType) async {
  QueryBuilder<ParseObject> queryRegistration = QueryBuilder<ParseObject>(
      ParseObject(registrationType.className.toString()));
  final ParseResponse apiResponse =
      await queryRegistration.query<ParseObject>();

  if (apiResponse.success && apiResponse.results != null) {
    return apiResponse.results as List<ParseObject>;
  } else {
    return [];
  }
}

Future<void> doSaveRegistration(
    String name, RegistrationType registrationType) async {
  final registration = ParseObject(registrationType.className.toString())
    ..set('name', name);
  await registration.save();
}
