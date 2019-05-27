import 'dart:async';
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
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:intl/intl.dart';

import '../../appointment/dentist/dentistUI.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/dentist/dentist_selection_options.dart';

import '../../appointment/shift/shift.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/shift/shift_selection_options.dart';

import '../../appointment/agreement/agreement.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/agreement/agreement_selection_options.dart';

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
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [
      windowBindings,
      datepickerBindings,
      ClassProvider(ShiftService),
      ClassProvider(DentistService),
      ClassProvider(AgreementService)
    ])
class AppointmentSchedulingEditComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  AppointmentSchedulingService _appointmentSchedulingService;

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

  static ItemRenderer<DentistUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  List<DentistUI> _listDentist;
  final DentistService _dentistService;

  static ItemRenderer<DentistUI> _itemRendererDentist =
      newCachingItemRenderer<DentistUI>((dentista) => "${dentista.name}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRenderer;

  DentistSelectionOptions<DentistUI> dentistListOptions;

  StringSelectionOptions<DentistUI> get dentistOptions {
    if (_listDentist == null) {
      return null;
    }

    dentistListOptions = DentistSelectionOptions<DentistUI>(_listDentist);

    return dentistListOptions;
  }

  final SelectionModel<DentistUI> singleSelectModelDentist =
      SelectionModel.single();

  String get singleSelectDentistLabel => singleSelectModelDentist
              .selectedValues ==
          null
      ? 'Dentista'
      : singleSelectModelDentist.selectedValues.length > 0
          ? itemRendererDentist(singleSelectModelDentist.selectedValues.first)
          : 'Dentista';

  String get singleSelectedDentist =>
      singleSelectModelDentist.selectedValues.isNotEmpty
          ? singleSelectModelDentist.selectedValues.first.uiDisplayName
          : null;

//----

  List<Shift> _listShift;
  final ShiftService _shiftService;

  static ItemRenderer<Shift> _itemRendererShift =
      newCachingItemRenderer<Shift>((shift) => "${shift.description}");

  ItemRenderer<Shift> get itemRendererShift =>
      useItemRenderer ? _itemRendererShift : _displayNameRenderer;

  ShiftSelectionOptions<Shift> shiftListOptions;

  StringSelectionOptions<Shift> get shiftOptions {
    if (_listShift == null) {
      return null;
    }

    shiftListOptions = ShiftSelectionOptions<Shift>(_listShift);

    return shiftListOptions;
  }

  final SelectionModel<Shift> singleSelectModelShift = SelectionModel.single();

  String get singleSelectShiftLabel => singleSelectModelShift.selectedValues ==
          null
      ? '  '
      : singleSelectModelShift.selectedValues.length > 0
          ? itemRendererShift(singleSelectModelShift.selectedValues.first)
          : 'Turno';

  String get singleSelectedShift =>
      singleSelectModelShift.selectedValues.isNotEmpty
          ? singleSelectModelShift.selectedValues.first.uiDisplayName
          : null;
//----

  List<Agreement> _listAgreement;
  final AgreementService _agreementService;

  static ItemRenderer<Agreement> _itemRendererAgreement =
      newCachingItemRenderer<Agreement>(
          (agreement) => "${agreement.description}");

  ItemRenderer<Agreement> get itemRendererAgreement =>
      useItemRenderer ? _itemRendererAgreement : _displayNameRenderer;

  AgreementSelectionOptions<Agreement> agreementListOptions;

  StringSelectionOptions<Agreement> get agreementOptions {
    if (_listAgreement == null) {
      return null;
    }

    agreementListOptions = AgreementSelectionOptions<Agreement>(_listAgreement);

    return agreementListOptions;
  }

  final SelectionModel<Agreement> singleSelectModelAgreement =
      SelectionModel.single();

  String get singleSelectAgreementLabel =>
      singleSelectModelAgreement.selectedValues == null
          ? 'Convênios'
          : singleSelectModelAgreement.selectedValues.length > 0
              ? itemRendererAgreement(
                  singleSelectModelAgreement.selectedValues.first)
              : 'Convênios';

  String get singleSelectedAgreement =>
      singleSelectModelAgreement.selectedValues.isNotEmpty
          ? singleSelectModelAgreement.selectedValues.first.uiDisplayName
          : null;

  AppointmentSchedulingEditComponent(this._dentistService, this._shiftService,
      this._agreementService, this._changeDetectorRef);

  Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistUIAcives();
  }

  Future<void> _getListShift() async {
    _listShift = await _shiftService.getAllShiftAcives();
  }

  Future<void> _getListAgreement() async {
    if (_listAgreement == null) {
      _listAgreement = await _agreementService.getAllAgreementAcives();
    }
  }

  void onEdit() {
    appointmentSchedulingService = new AppointmentSchedulingService();

    _getListShift();
    _getListDentist();
    _getListAgreement();

    if (appointmentSchedulingService.appointmentScheduling != null) {
      dateAppointmentScheduling = new Date.parse(
          appointmentSchedulingService
              .appointmentScheduling.dateAppointmentScheduling,
          new DateFormat('yyyy-MM-dd'));

      patient = appointmentSchedulingService.appointmentScheduling.patient;
      email = appointmentSchedulingService.appointmentScheduling.email;
      telephoneMask.number =
          appointmentSchedulingService.appointmentScheduling.telephone;

      if (appointmentSchedulingService.appointmentScheduling.shift != null) {
        singleSelectModelShift
            .select(appointmentSchedulingService.appointmentScheduling.shift);
      }

      if (appointmentSchedulingService.appointmentScheduling.dentist != null) {
        singleSelectModelDentist.select(new DentistUI(
            appointmentSchedulingService.appointmentScheduling.dentist.id,
            appointmentSchedulingService.appointmentScheduling.dentist.name));
      }

      if (appointmentSchedulingService.appointmentScheduling.agreement !=
          null) {
        singleSelectModelAgreement.select(
            appointmentSchedulingService.appointmentScheduling.agreement);
      }
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
    if (!singleSelectModelShift.selectedValues.isEmpty) {
      singleSelectModelShift
          ?.deselect(singleSelectModelShift?.selectedValues?.first);
    }

    if (!singleSelectModelDentist.selectedValues.isEmpty) {
      singleSelectModelDentist
          ?.deselect(singleSelectModelDentist?.selectedValues?.first);
    }

    if (!singleSelectModelAgreement.selectedValues.isEmpty) {
      singleSelectModelAgreement
          ?.deselect(singleSelectModelAgreement?.selectedValues?.first);
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
    if ((singleSelectModelShift.selectedValues.isEmpty) ||
        (singleSelectModelDentist.selectedValues.isEmpty) ||
        (singleSelectModelAgreement.selectedValues.isEmpty) ||
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
      "shiftId": singleSelectModelShift.selectedValues.first.id,
      "agreementId":
          singleSelectModelAgreement.selectedValues.first.agreementId,
      "dentistId": singleSelectModelDentist
          .selectedValues.first.id, //querySelector('#dentista').text
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
