import 'dart:async';
import 'dart:convert';
import 'package:service_worker/worker.dart' as sw;

Map<String, dynamic> _configVal;

String get apiKey => _getConfig('API_KEY');
String get authDomain => _getConfig('AUTH_DOMAIN');
String get databaseUrl => _getConfig('DATABASE_URL');
String get storageBucket => _getConfig('STORAGE_BUCKET');
String get projectId => _getConfig('PROJECT_ID');
String get messagingSenderId => _getConfig('MESSAGING_SENDER_ID');
String get serverKey => _getConfig('SERVER_KEY');
String get vapidKey => _getConfig('VAPID_KEY');


String _getConfig(String key) {
  if (_configVal == null) {
    throw new StateError('Você deve chamar config() primeiro');
  }

  var value = _configVal[key];

  if (value == null) {
    throw new ArgumentError('`$key` não está configurado em `config.json`.');
  }

  return value;
}

Future config() async {
  if (_configVal != null) {
    return;
  }

  try {
    var response = await sw.fetch('./assets/config.json');

    if (response.status > 399) {
      throw new StateError(
          "Problema com o server: ${response.status} ${response.body}");
    }

    _configVal = jsonDecode(await response.text());
  } catch (e) {
    print("Erro ao pegar `config.json`. Confirme se existe. Erro: " + e.toString());
    rethrow;
  }
}