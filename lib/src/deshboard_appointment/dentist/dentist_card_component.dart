import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../appointment/dentist/dentist.dart';
import '../../appointment/dentist/dentist_service.dart';
import 'dentist_edit_component.dart';

@Component(
    selector: 'dentist-card-app',
    styleUrls: const [
      'dentist_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],  
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dentist_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      DentistEditComponent,
      ModalComponent,
    ])

class DentistCardComponent {
  Dentist _dentist;
  DentistService dentistService;

  bool showEditAgendamentoEditApp = false;

  Dentist get dentist => _dentist;
  @Input()
  set dentist(Dentist dentist) => _dentist = dentist; 

  DentistCardComponent();

  void onEdit() {
    dentistService = new DentistService();
    dentistService.dentist = dentist;
    querySelector('#editDentist').click();
    querySelector('#dentist-edit-app').style.display = 'block';
  }
}
