import 'dart:async';
import 'email.dart';
import 'emailSender.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'dart:convert';
//import 'dart:html';
//import 'package:googleapis/gmail/v1.dart';


class EmailSenderService {
  final Email _email;

  EmailSenderService(this._email);

  Email get email => _email;

  Future<EmailSender> emailSenderGmail() async {  
  var data = {"subject": "Teste de e-mail",
  "message": "Esta é a mensage de teste de e-mail pela API",
  "toAddresses": "clinicaodontologicabambi@gmail.com",
  "source": "clinicaodontologicabambi@gmail.com"};
  Response uriResponse;


    try {
      uriResponse = await new BrowserClient().post(
        //'https://us-east-1.console.aws.amazon.com/apigateway/home?region=us-east-1#/apis/mz8uki4o3l/resources/dh84j1o5ge/sendEmail',
        'https://mz8uki4o3l.execute-api.us-east-1.amazonaws.com/default/sendEmail',
        headers: {},
        body: jsonEncode(data));
    } finally {
      print(uriResponse.toString());
    }
    
    return new EmailSender({}, '', email);
  }
}
