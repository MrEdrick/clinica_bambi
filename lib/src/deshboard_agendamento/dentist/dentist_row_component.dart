import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

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
  DentistService dentistService = new DentistService();

  bool showEditAgendamentoEditApp = false;

  @Input()
  String dentistId;

  @Input()
  ComponentRef componentRef;

  DentistRowComponent();

  void onEdit() {
    //dentistService = new DentistService();
    //dentistService.dentist = dentist;
  }
}
