import 'email.dart';
import 'emailSender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  EmailSender emailSenderGmail() {
    final smtpServer = gmail(email.senderEmail, email.senderPassword);

    final message = new Message()
      ..from = new Address(email.senderEmail, email.senderName)
      ..recipients.add(email.receiver)
      ..ccRecipients.addAll([''])
      ..bccRecipients.add(null)
      ..subject = email.subject
      ..text = email.content;

    return new EmailSender(email, smtpServer, message, null);
  }
}
