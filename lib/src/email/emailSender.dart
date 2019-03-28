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

  sendEmail() async {
    String content =  '''
                      ''';
  }
}
