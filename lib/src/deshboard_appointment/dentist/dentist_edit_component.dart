import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../appointment/dentist/dentist.dart';
import '../../appointment/dentist/dentist_service.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/shift/shift.dart';
import '../../appointment/procedure/procedure.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/agreement/agreement.dart';
import '../../appointment/agreement/agreement_service.dart';

import '../../appointment/dentist_procedure/dentist_procedure_service.dart';
import '../../appointment/dentist_agreement/dentist_agreement_service.dart';
import '../../appointment/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';
import '../../appointment/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift_service.dart';
import '../../appointment/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/interval/interval_service.dart';
import '../../appointment/attendance_interval/attendance_interval_service.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/dentist_procedure/dentist_procedure_group_checkbox_component.template.dart'
    as dentist_procedure_group_checkbox_component;
import 'package:ClinicaBambi/src/deshboard_appointment/dentist_agreement/dentist_agreement_checkbox_component.template.dart'
    as dentist_agreement_checkbox_component;
import 'package:ClinicaBambi/src/deshboard_appointment/attendance_interval/attendance_interval_edit_component.template.dart'
    as attendance_interval_edit_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift_by_day_group/shift_by_day_group_component.template.dart'
    as shift_by_day_group_component;

@Component(
    selector: 'dentist_edit_component',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'dentist_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      MaterialCheckboxComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [windowBindings])
class DentistEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefProcedure = new List<ComponentRef>();
  final List<ComponentRef> listComponentRefAgreement = new List<ComponentRef>();
  final List<ComponentRef> listComponentRefAttendanceInterval =
      new List<ComponentRef>();
  final List<ComponentRef> listComponentRefQuantityPerShiftByDayOfWeek =
      new List<ComponentRef>();

  final DentistAgreementService dentistAgreementService =
      new DentistAgreementService();

  final DentistProcedureService dentistProcedureService =
      new DentistProcedureService();
  final DentistProcedureByDayOfWeekService dentistProcedureByDayOfWeekService =
      new DentistProcedureByDayOfWeekService();
  final DentistProcedureByDayOfWeekByShiftService
      dentistProcedureByDayOfWeekByShiftService =
      new DentistProcedureByDayOfWeekByShiftService();
  final DentistQuantityPerShiftByDayOfWeekService
      dentistQuantityPerShiftByDayOfWeekService =
      new DentistQuantityPerShiftByDayOfWeekService();
  final ShiftService shiftService = new ShiftService();
  final AttendanceIntervalService attendanceIntervalService =
      new AttendanceIntervalService();
  final IntervalService intervalService = new IntervalService();

  @Input()
  ComponentRef componentRef;

  final DentistService dentistService = new DentistService();

  ComponentRef procedureCheckboxGroupComponent;

  ComponentRef agreementCheckboxComponent;

  @ViewChild('dentistProcedureGroupCheckboxComponent', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistProcedureGroup;

 @ViewChild('dentistAgreementCheckboxComponent', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistAgreement;

  @ViewChild('attendanceIntervalEditComponent', read: ViewContainerRef)
  ViewContainerRef materialContainerAttendanceInterval;

  @ViewChild('quantityPerShiftByDayGroupCheckboxComponent',
      read: ViewContainerRef)
  ViewContainerRef materialContainerDayGroupCheckbox;

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;
  bool disabled = false;

  Map<String, dynamic> datas;

  DentistEditComponent(this._changeDetectorRef, this._loader);

  void onEdit() {}

  void onClearListsOfComponentRef() {
    listComponentRefProcedure.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRefProcedure.clear();

    listComponentRefAgreement.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRefAgreement.clear();

    listComponentRefAttendanceInterval.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRefAttendanceInterval.clear();

    listComponentRefQuantityPerShiftByDayOfWeek.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRefQuantityPerShiftByDayOfWeek.clear();
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;

    querySelector('deshboard_appointment_component').style.overflowY = "hidden";

    onEdit();

    onClearListsOfComponentRef();

    dentistProcedureService.clearAllDentistProcedureList();
    dentistProcedureByDayOfWeekService
        .clearAllDentistProcedureByDayOfWeekList();
    dentistProcedureByDayOfWeekByShiftService
        .clearAllDentistProcedureByDayOfWeekByShiftList();
    dentistQuantityPerShiftByDayOfWeekService
        .clearAllDentistQuantityPerShiftByDayOfWeekList();
    shiftService.clearAllShiftList();
    intervalService.clearAllIntervalList();
    attendanceIntervalService.clearAllAttendanceIntervalList();

    await dentistProcedureService.getAllDentistProcedureAcives();
    await dentistProcedureByDayOfWeekService
        .getAllDentistProcedureByDayOfWeekAcives();
    await dentistProcedureByDayOfWeekByShiftService
        .getAllDentistProcedureByDayOfWeekByShiftAcives();
    await dentistQuantityPerShiftByDayOfWeekService
        .getAllDentistQuantityPerShiftByDayOfWeekAcives();
    await shiftService.getAllShiftAcives();
    await intervalService.getAllIntervalAcives();
    await attendanceIntervalService.getAllAttendanceIntervalAcives();
    await dentistAgreementService.getAllDentistAgreementAcives();

    List<Procedure> _listProcedure =
        await new ProcedureService().getAllProcedureAcives();

    List<Shift> _listShift = await new ShiftService().getAllShiftAcives();

    List<Agreement> _listAgreement =
        await new AgreementService().getAllAgreementAcives();

    _listProcedure.forEach((procedure) {
      ComponentFactory<
              dentist_procedure_group_checkbox_component
                  .DentistProcedureGroupCheckboxComponent> dentistProcedureGroupComponent =
          dentist_procedure_group_checkbox_component
              .DentistProcedureGroupCheckboxComponentNgFactory;

      procedureCheckboxGroupComponent = _loader.loadNextToLocation(
          dentistProcedureGroupComponent, materialContainerDentistProcedureGroup);

      procedureCheckboxGroupComponent.instance.dentistId =
          dentistService.dentist.id;
      procedureCheckboxGroupComponent.instance.procedureId = procedure.id;
      procedureCheckboxGroupComponent.instance.procedure =
          procedure.description;

      listComponentRefProcedure.add(procedureCheckboxGroupComponent);
    });

    _listAgreement.forEach((agreement) {
      ComponentFactory<
              dentist_agreement_checkbox_component
                  .DentistAgreementCheckboxComponent> dentistAgreementComponent =
          dentist_agreement_checkbox_component
              .DentistAgreementCheckboxComponentNgFactory;

      agreementCheckboxComponent = _loader.loadNextToLocation(
          dentistAgreementComponent, materialContainerDentistAgreement);

      agreementCheckboxComponent.instance.dentistId =
          dentistService.dentist.id;
      agreementCheckboxComponent.instance.agreementId = agreement.id;
      agreementCheckboxComponent.instance.agreement =
          agreement.description;

      listComponentRefAgreement.add(agreementCheckboxComponent);
    });

    _listShift.forEach((shift) {
      ComponentFactory<
              attendance_interval_edit_component
                  .AttendanceIntervalEditComponent>
          attendanceIntervalEditComponent = attendance_interval_edit_component
              .AttendanceIntervalEditComponentNgFactory;

      ComponentRef attendanceIntervalEditComponentRef =
          _loader.loadNextToLocation(attendanceIntervalEditComponent,
              materialContainerAttendanceInterval);

      attendanceIntervalEditComponentRef.instance.dentistId =
          dentistService.dentist.id;
      attendanceIntervalEditComponentRef.instance.shiftDescription =
          shift.description;
      attendanceIntervalEditComponentRef.instance.shiftId = shift.id;
      attendanceIntervalEditComponentRef.instance.startTime = shift.startTimeHour;
      attendanceIntervalEditComponentRef.instance.endTime = shift.endTimeHour;

      listComponentRefAttendanceInterval
          .add(attendanceIntervalEditComponentRef);
    });

    /*List _list = ['Domingo', 'Segunda-Feira', 'Terça-Feira', 
                  'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 
                  'Sábado'];

    _list.forEach((day) {
      ComponentFactory<
              shift_by_day_group_component
                  .ShiftByDayGroupComponent>
          agendamentoCard = shift_by_day_group_component
              .ShiftByDayGroupComponentNgFactory;

      ComponentRef quantityPerShiftByDayGroupCheckboxComponentComponent =
          _loader.loadNextToLocation(
              agendamentoCard, materialContainerDayGroupCheckbox);

      quantityPerShiftByDayGroupCheckboxComponentComponent.instance.dentistId = dentistService.dentist?.id;
      quantityPerShiftByDayGroupCheckboxComponentComponent.instance.dayOfWeek = day;

      listComponentRefQuantityPerShiftByDayOfWeek.add(quantityPerShiftByDayGroupCheckboxComponentComponent);
    });*/

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    dentistService.dentist = dentistService.returnEmptyDentist();
    querySelector('deshboard_appointment_component').style.overflowY = "scroll";
    onClearListsOfComponentRef();
    componentRef.destroy();
  }

  bool asserts() {
    return true;
  }

  void onDismissSuccessfullySave() {
    showSuccessfullySave = false;
    onClose();
  }

  void onDismissNotSuccessfullySave() {
    showSuccessfullySave = false;
  }

  void onDismissAssertMessage() {
    showAssertMessageSave = false;
  }

  void onAssertsSave() {
    if (disabled) return;

    disabled = true;
    if ((dentistService.dentist.name == "")) {
      showAssertMessageSave = true;
      disabled = false;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
    disabled = false;
  }

  void onSave() async {
    showAssertMessageAlert = false;

    if (await dentistService.save()) {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }

    _changeDetectorRef.markForCheck();
  }
}
