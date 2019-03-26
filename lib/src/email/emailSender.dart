import 'email.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  Email _email;
  SmtpServer _smtpServer; 
  Message _message;
  List<SendReport> _sendReports;

  EmailSender(this._email, this._smtpServer, this._message, this._sendReports);

  Email get email => _email;
  set email(Email email) => _email = email; 

  SmtpServer get smtpServer => _smtpServer;
  set smtpServer(SmtpServer smtpServer) => _smtpServer = smtpServer; 

  Message get message => _message;
  set message(Message message) => _message = message; 

  List<SendReport> get sendReports => _sendReports;
  set sendReports(List<SendReport> message) => _sendReports = sendReports; 

  sendEmail() async {
    //final smtpServer = gmail(email.senderEmail, email.senderPassword);
    /*final message = new Message()
      ..from = new Address(email.senderEmail, email.senderName)
      ..recipients.add(email.receiver)
      ..ccRecipients.addAll([''])
      ..bccRecipients.add(null)
      ..subject = email.subject
      ..text = email.content;*/

    sendReports = await send(message, smtpServer);
  }
}