import 'dart:html';
import 'package:http/http.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';

import '../email/email.dart';
import '../email/email_constants.dart';
import '../email/emailSenderService.dart';
import '../email/emailSenderHTTP.dart';

@Component(
  selector: 'email-fale-conosco-app',
  templateUrl: 'email_fale_conosco_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    AutoFocusDirective,
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    materialInputDirectives,
    MaterialDialogComponent,
    ModalComponent,
    AutoDismissDirective,
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'email_fale_conosco_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)

class EmailFaleConoscoComponent {
  bool showAssertMessageEmailNotSended = false;
  bool showAssertMessageEmailSended = false;
  bool multiline = true;

  String email = '';
  String subject = '';
  String mensage = '';

  Response response;  
  EmailSenderHTTP emailSenderHTTP;

  void clickClose() {
    onDismissAssertMessage();
    querySelector('email-fale-conosco-app').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'block';

  }

  void onDismissAssertMessage() {
    showAssertMessageEmailNotSended = false;
    showAssertMessageEmailSended = false;
  }

  void clickSend() async {
    emailSenderHTTP = await new EmailSenderService(
      new Email(CLINIC_EMAIL, 
                CLINIC_EMAIL, subject, mensage, 
                null, null)
    ).emailSenderAmazon();

    response = await emailSenderHTTP.sendEmail();
    if (response.statusCode == 200) {
      emailSenderHTTP = await new EmailSenderService(
        new Email(CLINIC_EMAIL, 
                  email, subject, 
                  ' Olá, recebemos seu e-mail. Esta é apenas uma mensagem automática, por favor não responda.' + '\r\n' + mensage, 
                  null, null)
      ).emailSenderAmazon();

      response = await emailSenderHTTP.sendEmail();
    }

    if (response.statusCode != 200) {
      showAssertMessageEmailNotSended = true;
    } else {
      showAssertMessageEmailSended = true;
    }
  }
}
