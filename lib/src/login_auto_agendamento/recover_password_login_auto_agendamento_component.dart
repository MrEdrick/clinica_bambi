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
    providers: [
      windowBindings
    ])
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
    querySelector('#recover-password-login-auto-agendamento-app').style.display = 'none';
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
    if ((email == '') ||
        (password == '') ||
        (confirmationPassword == '')) {

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
      emailSenderHTTP = await new EmailSenderService(
        new Email(CLINIC_EMAIL, 
                  email, 'Verificação de e-mail', 
                  'Este é o código que você deve utilizar para a confirmação: ' + sha1.convert(utf8.encode(patientAccount.password)).toString(), 
                  null, null)
      ).emailSenderAmazon();

      response = await emailSenderHTTP.sendEmail();
      if (response.statusCode == 200) {
        buttonSaveDescription = BUTTON_SAVE_CONFIRM_DESCRIPTION;
        querySelector('#confirmation-code-recover-password').style.display = 'block';
      }
      return;
    } 

    if (confirmationCode == '') {
      showAssertMessageSaveConfirmationCodeEmpty = true;
      return;      
    }

    if (confirmationCode.trim() != sha1.convert(utf8.encode(patientAccount.password)).toString()) {
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
