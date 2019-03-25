import 'dart:async';
import 'email.dart';
import 'email_constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SendEmail {
  Email _email;

  SendEmail(this._email);

  Email get email => _email;
  set email(Email email) => _email = email; 

  send() async {
    smtpServer = gmail(email.senderEmail, email.senderPassword);
    message = new Message()
      ..from = new Address(email.senderEmail, CLIENT_NAME)
      ..recipients.add(email.senderEmail)
      ..ccRecipients.addAll([''])
      ..bccRecipients.add(null)
      ..subject = email.subject
      ..text = email.content;

    final sendReports = await send(message, smtpServer);
  }
}