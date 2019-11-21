import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_router/angular_router.dart';
import 'package:crypto/crypto.dart';

import '../appointment/patient_account/patient_account.dart';
import '../appointment/patient_account/patient_account_dao.dart';
import 'package:firebase/firebase.dart' as fb;

import '../email/email.dart';
import '../email/email_constants.dart';
import '../email/emailSenderService.dart';
import '../email/emailSenderHTTP.dart';

@Component(
    selector: 'recover-password-login-auto-agendamento-app',
    styleUrls: const [
      'recover_password_login_auto_agendamento_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'recover_password_login_auto_agendamento_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      RouterOutlet,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDatepickerComponent,
      DateRangeInputComponent,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [windowBindings])
class RecoverPasswordLoginAutoAgendamentoComponent {
  static final BUTTON_SAVE_VERIFY_DESCRIPTION = 'VERIFICAR E-MAIL';
  static final BUTTON_SAVE_CONFIRM_DESCRIPTION = 'CONFIRMAR';

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;
  bool showAssertMessageSavePassordNotMatched = false;
  bool showAssertMessageSaveEmailNotExists = false;
  bool showAssertMessageSaveConfirmationCodeEmpty = false;
  bool showAssertMessageSaveConfirmationCodeNotMatched = false;

  String email = '';
  String password = '';
  String confirmationPassword = '';
  String confirmationCode = '';

  String buttonSaveDescription = BUTTON_SAVE_VERIFY_DESCRIPTION;

  int maxLength = 14;

  Map<String, dynamic> datas;

  Response response;
  EmailSenderHTTP emailSenderHTTP;
  PatientAccount patientAccount;

  void onClose() {
    email = '';
    password = '';
    confirmationPassword = '';
    confirmationCode = '';
    buttonSaveDescription = BUTTON_SAVE_VERIFY_DESCRIPTION;

    querySelector('#confirmation-code-recover-password').style.display = 'none';
    querySelector('#recover-password-login-auto-agendamento-app')
        .style
        .display = 'none';
  }

  bool asserts() {
    return true;
  }

  void onDismissSuccessfullySave() {
    showSuccessfullySave = false;
    onClose();
  }

  void onDismissNotSuccessfullySave() {
    showNotSuccessfullySave = false;
  }

  void onDismissAssertMessage() {
    showAssertMessageSave = false;
    showAssertMessageSavePassordNotMatched = false;
    showAssertMessageSaveEmailNotExists = false;
    showAssertMessageSaveConfirmationCodeEmpty = false;
    showAssertMessageSaveConfirmationCodeNotMatched = false;
  }

  void onAssertsSave() async {
    if ((email == '') || (password == '') || (confirmationPassword == '')) {
      showAssertMessageSave = true;
      return;
    }

    if (password != confirmationPassword) {
      showAssertMessageSavePassordNotMatched = true;
      return;
    }

    patientAccount = await new PatientAccountDAO().emailExists(email);

    if (patientAccount == null) {
      showAssertMessageSaveEmailNotExists = true;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
  }

  void onSave() async {
    showAssertMessageAlert = false;
    if (buttonSaveDescription == BUTTON_SAVE_VERIFY_DESCRIPTION) {
      emailSenderHTTP = await new EmailSenderService(new Email(
              CLINIC_EMAIL,
              email,
              'Verificação de e-mail',
              ''' <div 
                    style=" font-family:Arial, Helvetica, sans-serif; 
                    font-size: 22px; 
                    font-weight: 600;
                    color:#666666;">
                    Ol&aacute;, tudo bem?
                  </div>
                  <div 
                    style=" font-family:Arial, Helvetica, sans-serif; 
                    font-size: 16px; 
                    font-weight: 600;
                    color:#888888;">
                    <p>Este é o código que você deve utilizar para a confirmação: </p>
                    <p style="color:#DB3813;"> ''' + sha1.convert(utf8.encode(patientAccount.password)).toString()  + ''' </p>
                  </div> 
                  <link href="https://fonts.googleapis.com/css?family=Quicksand&display=swap" rel="stylesheet">
                  <style>
                      body {
                          display: flex;
                          margin: 0;
                          align-items: center;
                          justify-content: center;
                          height: 100vh;
                          background-color: #4c96b8;
                      }
                  
                      .presentational-container {
                          background-color: #fff;
                      }
                  
                      table {
                          background: none;
                          margin: 0;
                          padding: 10px 10px 0;
                          border-width: 3px 0 0 0;
                          border-style: solid;
                          border-color: #4c96b8;
                      }
                  
                      tr.outer-row td.headshot-cell {
                          padding: 0 12px 0 0;
                      }
                  
                      td.headshot-cell a {
                          text-decoration: none;
                      }
                  
                      td.headshot-cell img {
                          vertical-align: middle;
                          width: 250px;
                      }
                  
                      td.description-cell {
                          padding: 0 0 0 12px;
                      }
                  
                      td.description-cell>table {
                          background: none;
                          border: 0px;
                          margin: 0;
                          padding: 0;
                      }
                  
                      td.full-name {
                          font-weight: bold;
                          color: #4c96b8;
                          font-size: 22px;
                          font-family: 'Quicksand', sans-serif;
                          font-weight: 600;
                      }
                  
                      td.title {
                          padding-bottom: 10px;
                          color: #555555;
                          font-size: 14px;
                          font-family: 'Quicksand', sans-serif;
                          font-weight: 600;
                      }
                  
                      a.website {
                          color: #4c96b8;
                          text-decoration: none;
                          font-weight: 600;
                          font-size: 14px;
                      }
                  
                      td.social-icons {
                          padding-top: 5px;
                      }
                  
                      td.social-icons ul {
                          list-style: none;
                          padding: 0;
                          margin: 0;
                          height: 25px;
                      }
                  
                      td.social-icons li {
                          display: inline-block;
                      }
                  
                      td.social-icons a {
                          text-decoration: none;
                      }
                  
                      td.social-icons img {
                          width: 30px;
                          height: 25px;
                      }
                  </style>
                  <div class="presentational-container">
                      <table role="presentation">
                          <tbody>
                              <tr class="outer-row">
                                  <td class="headshot-cell">
                                      <a href="https://clinicabambi.com.br">
                                          <img src="https://firebasestorage.googleapis.com/v0/b/bambi-210400.appspot.com/o/logo_w250.png?alt=media&token=9e1801f0-69e3-4e1d-b310-62c248402f7d"
                                              name="preview-image-url" alt="" />
                                      </a>
                                  </td>
                                  <td class="description-cell">
                                      <table role="presentation">
                                          <tbody>
                                              <tr>
                                                  <td colspan="2" class="full-name">Cl&iacute;nica Odontol&oacute;gica Bambi</td>
                                              </tr>
                                              <tr>
                                                  <td colspan="2" class="title">
                                                      (21) 3350-1883 / (21) 3251-4180 / (21) 98037-4396<br>
                                                      clinicaodontologicabambi@gmail.com</td>
                                              </tr>
                                              <tr>
                                                  <td colspan="2" class="title">Condom&iacute;nio do Edif&iacute;cio P&oacute;lo I <br> Estr. do Portela, 99 -
                                                      706/715 - Madureira <br> Rio de Janeiro - RJ, 21351-050</td>
                                              </tr>
                                              <tr>
                                                  <td class="title">
                                                      Agende sua consulta on-line:
                                                      <a class="website" href="https://clinicabambi.com.br">www.clinicabambi.com.br</a>
                                                  </td>
                                              </tr>
                                          </tbody>
                                      </table>
                                  </td>
                              </tr>
                          </tbody>
                      </table>
                  </div>
                  ''',
              null,
              null))
          .emailSenderAmazon();

      response = await emailSenderHTTP.sendEmail();
      if (response.statusCode == 200) {
        buttonSaveDescription = BUTTON_SAVE_CONFIRM_DESCRIPTION;
        querySelector('#confirmation-code-recover-password').style.display =
            'block';
      }
      return;
    }

    if (confirmationCode == '') {
      showAssertMessageSaveConfirmationCodeEmpty = true;
      return;
    }

    if (confirmationCode.trim() !=
        sha1.convert(utf8.encode(patientAccount.password)).toString()) {
      showAssertMessageSaveConfirmationCodeNotMatched = true;
      return;
    }

    datas = new Map<String, dynamic>();

    datas = {
      "email": email,
      "password": sha1.convert(utf8.encode(password)).toString(),
      "userId": fb.auth().currentUser.uid
    };

    if (await new PatientAccountDAO().update(patientAccount.id, datas) == '') {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }
  }
}
