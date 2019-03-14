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

import 'package:firebase/firebase.dart' as fb;
import '../firebase/firestore.dart';

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

  String nome = '';
  String email = '';
  String _telefone = '';
  String password = '';
  String consfirmacaoPassword = '';

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
    nome = '';
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
    showSuccessfullySave = false;
  }

  void onDismissAssertMessage() {
    showAssertMessageSave = false;
    showAssertMessageSavePassordNotMatched = false;
  }

  void onAssertsSave() {
    if ((nome == '') || (telefone == '') || (email == '') ||
        (password == '') ||
        (consfirmacaoPassword == '')) {

      showAssertMessageSave = true;
      return;
    }

    if (password != consfirmacaoPassword) {
      showAssertMessageSavePassordNotMatched = true;
      return;      
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;  
  }

  void onSave() async {   
    showAssertMessageAlert = false;

    datas = new Map<String, dynamic>();

    datas = {
      "name": nome,
      "email": email,
      "tel": telefone,
      "password": RSAKeyParser().parse(password),
      "userId": fb.auth().currentUser.uid
    };

    FireStoreApp _fireStoreApp = new FireStoreApp('patientsAccount');

    if (await _fireStoreApp.addItem(datas)) {
      showSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    } else {
      showNotSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    }
  }

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }
}
