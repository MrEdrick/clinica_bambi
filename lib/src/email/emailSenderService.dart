import 'dart:async';
import 'email.dart';
import 'emailSender.dart';
//import 'package:googleapis/gmail/v1.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  Future<EmailSender> emailSenderGmail() async {

    final smtpServer = new SmtpServer("smtp.gmail.com", ssl: true, port: 587, username: 'jddedrick42@gmail.com', password: 'r2d2paradoxo42');
    
    final message = new Message()
      ..from = new Address('jddedrick42@gmail.com', 'Your name')
      ..recipients.add('edrick_42@outlook.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${new DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    final sendReports = await send(message, smtpServer);    
    
    //String url = 'https://www.googleapis.com/gmail/v1/users/' + email.receiver + '/messages/send';

    /*GoogleSignIn googleSignIn = new GoogleSignIn(
      scopes: <String>[
        'https://www.googleapis.com/auth/gmail.send'
      ],
    );*/

    /*await googleSignIn.signIn().then((data) {
      data.authHeaders.then((result) {
        Map header = {'Authorization': result['Authorization'], 'X-Goog-AuthUser': result['X-Goog-AuthUser'],
                      'Accept': 'application/json', 'Content-type': 'application/json'};
        return new EmailSender(header, url, email);
      });                          
    });*/
  }
}
