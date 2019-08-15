import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:intl/intl.dart';

import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../appointment/configuration/auto_appointment_scheduling_configuration/auto_appointment_scheduling_configuration_service.dart';

import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_edit_component.template.dart'
    as auto_appointment_scheduling_edit;

@Component(
    selector: 'auto_appointment_scheduling_card_component',
    styleUrls: const [
      'auto_appointment_scheduling_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_appointment_scheduling_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialDialogComponent,
    ])
class AutoAppointmentSchedulingCardComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final AutoAppointmentSchedulingService autoAppointmentSchedulingService =
      new AutoAppointmentSchedulingService();
  AutoAppointmentScheduling autoAppointmentScheduling;
  final AutoAppointmentSchedulingConfigurationService
      autoAppointmentSchedulingConfigurationService =
      new AutoAppointmentSchedulingConfigurationService();

  bool showDeteleCertification = false;
  bool showNotSuccessfullyDelete = false;
  bool showCannotDeleteLimitHour = false;
  bool notPassedOn = true;

  @Input()
  String autoAppointmentSchedulingId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditAutoAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  AutoAppointmentSchedulingCardComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    Map map = autoAppointmentSchedulingService
        .getAutoAppointmentSchedulingByIdFromList(autoAppointmentSchedulingId);

    autoAppointmentScheduling = await autoAppointmentSchedulingService
        .turnMapInAutoAppointmentScheduling(map);

    notPassedOn = ((new Date.today()) <=
        (new Date.parse(autoAppointmentScheduling.dateAppointmentScheduling,
            new DateFormat("yyyy-MM-dd"))));
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    autoAppointmentSchedulingService.autoAppointmentScheduling =
        autoAppointmentScheduling;
    ComponentFactory<
            auto_appointment_scheduling_edit
                .AutoAppointmentSchedulingEditComponent>
        autoAppointmentSchedulingEdit = auto_appointment_scheduling_edit
            .AutoAppointmentSchedulingEditComponentNgFactory;

    ComponentRef autoAppointmentSchedulingEditComponent =
        _loader.loadNextToLocation(
            autoAppointmentSchedulingEdit, materialContainerEdit);
    autoAppointmentSchedulingEditComponent.instance.componentRef =
        autoAppointmentSchedulingEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void deleteAppointmentScheduling() async {
    showDeteleCertification = false;

    Date dateAppointmentScheduling = (new Date.parse(
        autoAppointmentScheduling.dateAppointmentScheduling,
        new DateFormat("yyyy-MM-dd")));

    if ((new DateTime.now()).isAfter(DateTime(
            dateAppointmentScheduling.year,
            dateAppointmentScheduling.month,
            dateAppointmentScheduling.day,
            autoAppointmentScheduling.shift.startTime)
        .add(new Duration(
            hours: (await autoAppointmentSchedulingConfigurationService
                    .getAllConfiguration())
                .hourLimitToClientRemoveAutoAppointmentScheduling)))) {
      showCannotDeleteLimitHour = true;
      return;
    }

    if (await autoAppointmentSchedulingService
        .delete(autoAppointmentSchedulingId)) {
      componentRef.destroy();
    } else {
      showNotSuccessfullyDelete = true;
    }
  }

  void noDeleteAppointmentScheduling() {
    showDeteleCertification = false;
  }

  void onDismissNotSuccessfullyDelete() {
    showNotSuccessfullyDelete = false;
  }

  void onDismissCannotDeleteLimitHour() {
    showCannotDeleteLimitHour = false;
  }
}
