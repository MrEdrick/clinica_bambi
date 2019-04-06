import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';

class EmailSenderHTTP {
  Map _header;
  String _url;
  Map _body;

  EmailSenderHTTP(this._header, this._url, this._body);

  Map get header => _header;
  set header(Map header) => _header = header;

  String get url => _url;
  set url(String url) => _url = url;

  Map get body => _body;
  set body(Map body) => _body = body;

  Future<Response> sendEmail() async {
    Response resp;
    try {
      resp = await new BrowserClient().post(
        url,
        headers: {},
        body: jsonEncode(body));
    } finally {
      return resp;
    }
 }
}
