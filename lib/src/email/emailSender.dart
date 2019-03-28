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
    String content =  '''
      Content-Type: txt/html; charset="utf-8"
      MIME-Version: 1.0
      Content-Transfer-Enconding: 7bit
      to: ${email.receiver}
      from: ${email.senderEmail}
      subject: ${email.subject}
      ${email.message}
                      ''';

    String body = json.encode({'raw': base64Encode(utf8.encode(content))});

    return await http.post(
      url,
      headers: header,
      body: body
    );
  }
}
