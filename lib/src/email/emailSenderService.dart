import 'dart:async';
import 'email.dart';
import 'emailSender.dart';
import 'package:http/browser_client.dart';
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


    try {
      var uriResponse = await new BrowserClient().post('https://us-east-1.console.aws.amazon.com/apigateway/home?region=us-east-1#/apis/mz8uki4o3l/resources/dh84j1o5ge/sendEmail',
          body: data);
      print(uriResponse);
    } finally {

    }
    
    return new EmailSender({}, '', email);
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
