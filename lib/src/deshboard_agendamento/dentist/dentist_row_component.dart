import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../agendamento/dentist/dentist.dart';
import '../../agendamento/dentist/dentist_service.dart';
import 'dentist_edit_component.dart';

@Component(
    selector: 'dentist_row_component',
    styleUrls: const [
      'dentist_row_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_row_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      DentistEditComponent,
      ModalComponent,
    ])

class DentistRowComponent {
  Dentist _dentist;
  DentistService dentistService;

  bool showEditAgendamentoEditApp = false;

  Dentist get dentist => _dentist;
  @Input()
  set dentist(Dentist dentist) => _dentist = dentist; 

  DentistRowComponent();

  void onEdit() {
    dentistService = new DentistService();
    dentistService.dentist = dentist;
    querySelector('#editDentist').click();
    querySelector('#dentist-edit-app').style.display = 'block';
  }
}
