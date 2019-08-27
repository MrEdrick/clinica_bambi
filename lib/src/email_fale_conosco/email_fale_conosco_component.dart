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
  final ChangeDetectorRef _changeDetectorRef;

  bool showAssertMessageEmailNotSended = false;
  bool showAssertMessageEmailSended = false;
  bool showAssertCannotSend = false;
  bool multiline = true;
  bool disabled = false;

  String email = '';
  String name = '';
  String subject = '';
  String message = '';
  String sendButtonMessage = "Enviar";

  Response response;  
  EmailSenderHTTP emailSenderHTTP;

  EmailFaleConoscoComponent(this._changeDetectorRef);


  void clickClose() {
    onDismissAssertMessage();
    querySelector('email-fale-conosco-app').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'block';

  }

  void onDismissAssertMessage() {
    showAssertMessageEmailNotSended = false;
    showAssertMessageEmailSended = false;
    showAssertCannotSend = false;
  }

  bool asserts() {
    if ((name.isEmpty) || (email.isEmpty) || (subject.isEmpty) ||
        (message.isEmpty)) {
      return false;
    }

    return true;
  }

  void clearFields() {
    email = "";
    name = "";
    subject = "";
    message = "";
  }

  void clickSend() async {
    if (disabled) {
      return;
    }

    if (!asserts()) {
      showAssertCannotSend = true;
      return;
    }

    disabled = true;
    sendButtonMessage = "Enviando...";
    _changeDetectorRef.markForCheck();

    emailSenderHTTP = await new EmailSenderService(
      new Email(CLINIC_EMAIL, 
                CLINIC_EMAIL, subject + ' - De Nome: ' + name + ' Email: ' + email, message, 
                null, null)
    ).emailSenderGmail();//.emailSenderAmazon();

    response = await emailSenderHTTP.sendEmail();
    if (response.statusCode == 200) {
      emailSenderHTTP = await new EmailSenderService(
        new Email(CLINIC_EMAIL, 
                  email, subject, 
                  ' Olá, recebemos seu e-mail. Esta é apenas uma mensagem automática, por favor não responda.' + '\r\n' + message, 
                  null, null)
      ).emailSenderGmail();//emailSenderAmazon();

      response = await emailSenderHTTP.sendEmail();
    }

    if (response.statusCode != 200) {
      showAssertMessageEmailNotSended = true;
    } else {
      clearFields();
      showAssertMessageEmailSended = true;
    }

    disabled = false;
    sendButtonMessage = "Enviar";
    _changeDetectorRef.markForCheck();
  }
}
