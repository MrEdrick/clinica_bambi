import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import '../firebase/firestore.dart';
import '../firebase/auth.dart';
import '../route_paths.dart' as paths;
import 'cadastro_login_auto_agendamento_component.dart';
import '../agendamento/patient_account/patient_account.dart';
import 'package:encrypt/encrypt.dart';

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
    CadastroLoginAutoAgendamentoComponent
    ],
  styleUrls: const [
    'login_auto_agendamento_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class LoginAutoAgendamentoComponent extends Object implements OnActivate  {
  final emailAdm = 'clinicaodontologicabambi@gmail.com';
  final passwordAdm = 'clinicaodontologicabambiadm2019_';

  String email = '';
  String password = '';
  String error;
  bool showNotSuccessfullyLogin = false;
  bool showLoginNotFinded = false;

  AuthApp authApp;

  PatientAccount patientAccount;

  final Router _router;

  @override
  Future<void> onActivate(_, RouterState current) async {

  }
  
  LoginAutoAgendamentoComponent(
    this._router
  );

  void onGetInside() async {
    error = await new AuthApp().login(emailAdm, passwordAdm);
    if (error == '') {
      patientAccount = loginPatientAccount();
      if (patientAccount == null) {
        showLoginNotFinded = true;
      } else {
        goAutoAgendamento();
      }
    } else {
      showNotSuccessfullyLogin = true;
    }
  }

  PatientAccount loginPatientAccount() {
    FireStoreApp fireStoreApp = new FireStoreApp('patientAccount');

    fireStoreApp.ref
      .where('email', '==', email)
      .where('password', '==', RSAKeyParser().parse(password))
      .get()
      .then((querySnapshot) {
        if (querySnapshot.size == 0) {
          return null;
        } else {
          return new PatientAccount(querySnapshot.docs[0].data()["id"].toString(), 
                                    querySnapshot.docs[0].data()["email"].toString(), 
                                    querySnapshot.docs[0].data()["name"].toString(),
                                    querySnapshot.docs[0].data()["password"].toString());
        }    
      });
  } 

  void onSingUp() {
    querySelector('#cadastro-login-auto-agendamento-app').style.display = 'block';
  }

  Future<NavigationResult>  goAutoAgendamento() => _router.navigate(
    paths.deshboard_auto_agendamento.toUrl()
  );
  
  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
  }

  void onDismissLoginNotFinded() {
    showLoginNotFinded = false;
  }
  
}
