import 'email.dart';
import 'package:http/http.dart' as http;

class EmailSender {
  String _url;
  Email _email;
  //SmtpServer _smtpServer;
  //Message _message;
  //List<SendReport> _sendReports;

  EmailSender(this._url, this._email); //, this._smtpServer, this._message, this._sendReports

  String get url => _url;
  set url(String url) => _url = url;

  Email get email => _email;
  set email(Email email) => _email = email;

  /*
  SmtpServer get smtpServer => _smtpServer;
  set smtpServer(SmtpServer smtpServer) => _smtpServer = smtpServer; 

  Message get message => _message;
  set message(Message message) => _message = message; 

  List<SendReport> get sendReports => _sendReports;
  set sendReports(List<SendReport> message) => _sendReports = sendReports; 
  */
  sendEmail() async {
    final http.Response response =
        await http.post(url, headers: header, body: body);
    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
      });
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    print('ok: ' + response.statusCode.toString());
    //sendReports = await send(message, smtpServer);
  }
}
