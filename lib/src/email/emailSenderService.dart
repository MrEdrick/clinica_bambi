import 'dart:async';
import 'email.dart';
import 'emailSenderHTTP.dart';
import 'email_constants.dart';

class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  Future<EmailSenderHTTP> emailSenderAmazon() async {  
    return new EmailSenderHTTP({}, 
                               AMAZON_API_ENDPONT_SEND_EMAIL, 
                               {"subject" : email.subject,
                                "message" : email.message,
                                "toAddresses" : email.receiver,
                                "source" : email.sender});
  }
}
