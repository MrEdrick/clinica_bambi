import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';

import '../../appointment/dentist/dentist.dart';
import '../../appointment/dentist/dentist_dao.dart';
import '../../appointment/dentist/dentist_service.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_edit_component.template.dart'
    as dentist_edit;

@Component(
    selector: 'dentist_card_component',
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
      MaterialDialogComponent,
      ModalComponent,
      MaterialButtonComponent,
    ])
class DentistCardComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  Dentist dentist;
  DentistService dentistService = new DentistService();

  bool showEditAgendamentoEditApp = false;
  bool showDeteleCertification = false;

  @Input()
  String dentistId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditDentist', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  DentistCardComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    dentist = await dentistService.getDentistById(dentistId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    dentistService.dentist = dentist;
    ComponentFactory<dentist_edit.DentistEditComponent>
        dentistEdit = dentist_edit.DentistEditComponentNgFactory;

    ComponentRef dentistEditComponent = _loader.loadNextToLocation(dentistEdit, materialContainerEdit);
    dentistEditComponent.instance.componentRef = dentistEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void delete() {
    new DentistDAO().delete(dentistId);   
    showDeteleCertification = false;
    componentRef.destroy();
  }

  void noDelete() {
    showDeteleCertification = false;
  }
}
