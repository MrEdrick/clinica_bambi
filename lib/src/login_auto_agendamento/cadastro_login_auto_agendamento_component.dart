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

import '../appointment/patient_account/patient_account_dao.dart';
import 'package:firebase/firebase.dart' as fb;

import '../email/email.dart';
import '../email/email_constants.dart';
import '../email/emailSenderService.dart';
import '../email/emailSenderHTTP.dart';


@Component(
    selector: 'cadastro-login-auto-agendamento-app',
    styleUrls: const [
      'cadastro_login_auto_agendamento_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'cadastro_login_auto_agendamento_component.html',
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
class CadastroLoginAutoAgendamentoComponent {
  static final BUTTON_SAVE_VERIFY_DESCRIPTION = 'VERIFICAR E-MAIL';
  static final BUTTON_SAVE_CONFIRM_DESCRIPTION = 'CONFIRMAR';

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;
  bool showAssertMessageSavePassordNotMatched = false;
  bool showAssertMessageSaveEmailExists = false;
  bool showAssertMessageSaveConfirmationCodeEmpty = false;
  bool showAssertMessageSaveConfirmationCodeNotMatched = false;

  String name = '';
  String email = '';
  String _telefone = '';
  String password = '';
  String confirmationPassword = '';
  String confirmationCode = '';

  String buttonSaveDescription = BUTTON_SAVE_VERIFY_DESCRIPTION;

  int maxLength = 14;

  Map<String, dynamic> datas;

  Response response;
  EmailSenderHTTP emailSenderHTTP;

  set telefone(String value) {
    _telefone = '';

    if (value.length == 0) {
      return;
    }

    String valueLocal = '';

    for (var i = 0; i < value.length; i++) {
      if (int.tryParse(value.substring(i, i + 1)) != null) {
        valueLocal = valueLocal + value.substring(i, i + 1);
      }
    }

    if (valueLocal.length >= 14) {
      _telefone = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6, 13);
      return;
    }

    if (valueLocal.length >= 7) {
      _telefone = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6);
      return;
    }

    if (valueLocal.length > 2) {
      _telefone =
          '(' + valueLocal.substring(0, 2) + ')' + valueLocal.substring(2);
      return;
    }

    if (valueLocal.length > 0) {
      _telefone = '(' + _telefone + valueLocal.substring(0);
    }
  }

  onKeydownTelephone(event) {
    if ((event.keyCode == KeyCode.BACKSPACE) ||
        (event.keyCode == KeyCode.RIGHT) ||
        (event.keyCode == KeyCode.LEFT) ||
        (event.keyCode == KeyCode.TAB)) {
      return;
    }

    if ((int.tryParse(event.key) == null) || (telefone.length > 13)) {
      event.preventDefault();
    }
  }

  String get telefone => _telefone;

  void onClose() {
    name = '';
    email = '';
    _telefone = '';
    password = '';
    confirmationPassword = '';
    confirmationCode = '';
    buttonSaveDescription = BUTTON_SAVE_VERIFY_DESCRIPTION;

    querySelector('#confirmation-code').style.display = 'none';
    querySelector('#cadastro-login-auto-agendamento-app').style.display = 'none';
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
    showAssertMessageSaveEmailExists = false;
    showAssertMessageSaveConfirmationCodeEmpty = false;
    showAssertMessageSaveConfirmationCodeNotMatched = false;
  }

  void onAssertsSave() async {
    if ((name == '') || (telefone == '') || (email == '') ||
        (password == '') ||
        (confirmationPassword == '')) {

      showAssertMessageSave = true;
      return;
    }

    if (password != confirmationPassword) {
      showAssertMessageSavePassordNotMatched = true;
      return;      
    }

    if ((await new PatientAccountDAO().emailExists(email)) != null) {
      showAssertMessageSaveEmailExists = true;
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
                  'Este é o código que você deve utilizar para a confirmação: ' + sha1.convert(utf8.encode(email)).toString(), 
                  null, null)
      ).emailSenderAmazon();

      response = await emailSenderHTTP.sendEmail();
      if (response.statusCode == 200) {
        buttonSaveDescription = BUTTON_SAVE_CONFIRM_DESCRIPTION;
        querySelector('#confirmation-code').style.display = 'block';
      }
      return;
    } 

    if (confirmationCode == '') {
      showAssertMessageSaveConfirmationCodeEmpty = true;
      return;      
    }

    if (confirmationCode.trim() != sha1.convert(utf8.encode(email)).toString()) {
      showAssertMessageSaveConfirmationCodeNotMatched = true;
      return;      
    }

    datas = new Map<String, dynamic>();

    datas = {
      "name": name,
      "email": email,
      "tel": telefone,
      "password": sha1.convert(utf8.encode(password)).toString(),
      "userId": fb.auth().currentUser.uid
    };
        
    if ((await new PatientAccountDAO().save(datas)).keys.first) {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }
  }

}
