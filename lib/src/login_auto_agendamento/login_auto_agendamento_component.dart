import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:crypto/crypto.dart';

import '../route_paths.dart' as paths;

import 'cadastro_login_auto_agendamento_component.dart';
import 'recover_password_login_auto_agendamento_component.dart';
import '../appointment/patient_account/patient_account.dart';
import '../appointment/patient_account/patient_account_dao.dart';
import '../appointment/patient_account/patient_account_service.dart';

@Component(
  selector: 'login-auto-agendamento-app',
  templateUrl: 'login_auto_agendamento_component.html',
  directives: const [
    coreDirectives, 
    RouterOutlet,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
    AutoDismissDirective,
    CadastroLoginAutoAgendamentoComponent,
    RecoverPasswordLoginAutoAgendamentoComponent
    ],
  styleUrls: const [
    'login_auto_agendamento_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class LoginAutoAgendamentoComponent extends Object implements OnActivate  {
  String email = '';
  String password = '';
  bool showNotSuccessfullyLogin = false;
  bool showLoginNotFinded = false;

  PatientAccount patientAccount;

  final PatientAccountService patientAccountService = new PatientAccountService();
  final Router _router;

  @override
  Future<void> onActivate(_, RouterState current) async {

  }
  
  LoginAutoAgendamentoComponent(
    this._router
  );

  void onGetInside() async {
    PatientAccountDAO patientAccountDAO = new PatientAccountDAO();
    PatientAccount patientAccount = await patientAccountDAO.getPatiantAccount(email.trim(), 
                                        sha1.convert(utf8.encode(password)).toString().trim());
    if (patientAccount == null) {
      patientAccountService.patientAccount = null;
      showLoginNotFinded = true;
    } else {
      patientAccountService.patientAccount = patientAccount;
      goAutoAppointment();
    }  
  }

  void onSingUp() {
    querySelector('#cadastro-login-auto-agendamento-app').style.display = 'block';
  }

  void onForgotePassword() {
    querySelector('#recover-password-login-auto-agendamento-app').style.display = 'block';
  }

  Future<NavigationResult>  goAutoAppointment() => _router.navigate(
    paths.deshboard_auto_appointment.toUrl()
  );
  
  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
  }

  void onDismissLoginNotFinded() {
    showLoginNotFinded = false;
  }
  
}
