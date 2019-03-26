import 'dart:async';
import 'email.dart';
import 'emailSender.dart';
import 'package:googleapis/gmail/v1.dart';

class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  EmailSender emailSenderGmail() async {
    await googleSignIn.signIn().then((data) {
      data.authHeaders.then((result) {
        var header = {'Authorization': result['Authorization'], 'X-Goog-AuthUser': result['X-Goog-AuthUser']};
        //testingEmail(data.email, header);
      });                          
    });
    //final smtpServer = gmail(email.senderEmail, email.senderPassword);

    /*final message = new Message()
      ..from = new Address(email.senderEmail, email.senderName)
      ..recipients.add(email.receiver)
      ..ccRecipients.addAll([''])
      ..bccRecipients.add(null)
      ..subject = email.subject
      ..text = email.content;

    return new EmailSender(email, smtpServer, message, null);*/
  }
}
