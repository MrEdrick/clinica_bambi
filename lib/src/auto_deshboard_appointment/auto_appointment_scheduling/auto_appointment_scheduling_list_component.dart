import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../appointment/patient_account/patient_account_service.dart';
import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_card_component.template.dart'
    as auto_appointment_scheduling_card;

@Component(
    selector: 'auto_appointment_scheduling_list_component',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'auto_appointment_scheduling_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_appointment_scheduling_list_component.html',
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
    ])
class AutoAppointmentSchedulingListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final PatientAccountService patientAccountService = new PatientAccountService();

  @ViewChild('containerCardAutoAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  AutoAppointmentSchedulingListComponent(this._loader, this._changeDetectorRef);

  @Input()
  ComponentRef componentRef;

  @Input()
  Date date;

  String dateFormated;

  int totalResultByDay;

  void ngOnInit() {
    if ((new UserService().user == null) ||
        (patientAccountService.patientAccount == null)) return;

    dateFormated =
        new DateFormat("EEEE, dd 'de' MMMM 'de' yyyy").format(date.asUtcTime());

    List<Map> _list = new AutoAppointmentSchedulingService()
        .getAutoAppointmentSchedulingFromListWithFilterByPatientAccountIdDate(
            patientAccountService.patientAccount.id, date);

    _list.forEach((autoAppointmentScheduling) {
      ComponentFactory<
              auto_appointment_scheduling_card
                  .AutoAppointmentSchedulingCardComponent>
          autoAppointmentSchedulingCard = auto_appointment_scheduling_card
              .AutoAppointmentSchedulingCardComponentNgFactory;

      ComponentRef autoAppointmentSchedulingCardComponent =
          _loader.loadNextToLocation(
              autoAppointmentSchedulingCard, materialContainerCard);

      autoAppointmentSchedulingCardComponent
              .instance.autoAppointmentSchedulingId =
          autoAppointmentScheduling["documentPath"];
      autoAppointmentSchedulingCardComponent.instance.componentRef =
          autoAppointmentSchedulingCardComponent;
    });

    _changeDetectorRef.markForCheck();
  }
}
