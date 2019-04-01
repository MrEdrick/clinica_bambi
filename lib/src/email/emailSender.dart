import 'dart:convert';
import 'email.dart';
import 'package:http/http.dart' as http;

class EmailSender {
  Map _header;
  String _url;
  Email _email;

  EmailSender(this._header, this._url, this._email);

  Map get header => _header;
  set header(Map header) => _header = header;

  String get url => _url;
  set url(String url) => _url = url;

  Email get email => _email;
  set email(Email email) => _email = email;

  Future<http.Response> sendEmail() async {
    Client httpLocal;
    url = "https://us-east-1.console.aws.amazon.com/apigateway/home?region=us-east-1#/apis/mz8uki4o3l/resources/dh84j1o5ge/sendEmail";
    String content = '''
      {
  "subject": "Teste de e-mail",
  "message": "Esta é a mensage de teste de e-mail pela API",
  "toAddresses": "clinicaodontologicabambi@gmail.com",
  "source": "clinicaodontologicabambi@gmail.com"
}
                      ''';

    String body = json.encode(content);

    return await httpLocal.post(url, headers: {'Content-Type': 'application/json'}, body: body);
  }
}
