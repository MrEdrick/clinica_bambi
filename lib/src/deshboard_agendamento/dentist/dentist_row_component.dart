import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';

import '../../agendamento/dentist/dentist.dart';
import '../../agendamento/dentist/dentist_service.dart';

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
      ModalComponent,
      MaterialButtonComponent,
    ])
class DentistRowComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  Dentist dentist;
  DentistService dentistService = new DentistService();

  @Input()
  String dentistId;

  @Input()
  ComponentRef componentRef;

  DentistRowComponent(this._changeDetectorRef);

  void ngOnInit() async {
    dentist = await dentistService.getDentistById(dentistId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    //dentistService = new DentistService();
    //dentistService.dentist = dentist;
  }
}
