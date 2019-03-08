import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import '../route_paths.dart' as paths;

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
    AutoDismissDirective
    ],
  styleUrls: const [
    'login_auto_agendamento_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class LoginAutoAgendamentoComponent extends Object implements OnActivate  {
  String email = '';
  String password = '';
  String error;
  bool showNotSuccessfullyLogin = false;

  final Router _router;

  @override
  Future<void> onActivate(_, RouterState current) async {

  }
  
  LoginAutoAgendamentoComponent(
    this._router
  );

  void onGetInside() async {
    //error = await new AuthApp().registerUser(email, password);
    error = '';
    if (error == '') {
      goAutoAgendamento();
    } else {
      showNotSuccessfullyLogin = true;
    }
  }

  Future<NavigationResult>  goAutoAgendamento() => _router.navigate(
    paths.auto_agendamento_edit.toUrl()
  );
  
  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
  }
}
