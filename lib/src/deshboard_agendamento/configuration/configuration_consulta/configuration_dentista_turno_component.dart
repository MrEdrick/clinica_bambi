import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:firebase/firebase.dart' as fb;
import '../../dentist/dentist.dart';
import '../../../firebase/firestore.dart';
import 'dentista_turno_quantidade_component.dart';

@Component(
    selector: 'configuration-dentista-turno-app',
    styleUrls: const [
      'configuration_dentista_turno_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'configuration_dentista_turno_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      DentistaTurnoQuantidadeComponent,
    ],
    providers: [
      windowBindings,
      datepickerBindings
    ])
class ConfigurationDentistaTurnoEditComponent implements OnInit {
  final List<Dentist> listDentists = new List<Dentist>();

  Map<String, dynamic> datas;

  void ngOnInit() {
  }

  void onClose() {
    querySelector('#configuration-dentista-turno-app').style.display = 'none';
  }

  bool asserts() {
    return true;
  }

  void onAssertsSave() {
    onSave();
  }

  void onSave() async {   
    datas = new Map<String, dynamic>();

    datas = {
      "userId": fb.auth().currentUser.uid
    };

    FireStoreApp _fireStoreApp = new FireStoreApp('limitShiftDentist');

    if (await _fireStoreApp.updateItem('consultaService.consulta?.id', datas)) {
      _fireStoreApp.FireStoreOffLine();
    } else {
      _fireStoreApp.FireStoreOffLine();
    }
  }
}
