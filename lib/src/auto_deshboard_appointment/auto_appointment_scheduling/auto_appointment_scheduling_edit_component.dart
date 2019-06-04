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
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:intl/intl.dart';
import 'package:angular_router/angular_router.dart';

import '../../appointment/mask/telephone_mask.dart';
import '../../appointment/patient_account/patient_account_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/dentist/dentistUI.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/procedure/procedureUI.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/shift/shiftUI.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/agreement/agreementUI.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';

import '../../appointment/user/user_service.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift/shift_dropdown_select_component.template.dart'
    as shift_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/agreement/agreement_dropdown_select_component.template.dart'
    as agreement_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/procedure/procedure_dropdown_select_component.template.dart'
    as procedure_dropdown_select_list_component;

@Component(
    selector: 'auto_appointment_scheduling_edit_component',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'auto_appointment_scheduling_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_appointment_scheduling_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      RouterOutlet,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDatepickerComponent,
      DateRangeInputComponent,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [windowBindings, datepickerBindings])
class AutoAppointmentSchedulingEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefDropdownSelect =
      new List<ComponentRef>();

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef procedureDropdownSelectComponentRef;
  ComponentRef agreementDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;

  final DentistService dentistService = new DentistService();
  final ProcedureService procedureService = new ProcedureService();
  final AgreementService agreementService = new AgreementService();
  final ShiftService shiftService = new ShiftService();
  final PatientAccountService patientAccountService =
      new PatientAccountService();
  final AutoAppointmentSchedulingService autoAppointmentSchedulingService =
      new AutoAppointmentSchedulingService();

  final TelephoneMask telephoneMask = new TelephoneMask("");
  
  Date dateAppointmentScheduling = new Date.today();

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  @ViewChild('dentistDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistDropdownSelect;

  @ViewChild('procedureDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerProcedureDropdownSelect;

  @ViewChild('agreementDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerAgreementDropdownSelect;

  @ViewChild('shiftDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerShiftDropdownSelect;

  onKeydownTelephone(event) {
    if ((event.keyCode == KeyCode.BACKSPACE) ||
        (event.keyCode == KeyCode.RIGHT) ||
        (event.keyCode == KeyCode.LEFT) ||
        (event.keyCode == KeyCode.TAB)) {
      return;
    }

    if ((int.tryParse(event.key) == null) ||
        (telephoneMask.number.length > 13)) {
      event.preventDefault();
    }
  }

  AutoAppointmentSchedulingEditComponent(this._loader, this._changeDetectorRef);

  void onEdit() {
    if (autoAppointmentSchedulingService.autoAppointmentScheduling != null) {
      dateAppointmentScheduling = new Date.parse(
          autoAppointmentSchedulingService
              .autoAppointmentScheduling.dateAppointmentScheduling,
          new DateFormat('yyyy-MM-dd'));

      if (autoAppointmentSchedulingService.autoAppointmentScheduling.dentist !=
          null) {
        dentistDropdownSelectComponentRef.instance.singleSelectModelDentist
            .select(new DentistUI(
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.dentist.id,
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.dentist.name));
      }

      if (autoAppointmentSchedulingService
              .autoAppointmentScheduling.agreement !=
          null) {
        agreementDropdownSelectComponentRef.instance.singleSelectModelAgreement
            .select(new AgreementUI(
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.agreement.id,
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.agreement.description));
      }

      if (autoAppointmentSchedulingService.autoAppointmentScheduling.shift !=
          null) {
        shiftDropdownSelectComponentRef.instance.singleSelectModelShift.select(
            new ShiftUI(
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.shift.id,
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.shift.description));
      }

      if (autoAppointmentSchedulingService
              .autoAppointmentScheduling.procedure !=
          null) {
        procedureDropdownSelectComponentRef.instance.singleSelectModelProcedure
            .select(new ProcedureUI(
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.procedure.id,
                autoAppointmentSchedulingService
                    .autoAppointmentScheduling.procedure.description));
      }
    } else {
      dateAppointmentScheduling = new Date.today();
      autoAppointmentSchedulingService.autoAppointmentScheduling = autoAppointmentSchedulingService.returnEmptyAutoAppointmentScheduling();
    }
  }

  void clearListComponentRef(List<ComponentRef> listComponentRef) {
    listComponentRef.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRef.clear();
  }

  void ngOnInit() async {
    if ((new UserService().user == null) ||
        (patientAccountService.patientAccount == null)) return;

    await dentistService.getAllDentistAcives();
    await procedureService.getAllProcedureAcives();
    await agreementService.getAllAgreementAcives();
    await shiftService.getAllShiftAcives();

    clearListComponentRef(listComponentRefDropdownSelect);

    ComponentFactory<
            dentist_dropdown_select_list_component
                .DentistDropdownSelectComponent>
        dentistDropdownSelectComponent = dentist_dropdown_select_list_component
            .DentistDropdownSelectComponentNgFactory;

    dentistDropdownSelectComponentRef = _loader.loadNextToLocation(
        dentistDropdownSelectComponent, materialContainerDentistDropdownSelect);

    listComponentRefDropdownSelect.add(dentistDropdownSelectComponentRef);

    ComponentFactory<
            procedure_dropdown_select_list_component
                .ProcedureDropdownSelectComponent>
        procedureDropdownSelectComponent =
        procedure_dropdown_select_list_component
            .ProcedureDropdownSelectComponentNgFactory;

    procedureDropdownSelectComponentRef = _loader.loadNextToLocation(
        procedureDropdownSelectComponent,
        materialContainerProcedureDropdownSelect);

    listComponentRefDropdownSelect.add(procedureDropdownSelectComponentRef);

    ComponentFactory<
            agreement_dropdown_select_list_component
                .AgreementDropdownSelectComponent>
        agreementDropdownSelectComponent =
        agreement_dropdown_select_list_component
            .AgreementDropdownSelectComponentNgFactory;

    agreementDropdownSelectComponentRef = _loader.loadNextToLocation(
        agreementDropdownSelectComponent,
        materialContainerAgreementDropdownSelect);

    listComponentRefDropdownSelect.add(agreementDropdownSelectComponentRef);

    ComponentFactory<
            shift_dropdown_select_list_component.ShiftDropdownSelectComponent>
        shiftDropdownSelectComponent = shift_dropdown_select_list_component
            .ShiftDropdownSelectComponentNgFactory;

    shiftDropdownSelectComponentRef = _loader.loadNextToLocation(
        shiftDropdownSelectComponent, materialContainerProcedureDropdownSelect);

    listComponentRefDropdownSelect.add(shiftDropdownSelectComponentRef);

    onEdit();

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    if (!dentistDropdownSelectComponentRef
        .instance.singleSelectModelDentist.selectedValues.isEmpty) {
      dentistDropdownSelectComponentRef.instance.singleSelectModelDentist
          ?.deselect(dentistDropdownSelectComponentRef
              .instance.singleSelectModelDentist?.selectedValues?.first);
    }

    if (!procedureDropdownSelectComponentRef
        .instance.singleSelectModelProcedure.selectedValues.isEmpty) {
      procedureDropdownSelectComponentRef.instance.singleSelectModelProcedure
          ?.deselect(procedureDropdownSelectComponentRef
              .instance.singleSelectModelProcedure?.selectedValues?.first);
    }

    if (!agreementDropdownSelectComponentRef
        .instance.singleSelectModelAgreement.selectedValues.isEmpty) {
      agreementDropdownSelectComponentRef.instance.singleSelectModelAgreement
          ?.deselect(agreementDropdownSelectComponentRef
              .instance.singleSelectModelAgreement?.selectedValues?.first);
    }

    if (!shiftDropdownSelectComponentRef
        .instance.singleSelectModelShift.selectedValues.isEmpty) {
      shiftDropdownSelectComponentRef.instance.singleSelectModelShift?.deselect(
          shiftDropdownSelectComponentRef
              .instance.singleSelectModelShift?.selectedValues?.first);
    }

    autoAppointmentSchedulingService.autoAppointmentScheduling = null;
  }

  bool asserts() {
    if (dateAppointmentScheduling == null) {
      return false;
    }

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
    if ((dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) ||
        (procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.isEmpty) ||
        (shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.isEmpty) ||
        (agreementDropdownSelectComponentRef
            .instance.singleSelectModelAgreement.selectedValues.isEmpty) ||
        (autoAppointmentSchedulingService
            .autoAppointmentScheduling.patient.isEmpty) ||
        ((telephoneMask.number == '') &&
            (autoAppointmentSchedulingService
                .autoAppointmentScheduling.email.isEmpty)) ||
        (dateAppointmentScheduling == null)) {
      showAssertMessageSave = true;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
  }

  void onSave() async {
    showAssertMessageAlert = false;

    autoAppointmentSchedulingService
            .autoAppointmentScheduling.dateAppointmentScheduling =
        new DateFormat('yyyy-MM-dd')
            .format(dateAppointmentScheduling.asUtcTime());

    autoAppointmentSchedulingService.autoAppointmentScheduling.telephone =
        telephoneMask.number;

    autoAppointmentSchedulingService.autoAppointmentScheduling.dentistId =
        dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.first.id;

    autoAppointmentSchedulingService.autoAppointmentScheduling.agreementId =
        agreementDropdownSelectComponentRef
            .instance.singleSelectModelAgreement.selectedValues.first.id;

    autoAppointmentSchedulingService.autoAppointmentScheduling.procedureId =
        procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.first.id;

    autoAppointmentSchedulingService.autoAppointmentScheduling.shiftId =
        shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.first.id;

    if (await autoAppointmentSchedulingService.save()) {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }

    _changeDetectorRef.markForCheck();
  }
}
