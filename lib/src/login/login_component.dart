import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import '../route_paths.dart' as paths;
import '../firebase/auth.dart';

@Component(
    selector: 'app-login',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const ['login_component.scss.css'],
    templateUrl: 'login_component.html',
    directives: const [
      coreDirectives,
      RouterOutlet,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialButtonComponent,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ])
class LoginComponent extends Object implements OnActivate {
  final ChangeDetectorRef _changeDetectorRef;

  String email = "";
  String password = "";
  String error = "";

  bool showNotSuccessfullyLogin = false;

  AuthApp authApp;

  final Router _router;

  LoginComponent(this._router, this._changeDetectorRef);

  @override
  Future<void> onActivate(_, RouterState current) async {}

  void onGetInside() async {
    error = await new AuthApp().login(email, password);
    if (error == '') {
      goDeshboardAppointment();
    } else {
      showNotSuccessfullyLogin = true;
    }
    _changeDetectorRef.markForCheck();
  }

  Future<NavigationResult> goDeshboardAppointment() =>
      _router.navigate(paths.deshboard_appointment.toUrl());

  void onDismissNotSuccessfullyLogin() {
    showNotSuccessfullyLogin = false;
    _changeDetectorRef.markForCheck();
  }

  void onToggleShowHideElementValue(Element inputElement, Element iconElement) {
    inputElement.setAttribute("type",
        inputElement.getAttribute("type") == "password" ? "text" : "password");

    iconElement.text =
        iconElement.text == "visibility_off" ? "visibility" : "visibility_off";
  }

  void onShowHidePassword() {
    onToggleShowHideElementValue(
        querySelector("#password").querySelector("input"),
        querySelector("#password-icon").querySelector("i"));

    _changeDetectorRef.markForCheck();
  }
}
