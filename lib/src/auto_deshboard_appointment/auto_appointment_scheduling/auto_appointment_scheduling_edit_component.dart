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
import 'package:intl/intl.dart';
import 'package:angular_router/angular_router.dart';

import '../../appointment/mask/telephone_mask.dart';
import '../../appointment/patient_account/patient_account_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';

import '../../appointment/user/user_service.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
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
class AutoAgendamentoEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefDropdownSelect = new List<ComponentRef>();

  PatientAccountService patientAccountService;
  AppointmentSchedulingService appointmentSchedulingService;

  Date dateAppointmentScheduling = new Date.today();

  TelephoneMask telephoneMask = new TelephoneMask("");

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

  AutoAgendamentoEditComponent(this._loader, this._changeDetectorRef);

  /*Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistAcives();
  }

  Future<void> _getListAgreement() async {
    if (_listAgreement == null) {
      _listAgreement = await _agreementService.getAllAgreementAcives();
    }
  }*/

  void onEdit() {
    appointmentSchedulingService = new AppointmentSchedulingService();
    patientAccountService = new PatientAccountService();

    //_getListDentist();
    //_getListAgreement();

    if (appointmentSchedulingService.appointmentScheduling != null) {
      dateAppointmentScheduling = new Date.parse(
          appointmentSchedulingService.appointmentScheduling.dateAppointmentScheduling,
          new DateFormat('yyyy-MM-dd'));

      //singleSelectModelDentist.select(new DentistUI(consultaService.consulta.dentist.id,
      //                                              consultaService.consulta.dentist.name));
      //singleSelectModelAgreement.select(consultaService.consulta.agreement);
    } else {
      dateAppointmentScheduling = new Date.today();
    }
  }

  void ngOnInit() {
    if (new UserService().user == null) return;

    onEdit();

    ComponentFactory<
            dentist_dropdown_select_list_component
                .DentistDropdownSelectComponent> dentistDropdownSelectComponent =
        dentist_dropdown_select_list_component
            .DentistDropdownSelectComponentNgFactory;

    listComponentRefDropdownSelect.add(_loader.loadNextToLocation(
        dentistDropdownSelectComponent, materialContainerDentistDropdownSelect));

    ComponentFactory<
            procedure_dropdown_select_list_component
                .ProcedureDropdownSelectComponent> procedureDropdownSelectComponent =
        procedure_dropdown_select_list_component
            .ProcedureDropdownSelectComponentNgFactory;

    listComponentRefDropdownSelect.add(_loader.loadNextToLocation(
        procedureDropdownSelectComponent, materialContainerProcedureDropdownSelect));

    ComponentFactory<
            agreement_dropdown_select_list_component
                .AgreementDropdownSelectComponent> agreementDropdownSelectComponent =
        agreement_dropdown_select_list_component
            .AgreementDropdownSelectComponentNgFactory;

    listComponentRefDropdownSelect.add(_loader.loadNextToLocation(
        agreementDropdownSelectComponent, materialContainerAgreementDropdownSelect));

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    /*if (!singleSelectModelDentist.selectedValues.isEmpty) {
      singleSelectModelDentist
          ?.deselect(singleSelectModelDentist?.selectedValues?.first);
    }

    if (!singleSelectModelAgreement.selectedValues.isEmpty) {
      singleSelectModelAgreement
          ?.deselect(singleSelectModelAgreement?.selectedValues?.first);
    }*/
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
    if ( //(singleSelectModelDentist.selectedValues.isEmpty)
        //|| (singleSelectModelAgreement.selectedValues.isEmpty)
        (appointmentSchedulingService.appointmentScheduling.patient == '') ||
            (telephoneMask.number == '') ||
            (dateAppointmentScheduling == null)) {
      showAssertMessageSave = true;
      return;
    }

    if (appointmentSchedulingService.appointmentScheduling.email == '') {
      showAssertMessageAlert = true;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
  }

  void onSave() async {
    /*  showAssertMessageAlert = false;

    datas = new Map<String, dynamic>();

    datas = {
      "dateAppointmentScheduling": new DateFormat('yyyy-MM-dd').format(dataConsulta.asUtcTime()),
      //"agreementId": singleSelectModelAgreement.selectedValues.first.agreementId,
      //"dentistId": singleSelectModelDentist
      //    .selectedValues.first.id, //querySelector('#dentista').text
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
    }*/
  }
}
