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
  String passwordType = "password";

  bool showNotSuccessfullyLogin = false;
  bool showPassword = false;

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

  void onToggleShowElementValue(Element element, String attribute,
      String firstValue, String secondValue) {
    element.setAttribute(
        attribute,
        element.getAttribute(attribute) == firstValue
            ? secondValue
            : firstValue);
  }

  void onShowHidePassword() {
    onToggleShowElementValue(querySelector("#password").querySelector("input"),
        "type", "password", "text");

    querySelector("#password-icon").querySelector("i").text =
        querySelector("#password-icon").querySelector("i").text ==
                "visibility_off"
            ? "visibility"
            : "visibility_off";
            
    _changeDetectorRef.markForCheck();
  }
}
