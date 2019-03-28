import 'dart:async';
import 'email.dart';
import 'emailSender.dart';
import 'package:googleapis/gmail/v1.dart';

class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  EmailSender emailSenderGmail() async {
    String url = 'https://www.googleapis.com/gmail/v1/users/' + email.receiver + '/messages/send';

    GoogleSignIn googleSignIn = new GoogleSignIn(
      scopes: <String>[
        'https://www.googleapis.com/auth/gmail.send'
      ],
    );

    await googleSignIn.signIn().then((data) {
      data.authHeaders.then((result) {
        Map header = {'Authorization': result['Authorization'], 'X-Goog-AuthUser': result['X-Goog-AuthUser'],
                      'Accept': 'application/json', 'Content-type': 'application/json'};
        return new EmailSender(header, url, email);
      });                          
    });
  }
}
