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
class LoginAutoAgendamentoComponent {
  String email = '';
  String password = '';
  String error;
  bool showNotSuccessfullyLogin = false;

  void onGetInside() async {
    //error = await new AuthApp().registerUser(email, password);
    error = '';
    if (error == '') {
      goDeshboardAgendamento();
    } else {
      showNotSuccessfullyLogin = true;
    }
  }

  Future<NavigationResult>  goDeshboardAgendamento() => _router.navigate(
    paths.deshboard_agendamento.toUrl()
  );
  
  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
  }
}
