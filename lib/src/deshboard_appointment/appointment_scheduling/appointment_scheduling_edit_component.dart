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

import '../../appointment/mask/telephone_mask.dart';
import '../../appointment/mask/telephone_mask_constants.dart';

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
    providers: [
      windowBindings,
      datepickerBindings
    ])
class AppointmentSchedulingEditComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  AppointmentSchedulingService _appointmentSchedulingService;

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef agreementDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;

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

  AppointmentSchedulingEditComponent(this._changeDetectorRef);

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

  void ngOnInit() {
    if (new UserService().user == null) return;

    onEdit();

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    /*if (!singleSelectModelShift.selectedValues.isEmpty) {
      singleSelectModelShift
          ?.deselect(singleSelectModelShift?.selectedValues?.first);
    }*/

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
    if (//(singleSelectModelShift.selectedValues.isEmpty) ||
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
      //"shiftId": singleSelectModelShift.selectedValues.first.id,
      //"agreementId":
      //    singleSelectModelAgreement.selectedValues.first.agreementId,
      //"dentistId": singleSelectModelDentist
      //    .selectedValues.first.id, //querySelector('#dentista').text
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
