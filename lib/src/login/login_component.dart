import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import '../route_paths.dart' as paths;
import '../firebase/auth.dart';

@Component(
  selector: 'app-login',
  styleUrls: const ['login_component.scss.css'],
  templateUrl: 'login_component.html',
  directives: const [
    coreDirectives, 
    RouterOutlet,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialDialogComponent,
    ModalComponent,
    AutoDismissDirective,
  ]
)

class LoginComponent extends Object implements OnActivate {
  String email = '';
  String password = '';
  String error= '';

  bool showNotSuccessfullyLogin = false;


  AuthApp authApp;

  final Router _router;

  LoginComponent(
    this._router
  );

  @override
  Future<void> onActivate(_, RouterState current) async {

  }
  
  void onGetInside() async {
    error = await new AuthApp().login(email, password);
    if (error == '') {
      goDeshboardAppointment();
    } else {
      showNotSuccessfullyLogin = true;
    }
  }

  Future<NavigationResult>  goDeshboardAppointment() => _router.navigate(
    paths.deshboard_appointment.toUrl()
  );
  
  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
  }

}
