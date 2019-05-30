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

import 'package:firebase/firebase.dart' as fb;

import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_dao.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/shift/shift_service.dart';

import '../../appointment/mask/telephone_mask.dart';
import '../../appointment/mask/telephone_mask_constants.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/agreement/agreement_dropdown_select_component.template.dart'
    as agreement_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift/shift_dropdown_select_component.template.dart'
    as shift_dropdown_select_list_component;

@Component(
    selector: 'appointment_scheduling_edit_component',
    styleUrls: const [
      'appointment_scheduling_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'appointment_scheduling_edit_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
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
class AppointmentSchedulingEditComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final List<ComponentRef> listComponentRefDropdownSelect =
      new List<ComponentRef>();

  AppointmentSchedulingService _appointmentSchedulingService;

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef agreementDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;

  final DentistService dentistService = new DentistService();
  final AgreementService agreementService = new AgreementService();
  final ShiftService shiftService = new ShiftService();

  TelephoneMask telephoneMask = new TelephoneMask("");

  @Input()
  ComponentRef componentRef;

  AppointmentSchedulingService get appointmentSchedulingService =>
      _appointmentSchedulingService;
  set appointmentSchedulingService(
          AppointmentSchedulingService appointmentSchedulingService) =>
      _appointmentSchedulingService = appointmentSchedulingService;

  Date dateAppointmentScheduling = new Date.today();

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  String patient = '';
  String email = '';

  int maxLength = MAX_LENGTH;

  @ViewChild('dentistDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistDropdownSelect;

  @ViewChild('shiftDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerShiftDropdownSelect;

  @ViewChild('agreementDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerAgreementDropdownSelect;

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

  AppointmentSchedulingEditComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    appointmentSchedulingService = new AppointmentSchedulingService();

    if (appointmentSchedulingService.appointmentScheduling != null) {
      dateAppointmentScheduling = new Date.parse(
          appointmentSchedulingService
              .appointmentScheduling.dateAppointmentScheduling,
          new DateFormat('yyyy-MM-dd'));

      patient = appointmentSchedulingService.appointmentScheduling.patient;
      email = appointmentSchedulingService.appointmentScheduling.email;
      telephoneMask.number =
          appointmentSchedulingService.appointmentScheduling.telephone;

      /*if (appointmentSchedulingService.appointmentScheduling.shift != null) {
        singleSelectModelShift
            .select(new ShiftUI(appointmentSchedulingService.appointmentScheduling.shift.id,
                                appointmentSchedulingService.appointmentScheduling.shift.description));
      }*/
    } else {
      dateAppointmentScheduling = new Date.today();
    }
  }

  void clearListComponentRef(List<ComponentRef> listComponentRef) {
    listComponentRef.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRef.clear();
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await dentistService.getAllDentistAcives();
    await agreementService.getAllAgreementAcives();
    await shiftService.getAllShiftAcives();

    clearListComponentRef(listComponentRefDropdownSelect);

    ComponentFactory<
        dentist_dropdown_select_list_component
            .DentistDropdownSelectComponent> dentistDropdownSelectComponent;

    dentistDropdownSelectComponent = dentist_dropdown_select_list_component
        .DentistDropdownSelectComponentNgFactory;

    dentistDropdownSelectComponentRef = _loader.loadNextToLocation(
        dentistDropdownSelectComponent, materialContainerDentistDropdownSelect);

    listComponentRefDropdownSelect.add(dentistDropdownSelectComponentRef);

    ComponentFactory<
        agreement_dropdown_select_list_component
            .AgreementDropdownSelectComponent> agreementDropdownSelectComponent;

    agreementDropdownSelectComponent = agreement_dropdown_select_list_component
        .AgreementDropdownSelectComponentNgFactory;

    agreementDropdownSelectComponentRef = _loader.loadNextToLocation(
        agreementDropdownSelectComponent,
        materialContainerDentistDropdownSelect);

    listComponentRefDropdownSelect.add(agreementDropdownSelectComponentRef);

    ComponentFactory<
            shift_dropdown_select_list_component.ShiftDropdownSelectComponent>
        shiftDropdownSelectComponent;

    shiftDropdownSelectComponent = shift_dropdown_select_list_component
        .ShiftDropdownSelectComponentNgFactory;

    shiftDropdownSelectComponentRef = _loader.loadNextToLocation(
        shiftDropdownSelectComponent, materialContainerDentistDropdownSelect);

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

    if (!agreementDropdownSelectComponentRef
        .instance.singleSelectModelAgreement.selectedValues.isEmpty) {
      agreementDropdownSelectComponentRef.instance.singleSelectModelAgreement
          ?.deselect(agreementDropdownSelectComponentRef
              .instance.singleSelectModelAgreement?.selectedValues?.first);
    }

    if (!shiftDropdownSelectComponentRef
        .instance.singleSelectModelShift.selectedValues.isEmpty) {
      shiftDropdownSelectComponentRef.instance.singleSelectModelShift
          ?.deselect(shiftDropdownSelectComponentRef
              .instance.singleSelectModelShift?.selectedValues?.first);
    }

    patient = '';
    email = '';
    telephoneMask.number = '';

    componentRef.destroy();
  }

  bool asserts() {
    if (dateAppointmentScheduling == null) {
      return false;
    }

    return true;
  }

  void onDismissSuccessfullySave() {
    showSuccessfullySave = false;
    querySelector("#bt-filter").click();
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
        (agreementDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) ||
        (shiftDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) ||
        (patient == '') ||
        (telephoneMask.number == '') ||
        (dateAppointmentScheduling == null)) {
      showAssertMessageSave = true;
      return;
    }

    if (email == '') {
      showAssertMessageAlert = true;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
  }

  void onSave() async {
    showAssertMessageAlert = false;

    Map datas = new Map<String, dynamic>();

    datas = {
      "dateAppointmentScheduling": new DateFormat('yyyy-MM-dd')
          .format(dateAppointmentScheduling.asUtcTime()),
      "shiftId": shiftDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.first.id,
      "agreementId": agreementDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.first.id,
      "dentistId": dentistDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.first.id,
      "patient": patient,
      "email": email,
      "tel": telephoneMask.number,
      "userId": fb.auth().currentUser.uid
    };

    Map<bool, String> result;

    if (appointmentSchedulingService.appointmentScheduling != null) {
      result[await new AppointmentSchedulingDAO().update(
              appointmentSchedulingService.appointmentScheduling?.id, datas) ==
          ""] = appointmentSchedulingService.appointmentScheduling?.id;
    } else {
      result = await new AppointmentSchedulingDAO().save(datas);
    }

    if (result.keys.first) {
      showSuccessfullySave = true;
    } else {
      showNotSuccessfullySave = true;
    }

    _changeDetectorRef.markForCheck();
  }
}
