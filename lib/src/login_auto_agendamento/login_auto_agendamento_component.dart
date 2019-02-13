import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_input/material_input.dart';

@Component(
  selector: 'login-auto-agendamento-app',
  templateUrl: 'login_auto_agendamento_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent],
  providers: const [materialProviders, windowBindings, datepickerBindings],
  styleUrls: const [
    'login_auto_agendamento_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class LoginAutoAgendamentoComponent {
  String email = '';
  String password = '';
    String error;

  void onGetInside() async {
    //error = await new AuthApp().registerUser(email, password);
    if (error == '') {
    } else {
    }
  }
}
