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

import '../../agendamento/dentist/dentist.dart';
import '../../agendamento/dentist/dentistUI.dart';
import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/dentist/dentist_selection_options.dart';

import '../../agendamento/shift/shift.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/shift/shift_selection_options.dart';

import '../../agendamento/agreement/agreement.dart';
import '../../agendamento/agreement/agreement_service.dart';
import '../../agendamento/agreement/agreement_selection_options.dart';

import 'package:firebase/firebase.dart' as fb;
import '../../firebase/firestore.dart';

import '../../agendamento/consulta/consulta_service.dart';

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'agendamento-edit-app',
    styleUrls: const [
      'agendamento_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'agendamento_edit_component.html',
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
class AgendamentoEditComponent implements OnInit {
  ConsultaService _consultaService;

  ConsultaService get consultaService => _consultaService;
  set consultaService(ConsultaService consultaService) => _consultaService = consultaService;

  Date dataConsulta = new Date.today();

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  String paciente = '';
  String email = '';
  String _telefone = '';

  int maxLength = 14;

  Map<String, dynamic> datas;

  set telefone(String value) {
    _telefone = '';

    if (value.length == 0) {
      return;
    }

    String valueLocal = '';

    for (var i = 0; i < value.length; i++) {
      if (int.tryParse(value.substring(i, i + 1)) != null) {
        valueLocal = valueLocal + value.substring(i, i + 1);
      }
    }

    if (valueLocal.length >= 14) {
      _telefone = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6, 13);
      return;
    }

    if (valueLocal.length >= 7) {
      _telefone = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6);
      return;
    }

    if (valueLocal.length > 2) {
      _telefone =
          '(' + valueLocal.substring(0, 2) + ')' + valueLocal.substring(2);
      return;
    }

    if (valueLocal.length > 0) {
      _telefone = '(' + _telefone + valueLocal.substring(0);
    }
  }

  onKeydownTelephone(event) {
    if ((event.keyCode == KeyCode.BACKSPACE) ||
        (event.keyCode == KeyCode.RIGHT) ||
        (event.keyCode == KeyCode.LEFT)) {
      return;
    }

    if ((int.tryParse(event.key) == null) || (telefone.length > 13)) {
      event.preventDefault();
    }
  }

  String get telefone => _telefone;

  static ItemRenderer<DentistUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  List<Dentist> _listDentist;
  final DentistService _dentistService;

  static ItemRenderer<Dentist> _itemRendererDentist =
      newCachingItemRenderer<Dentist>((dentista) => "${dentista.name}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRenderer;

  DentistSelectionOptions<Dentist> dentistListOptions;

  StringSelectionOptions<Dentist> get dentistOptions {
    if (_listDentist == null) {
      return null;
    }

    dentistListOptions = DentistSelectionOptions<Dentist>(_listDentist);

    return dentistListOptions;
  }

  final SelectionModel<DentistUI> singleSelectModelDentist =
      SelectionModel.single();

  String get singleSelectDentistLabel =>
    singleSelectModelDentist.selectedValues == null 
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

  String get singleSelectShiftLabel =>
    singleSelectModelShift.selectedValues == null
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
      newCachingItemRenderer<Agreement>((agreement) => "${agreement.description}");

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

  final SelectionModel<Agreement> singleSelectModelAgreement = SelectionModel.single();

  String get singleSelectAgreementLabel =>
    singleSelectModelAgreement.selectedValues == null 
      ? 'Convênios'
      : singleSelectModelAgreement.selectedValues.length > 0
            ? itemRendererAgreement(singleSelectModelAgreement.selectedValues.first)
            : 'Convênios';

  String get singleSelectedAgreement =>
      singleSelectModelAgreement.selectedValues.isNotEmpty
          ? singleSelectModelAgreement.selectedValues.first.uiDisplayName
          : null;

  AgendamentoEditComponent(
      this._dentistService, this._shiftService, this._agreementService);

  Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistAcives();
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
    consultaService = new ConsultaService();

    _getListShift();
    _getListDentist();
    _getListAgreement();

    if (consultaService.consulta != null) {
      dataConsulta = new Date.parse(consultaService.consulta.dataConsultaAgendamento, 
                                    new DateFormat('yyyy-MM-dd'));

      paciente = consultaService.consulta.paciente;
      email = consultaService.consulta.email;
      telefone = consultaService.consulta.telefone;

      singleSelectModelShift.select(consultaService.consulta.shift);
      singleSelectModelDentist.select(new DentistUI(consultaService.consulta.dentist.id,
                                                    consultaService.consulta.dentist.name));
      singleSelectModelAgreement.select(consultaService.consulta.agreement);
    } else {
      dataConsulta = new Date.today();
    }
  }

  void ngOnInit() {
    if (new UserService().user  == null)
      return;

    onEdit();    
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

    paciente = '';
    email = '';
    telefone = '';

    querySelector('#agendamento-edit-app').style.display = 'none';
  }

  bool asserts() {
    if (dataConsulta == null) {
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
    if ((singleSelectModelShift.selectedValues.isEmpty)
       || (singleSelectModelDentist.selectedValues.isEmpty)
       || (singleSelectModelAgreement.selectedValues.isEmpty)
       || (paciente == '')
       || (telefone == '')
       || (dataConsulta == null)) {

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

    datas = new Map<String, dynamic>();

    datas = {
      "dateAppointmentScheduling": new DateFormat('yyyy-MM-dd').format(dataConsulta.asUtcTime()),
      "shiftId": singleSelectModelShift.selectedValues.first.shiftId,
      "agreementId": singleSelectModelAgreement.selectedValues.first.agreementId,
      "dentistId": singleSelectModelDentist
          .selectedValues.first.id, //querySelector('#dentista').text
      "patient": paciente,
      "email": email,
      "tel": telefone,
      "userId": fb.auth().currentUser.uid
    };

    FireStoreApp _fireStoreApp = new FireStoreApp('appointmentsScheduling');

    if (consultaService.consulta != null
        ? await _fireStoreApp.updateItem(consultaService.consulta?.id, datas)
        : await _fireStoreApp.addItem(datas)) {
      showSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    } else {
      showNotSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    }
  }
}
