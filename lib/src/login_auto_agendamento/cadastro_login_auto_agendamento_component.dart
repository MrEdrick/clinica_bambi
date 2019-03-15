import 'dart:html';
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
import 'package:encrypt/encrypt.dart';
import 'dart:js' as js;

import '../agendamento/patient_account/patient_account_dao.dart';
import 'package:firebase/firebase.dart' as fb;

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
      windowBindings,
    ])
class CadastroLoginAutoAgendamentoComponent implements OnInit {
  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;
  bool showAssertMessageSavePassordNotMatched = false;
  bool showAssertMessageSaveEmailExists = false;

  String name = '';
  String email = '';
  String _telefone = '';
  String password = '';
  String consfirmacaoPassword = '';
  String confirmationCode = '';

  String buttonSaveDescription = 'VERIFICAR E-MAIL';

  int maxLength = 14;

  Map<String, dynamic> datas;

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
        (event.keyCode == KeyCode.LEFT)) {
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
    consfirmacaoPassword = '';

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
  }

  void onAssertsSave() async {
    if ((name == '') || (telefone == '') || (email == '') ||
        (password == '') ||
        (consfirmacaoPassword == '')) {

      showAssertMessageSave = true;
      return;
    }

    if (password != consfirmacaoPassword) {
      showAssertMessageSavePassordNotMatched = true;
      return;      
    }

    if (await new PatientAccountDAO().emailExists(email)) {
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
    print(RSAKeyParser().parse(password).toString());
    if (buttonSaveDescription == 'VERIFICAR E-MAIL') {
      js.context.callMethod('sendEmail', [email, 'Verificação de e-mail', 'Este é o código que você deve utilizar para a confirmação:' + RSAKeyParser().parse(password).toString()]);
      buttonSaveDescription = 'CONFIRMAR';
      return;
    }

    datas = new Map<String, dynamic>();

    datas = {
      "name": name,
      "email": email,
      "tel": telefone,
      "password": RSAKeyParser().parse(password),
      "userId": fb.auth().currentUser.uid
    };
        
    if (await new PatientAccountDAO().save(datas) == '') {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }
  }

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }
}
