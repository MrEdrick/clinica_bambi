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
import '../../appointment/dentist_procedure/dentist_procedure_service.dart';
import '../../appointment/dentist_agreement/dentist_agreement_service.dart';
import '../../appointment/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';
import '../../appointment/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/procedure/procedureUI.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/shift/shiftUI.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/agreement/agreementUI.dart';
import '../../appointment/requirement/requirement_service.dart';
import '../../appointment/procedure_requirement/procedure_requirement_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../appointment/period_by_shift_by_day_of_week/period_by_shift_by_day_of_week_service.dart';
import '../../appointment/configuration/auto_appointment_scheduling_configuration/auto_appointment_scheduling_configuration_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';
import '../../appointment/available_times/available_times_service.dart';

import '../../appointment/user/user_service.dart';

import '../../email/email.dart';
import '../../email/email_constants.dart';
import '../../email/emailSenderService.dart';
import '../../email/emailSenderHTTP.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift/shift_dropdown_select_component.template.dart'
    as shift_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/available_times/available_times_dropdown_select_component.template.dart'
    as available_times_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/agreement/agreement_dropdown_select_component.template.dart'
    as agreement_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/procedure/procedure_dropdown_select_component.template.dart'
    as procedure_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/procedure_requirement/procedure_requirement_checkbox_component.template.dart'
    as procedure_requirement_checkbox_component;

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

  final List<ComponentRef> listComponentRefProcedureRequirement =
      new List<ComponentRef>();

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef procedureDropdownSelectComponentRef;
  ComponentRef agreementDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;
  ComponentRef procedureRequirementCheckboxComponentRef;
  ComponentRef availableTimesDropdownSelectComponentRef;

  EmailSenderHTTP emailSenderHTTP;

  final DentistService dentistService = new DentistService();
  final DentistProcedureService dentistProcedureService =
      new DentistProcedureService();
  final DentistAgreementService dentistAgreementService =
      new DentistAgreementService();
  final ProcedureService procedureService = new ProcedureService();
  final AgreementService agreementService = new AgreementService();
  final ShiftService shiftService = new ShiftService();
  final ProcedureRequirementService procedureRequirementService =
      new ProcedureRequirementService();
  final RequirementService requirementService = new RequirementService();
  final PatientAccountService patientAccountService =
      new PatientAccountService();
  final AutoAppointmentSchedulingService autoAppointmentSchedulingService =
      new AutoAppointmentSchedulingService();
  final DentistProcedureByDayOfWeekService dentistProcedureByDayOfWeekService =
      new DentistProcedureByDayOfWeekService();
  final DentistQuantityPerShiftByDayOfWeekService
      dentistQuantityPerShiftByDayOfWeekService =
      new DentistQuantityPerShiftByDayOfWeekService();
  final AppointmentSchedulingService appointmentSchedulingService =
      new AppointmentSchedulingService();
  final PeriodByShiftByDayOfWeekService periodByShiftByDayOfWeekService =
      new PeriodByShiftByDayOfWeekService();
  final AutoAppointmentSchedulingConfigurationService
      autoAppointmentSchedulingConfigurationService =
      new AutoAppointmentSchedulingConfigurationService();
  final AvailableTimesService availableTimesService =
      new AvailableTimesService();

  final TelephoneMask telephoneMask = new TelephoneMask("");

  Date _dateAppointmentScheduling = new Date.today();

  Date minDate = new Date.today();

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageSaveIvalidDate = false;
  bool showAssertMessageAlert = false;
  bool disabledButtonSave = true;

  List<String> listDaysOfWeekOfDentist = new List<String>();
  List<Map> listQuantityPerShiftByDayOfWeek = new List<Map>();

  String listDaysOfWeekOfAppointment = "";
  String listInvalidDatesByMonth = "";
  String vacancyMessage = "Informe todos os dados para a consulta da vaga";

  String saveButtonMessage = "GRAVAR AGENDAMENTO";

  String shiftObservation = "";

  @Input()
  ComponentRef componentRef;

  @ViewChild('dentistDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistDropdownSelect;

  @ViewChild('procedureDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerProcedureDropdownSelect;

  @ViewChild('agreementDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerAgreementDropdownSelect;

  @ViewChild('shiftDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerShiftDropdownSelect;

  @ViewChild('availableTimesDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerAvailableTimesDropdownSelect;

  @ViewChild('procedureRequirementCheckboxComponent', read: ViewContainerRef)
  ViewContainerRef materialContainerProcedureRequirementCheckBox;

  Date get dateAppointmentScheduling => _dateAppointmentScheduling;

  set dateAppointmentScheduling(Date dateAppointmentScheduling) {
    bool changed = (_dateAppointmentScheduling != dateAppointmentScheduling);

    if (shiftDropdownSelectComponentRef != null) {
      if (!shiftDropdownSelectComponentRef
          .instance.singleSelectModelShift.selectedValues.isEmpty) {
        shiftDropdownSelectComponentRef.instance.singleSelectModelShift
            ?.deselect(shiftDropdownSelectComponentRef
                .instance.singleSelectModelShift?.selectedValues?.first);
      }
    }

    if (availableTimesDropdownSelectComponentRef != null) {
      if (!availableTimesDropdownSelectComponentRef
          .instance.singleSelectModelAvailableTimes.selectedValues.isEmpty) {
        availableTimesDropdownSelectComponentRef
            .instance.singleSelectModelAvailableTimes
            ?.deselect(availableTimesDropdownSelectComponentRef.instance
                .singleSelectModelAvailableTimes?.selectedValues?.first);
      }
    }

    _dateAppointmentScheduling = dateAppointmentScheduling;

    if (changed) {
      shiftDropdownSelectComponentRef.instance.dentistProcedureByDayOfWeekId =
          '';
      shiftDropdownSelectComponentRef.instance.showAvailableShifts = true;
    }

    returnDaysOfWeekListByDentistProcedureIdMap()
        .then((daysOfWeekOfDentistById) {
      if (!daysOfWeekOfDentistById.isEmpty) {
        shiftDropdownSelectComponentRef.instance.showAvailableShifts = true;
      }

      if (changed) {
        listAvailableTimes();
      }
    });
  }

  onKeydownTelephone(event) {
    if ((event.keyCode == KeyCode.BACKSPACE) ||
        (event.keyCode == KeyCode.RIGHT) ||
        (event.keyCode == KeyCode.LEFT) ||
        (event.keyCode == KeyCode.TAB)) {
      return;
    }

    if ((int.tryParse(event.key) == null) ||
        (telephoneMask.number.length > 14)) {
      event.preventDefault();
    }
  }

  AutoAppointmentSchedulingEditComponent(this._loader, this._changeDetectorRef);

  void onEdit() {
    if (!autoAppointmentSchedulingService
        .autoAppointmentScheduling.id.isEmpty) {
      procedureDropdownSelectComponentRef.instance.disabled = true;

      disabledButtonSave = false;

      dateAppointmentScheduling = new Date.parse(
          autoAppointmentSchedulingService
              .autoAppointmentScheduling.dateAppointmentScheduling,
          new DateFormat('yyyy-MM-dd'));

      telephoneMask.number =
          autoAppointmentSchedulingService.autoAppointmentScheduling.telephone;

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
      autoAppointmentSchedulingService.autoAppointmentScheduling.email =
          patientAccountService.patientAccount.email;
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
    if ((new UserService().user == null) ||
        (patientAccountService.patientAccount == null)) return;

    await dentistService.getAllDentistAcives();
    await procedureService.getAllProcedureAcives();
    await agreementService.getAllAgreementAcives();
    await shiftService.getAllShiftAcives();
    await requirementService.getAllRequirementAcives();
    await procedureRequirementService.getAllProcedureRequirementAcives();
    await periodByShiftByDayOfWeekService
        .getAllPeriodByShiftByDayOfWeekAcives();
    await autoAppointmentSchedulingConfigurationService.getAllConfiguration();

    clearListComponentRef(listComponentRefDropdownSelect);

    listInvalidDatesByMonth = autoAppointmentSchedulingConfigurationService
        .autoAppointmentSchedulingConfiguration.invalidDates
        .where((date) =>
            date.substring(0, 8) ==
            new DateFormat('yyyy-MM-dd')
                .format(dateAppointmentScheduling.asUtcTime())
                .substring(0, 8))
        .map(
            (date) => new DateFormat('dd/MM/yyyy').format(DateTime.parse(date)))
        .join(" - ");

    ComponentFactory<
            dentist_dropdown_select_list_component
                .DentistDropdownSelectComponent>
        dentistDropdownSelectComponent = dentist_dropdown_select_list_component
            .DentistDropdownSelectComponentNgFactory;

    dentistDropdownSelectComponentRef = _loader.loadNextToLocation(
        dentistDropdownSelectComponent, materialContainerDentistDropdownSelect);

    dentistDropdownSelectComponentRef.instance.disabled = true;

    dentistDropdownSelectComponentRef.instance.selectionChanges
        .listen((_) => onSelectDentistSelectDropdown());

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

    procedureDropdownSelectComponentRef.instance.selectionChanges
        .listen((_) => onSelectProcedureSelectDropdown());

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

    agreementDropdownSelectComponentRef.instance.disabled = true;

    listComponentRefDropdownSelect.add(agreementDropdownSelectComponentRef);

    ComponentFactory<
            shift_dropdown_select_list_component.ShiftDropdownSelectComponent>
        shiftDropdownSelectComponent = shift_dropdown_select_list_component
            .ShiftDropdownSelectComponentNgFactory;

    shiftDropdownSelectComponentRef = _loader.loadNextToLocation(
        shiftDropdownSelectComponent, materialContainerShiftDropdownSelect);

    shiftDropdownSelectComponentRef.instance.selectionChanges
        .listen((_) => onSelectShiftSelectDropdown());

    shiftDropdownSelectComponentRef
        .instance.filterByDentistProcedureByDayOfWeek = true;

    listComponentRefDropdownSelect.add(shiftDropdownSelectComponentRef);

    if (autoAppointmentSchedulingService.autoAppointmentScheduling.id.isEmpty) {
      ComponentFactory<
              available_times_dropdown_select_list_component
                  .AvailableTimesDropdownSelectComponent>
          availableTimesDropdownSelectComponent =
          available_times_dropdown_select_list_component
              .AvailableTimesDropdownSelectComponentNgFactory;

      availableTimesDropdownSelectComponentRef = _loader.loadNextToLocation(
          availableTimesDropdownSelectComponent,
          materialContainerAvailableTimesDropdownSelect);

      availableTimesDropdownSelectComponentRef.instance.disabled = true;

      availableTimesDropdownSelectComponentRef.instance.selectionChanges
          .listen((_) => onSelectAvailableTimesSelectDropdown());

      listComponentRefDropdownSelect
          .add(availableTimesDropdownSelectComponentRef);
    }

    onEdit();

    _changeDetectorRef.markForCheck();
  }

  void onSelectProcedureSelectDropdown() async {
    if (!procedureDropdownSelectComponentRef
        .instance.singleSelectModelProcedure.selectedValues.isEmpty) {
      if (autoAppointmentSchedulingService
          .autoAppointmentScheduling.id.isEmpty) {
        if (!dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) {
          dentistDropdownSelectComponentRef.instance.singleSelectModelDentist
              ?.deselect(dentistDropdownSelectComponentRef
                  .instance.singleSelectModelDentist?.selectedValues?.first);
        }

        if (!shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.isEmpty) {
          shiftDropdownSelectComponentRef.instance.singleSelectModelShift
              ?.deselect(shiftDropdownSelectComponentRef
                  .instance.singleSelectModelShift?.selectedValues?.first);
        }

        if (!availableTimesDropdownSelectComponentRef
            .instance.singleSelectModelAvailableTimes.selectedValues.isEmpty) {
          availableTimesDropdownSelectComponentRef
              .instance.singleSelectModelAvailableTimes
              ?.deselect(availableTimesDropdownSelectComponentRef.instance
                  .singleSelectModelAvailableTimes?.selectedValues?.first);
        }

        shiftDropdownSelectComponentRef.instance.dentistProcedureByDayOfWeekId =
            '';
        shiftDropdownSelectComponentRef.instance.showAvailableShifts = true;

        await listAvailableTimes();
      }

      await dentistProcedureService
          .returnDentistIdListByProcedureId(procedureDropdownSelectComponentRef
              .instance.singleSelectModelProcedure.selectedValues.first.id)
          .then((listDentisitId) {
        if (autoAppointmentSchedulingService
            .autoAppointmentScheduling.id.isEmpty) {
          dentistDropdownSelectComponentRef.instance.disabled = false;
        }

        dentistDropdownSelectComponentRef.instance.listDentisitIdToShow =
            listDentisitId;
      });
      _changeDetectorRef.markForCheck();

      await listRequirementList(procedureDropdownSelectComponentRef
          .instance.singleSelectModelProcedure.selectedValues.first.id);
      _changeDetectorRef.markForCheck();
    }
  }

  /*void onVacancySearch() async {
    if ((!dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) &&
        (!procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.isEmpty) &&
        (!shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.isEmpty)) {
      if (listDaysOfWeekOfDentist.contains(DateFormat('EEEE')
          .format(dateAppointmentScheduling.asUtcTime())
          .toUpperCase())) {
        listQuantityPerShiftByDayOfWeek =
            await dentistQuantityPerShiftByDayOfWeekService
                .returnQuantityPerShiftByDayOfWeekListByDentistId(
                    dentistDropdownSelectComponentRef.instance
                        .singleSelectModelDentist.selectedValues.first.id);

        listQuantityPerShiftByDayOfWeek
            .forEach((quantityPerShiftByDayOfWeek) async {
          if ((DateFormat('EEEE')
                      .format(dateAppointmentScheduling.asUtcTime())
                      .toUpperCase() ==
                  quantityPerShiftByDayOfWeek["dayOfWeek"].toUpperCase()) &&
              (shiftDropdownSelectComponentRef.instance.singleSelectModelShift
                      .selectedValues.first.id ==
                  quantityPerShiftByDayOfWeek["shiftId"])) {
            int quantityScheduled = await appointmentSchedulingService
                .returnQuantityAppointmentSchedulingByFilterFromDataBase({
              "dateAppointmentScheduling": new DateFormat('yyyy-MM-dd')
                  .format(dateAppointmentScheduling.asUtcTime()),
              "dentistId": dentistDropdownSelectComponentRef
                  .instance.singleSelectModelDentist.selectedValues.first.id,
              "shiftId": shiftDropdownSelectComponentRef
                  .instance.singleSelectModelShift.selectedValues.first.id
            });

            if (quantityScheduled < quantityPerShiftByDayOfWeek["quantity"]) {
              disabledButtonSave = false;
              vacancyMessage = "Temos " +
                  (quantityPerShiftByDayOfWeek["quantity"] - quantityScheduled)
                      .toString() +
                  " vagas";
            } else {
              disabledButtonSave = true;
              vacancyMessage = "Infelizmente não temos vagas";
            }

            _changeDetectorRef.markForCheck();
          }
        });
      } else {
        disabledButtonSave = true;
        vacancyMessage = "Infelizmente não temos vagas para este dia.";
      }
    } else {
      disabledButtonSave = true;
      vacancyMessage = "Preencha todos os campos";
    }
    _changeDetectorRef.markForCheck();
  }*/

  Future<Map<String, String>>
      returnDaysOfWeekListByDentistProcedureIdMap() async {
    Map<String, String> _list = new Map<String, String>();

    if (!autoAppointmentSchedulingService
        .autoAppointmentScheduling.id.isEmpty) {
      return _list;
    }

    if ((dentistDropdownSelectComponentRef == null) ||
        (procedureDropdownSelectComponentRef == null)) {
      return _list;
    }

    if ((!dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) &&
        (!procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.isEmpty)) {
      dentistProcedureByDayOfWeekService
          .clearAllDentistProcedureByDayOfWeekList();
      await dentistProcedureByDayOfWeekService
          .getAllDentistProcedureByDayOfWeekAcives();
      await dentistProcedureByDayOfWeekService
          .returnDaysOfWeekListByDentistProcedureId(
              (await dentistProcedureService
                      .getOneDentistProcedureByFilterFromList({
        "dentistId": dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.first.id,
        "procedureId": procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.first.id
      }))
                  .id)
          .then((daysOfWeekOfDentistById) {
        _list = daysOfWeekOfDentistById;
        daysOfWeekOfDentistById.forEach((key, value) {
          if (value.toUpperCase() ==
              DateFormat('EEEE')
                  .format(dateAppointmentScheduling.asUtcTime())
                  .toUpperCase()) {
            shiftDropdownSelectComponentRef
                .instance.dentistProcedureByDayOfWeekId = key;
          }
        });
      });
    }

    if (_list == null) {
      _list = new Map<String, String>();
    }

    return _list;
  }

  void onSelectDentistSelectDropdown() async {
    await listAvailableTimes();
    if (!dentistDropdownSelectComponentRef
        .instance.singleSelectModelProcedure.selectedValues.isEmpty) {
      if (!agreementDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.isEmpty) {
        agreementDropdownSelectComponentRef.instance.singleSelectModelDentist
            ?.deselect(agreementDropdownSelectComponentRef
                .instance.singleSelectModelDentist?.selectedValues?.first);
      }

      await dentistAgreementService
          .returnAgreementIdListByDentistId(dentistDropdownSelectComponentRef
              .instance.singleSelectModelProcedure.selectedValues.first.id)
          .then((lisAgreementId) {
        if (autoAppointmentSchedulingService
            .autoAppointmentScheduling.id.isEmpty) {
          agreementDropdownSelectComponentRef.instance.disabled = false;
        }

        agreementDropdownSelectComponentRef.instance.listAgreementIdToShow =
            lisAgreementId;
      });
      _changeDetectorRef.markForCheck();
    }

    await returnDaysOfWeekListByDentistProcedureIdMap()
        .then((daysOfWeekOfDentistById) {
      if (daysOfWeekOfDentistById.isEmpty) {
        return;
      }

      listDaysOfWeekOfDentist.clear();
      daysOfWeekOfDentistById.values.toList().reversed.forEach((dayOfWeek) {
        listDaysOfWeekOfDentist.add(dayOfWeek.toUpperCase());
      });

      listDaysOfWeekOfAppointment = "";
      if (!listDaysOfWeekOfDentist.isEmpty) {
        querySelector("#sub-title-days-of-week").style.display = "none";
        listDaysOfWeekOfDentist.forEach((dayOfWeek) {
          listDaysOfWeekOfAppointment = listDaysOfWeekOfAppointment + dayOfWeek;
          if (dayOfWeek != listDaysOfWeekOfDentist.last) {
            listDaysOfWeekOfAppointment = listDaysOfWeekOfAppointment + ' -- ';
          }
        });
      } else {
        querySelector("#sub-title-days-of-week").style.display = "block";
      }

      if (autoAppointmentSchedulingService
          .autoAppointmentScheduling.id.isEmpty) {
        shiftDropdownSelectComponentRef.instance.showAvailableShifts = true;
      }
    });
  }

  void onSelectShiftSelectDropdown() async {
    if (!shiftDropdownSelectComponentRef
        .instance.singleSelectModelShift.selectedValues.isEmpty) {
      await listAvailableTimes();

      if (autoAppointmentSchedulingService
          .autoAppointmentScheduling.id.isEmpty) {
        List<Map> list = periodByShiftByDayOfWeekService
            .getPeriodByShiftByDayOfWeekListWithFilterFromList({
          "shiftId": shiftDropdownSelectComponentRef
              .instance.singleSelectModelShift.selectedValues.first.id,
          "dayOfWeek": DateFormat('EEEE')
              .format(dateAppointmentScheduling.asUtcTime())
              .toUpperCase()
        });

        if (list.length == 0) {
          shiftObservation = (await shiftService.getShiftById(
                  shiftDropdownSelectComponentRef
                      .instance.singleSelectModelShift.selectedValues.first.id))
              .observation;
        } else {
          shiftObservation = periodByShiftByDayOfWeekService
              .turnMapInPeriodByShiftByDayOfWeek(list.first)
              .description;
        }
      }
    } else {
      shiftObservation = "";
    }
  }

  void onSelectAvailableTimesSelectDropdown() {
    if (!autoAppointmentSchedulingService
        .autoAppointmentScheduling.id.isEmpty) {
      return;
    }

    disabledButtonSave = availableTimesDropdownSelectComponentRef
        .instance.singleSelectModelAvailableTimes.selectedValues.isEmpty;
  }

  void listAvailableTimes() async {
    if (!autoAppointmentSchedulingService
        .autoAppointmentScheduling.id.isEmpty) {
      return;
    }

    if ((!shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.isEmpty) &&
        (!procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.isEmpty)) {
      availableTimesDropdownSelectComponentRef.instance.shiftId =
          shiftDropdownSelectComponentRef
              .instance.singleSelectModelShift.selectedValues.first.id;
      availableTimesDropdownSelectComponentRef.instance.dentistId =
          dentistDropdownSelectComponentRef
              .instance.singleSelectModelDentist.selectedValues.first.id;
      availableTimesDropdownSelectComponentRef.instance.date =
          dateAppointmentScheduling;
      availableTimesDropdownSelectComponentRef.instance.showAvailableTimes =
          true;
      availableTimesDropdownSelectComponentRef.instance.disabled = false;
    } else {
      availableTimesDropdownSelectComponentRef.instance.showAvailableTimes =
          false;
      availableTimesDropdownSelectComponentRef.instance.disabled = true;
    }
  }

  void listRequirementList(String procedureId) async {
    querySelector("#sub-title-requirement").style.display = "block";

    clearListComponentRef(listComponentRefProcedureRequirement);

    await procedureRequirementService
        .getProcedureRequirementListWithFilterFromList(
            {"procedureId": procedureId}).forEach((requirement) {
      querySelector("#sub-title-requirement").style.display = "none";

      requirementService.requirement = requirementService.turnMapInRequirement(
          (requirementService.getRequirementListWithFilterFromList(
                  {"requirementId": requirement["requirementId"].toString()}))
              .first);

      ComponentFactory<
              procedure_requirement_checkbox_component
                  .ProcedureRequirementCheckboxComponent>
          procedureRequirementComponent =
          procedure_requirement_checkbox_component
              .ProcedureRequirementCheckboxComponentNgFactory;

      procedureRequirementCheckboxComponentRef = _loader.loadNextToLocation(
          procedureRequirementComponent,
          materialContainerProcedureRequirementCheckBox);

      procedureRequirementCheckboxComponentRef.instance.procedureId =
          procedureId;
      procedureRequirementCheckboxComponentRef.instance.requirementId =
          requirementService.requirement.id;
      procedureRequirementCheckboxComponentRef.instance.requirement =
          requirementService.requirement.description;
      procedureRequirementCheckboxComponentRef.instance.checkedColor =
          "#DB3813";
      procedureRequirementCheckboxComponentRef.instance.loadCheckedById = false;
      procedureRequirementCheckboxComponentRef.instance.checked = false;

      listComponentRefProcedureRequirement
          .add(procedureRequirementCheckboxComponentRef);

      _changeDetectorRef.markForCheck();
    });
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

    if (autoAppointmentSchedulingService.autoAppointmentScheduling.id.isEmpty) {
      if (!availableTimesDropdownSelectComponentRef
          .instance.singleSelectModelAvailableTimes.selectedValues.isEmpty) {
        availableTimesDropdownSelectComponentRef
            .instance.singleSelectModelAvailableTimes
            ?.deselect(availableTimesDropdownSelectComponentRef.instance
                .singleSelectModelAvailableTimes?.selectedValues?.first);
      }
    }

    telephoneMask.number = '';

    componentRef.destroy();
  }

  bool asserts() {
    if (dateAppointmentScheduling == null) {
      return false;
    }

    return true;
  }

  void onDismissSuccessfullySave() async {
    showSuccessfullySave = false;
    await querySelector('#bt-refresh').click();
    onClose();
    _changeDetectorRef.markForCheck();
  }

  void onDismissNotSuccessfullySave() {
    showSuccessfullySave = false;
    _changeDetectorRef.markForCheck();
  }

  void onDismissAssertMessage() {
    showAssertMessageSave = false;
    showAssertMessageSaveIvalidDate = false;
    _changeDetectorRef.markForCheck();
  }

  void onAssertsSave() async {
    if (disabledButtonSave) return;

    disabledButtonSave = true;
    saveButtonMessage = "GRAVANDO...";
    _changeDetectorRef.markForCheck();

    if ((await autoAppointmentSchedulingConfigurationService
            .getAllConfiguration())
        .invalidDates
        .contains(new DateFormat("yyyy-MM-dd")
            .format(dateAppointmentScheduling.asUtcTime()))) {
      showAssertMessageSaveIvalidDate = true;
      _changeDetectorRef.markForCheck();

      saveButtonMessage = "GRAVAR AGENDAMENTO";
      disabledButtonSave = false;
      return;
    }

    if (autoAppointmentSchedulingService.autoAppointmentScheduling.id.isEmpty) {
      if (availableTimesDropdownSelectComponentRef
          .instance.singleSelectModelAvailableTimes.selectedValues.isEmpty) {
        showAssertMessageSave = true;
        _changeDetectorRef.markForCheck();

        saveButtonMessage = "GRAVAR AGENDAMENTO";
        disabledButtonSave = false;
        return;
      }
    }

    if ((dentistDropdownSelectComponentRef
            .instance.singleSelectModelDentist.selectedValues.isEmpty) ||
        (procedureDropdownSelectComponentRef
            .instance.singleSelectModelProcedure.selectedValues.isEmpty) ||
        (shiftDropdownSelectComponentRef
            .instance.singleSelectModelShift.selectedValues.isEmpty) ||
        (agreementDropdownSelectComponentRef
            .instance.singleSelectModelAgreement.selectedValues.isEmpty) ||
        ((telephoneMask.number == '') &&
            (autoAppointmentSchedulingService
                .autoAppointmentScheduling.email.isEmpty)) ||
        (dateAppointmentScheduling == null)) {
      showAssertMessageSave = true;
      _changeDetectorRef.markForCheck();

      saveButtonMessage = "GRAVAR AGENDAMENTO";
      disabledButtonSave = false;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;
  }

  void onSave() async {
    Map<bool, String> result = new Map<bool, String>();

    showAssertMessageAlert = false;

    autoAppointmentSchedulingService
            .autoAppointmentScheduling.dateAppointmentScheduling =
        new DateFormat('yyyy-MM-dd')
            .format(dateAppointmentScheduling.asUtcTime());

    autoAppointmentSchedulingService.autoAppointmentScheduling.patient =
        patientAccountService.patientAccount.name;

    autoAppointmentSchedulingService.autoAppointmentScheduling
        .patientAccountId = patientAccountService.patientAccount.id;

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

    if (autoAppointmentSchedulingService.autoAppointmentScheduling.id.isEmpty) {
      autoAppointmentSchedulingService.autoAppointmentScheduling.horary =
          availableTimesDropdownSelectComponentRef.instance
              .singleSelectModelAvailableTimes.selectedValues.first.description;
    }

    result = (await autoAppointmentSchedulingService.save());
    if (result.keys.first) {
      emailSenderHTTP = await new EmailSenderService(new Email(
              CLINIC_EMAIL,
              autoAppointmentSchedulingService.autoAppointmentScheduling.email,
              "Consulta marcada na Cl&iacute;nica Odontol&oacute;gica Bambi",
              '''
                  <div 
                    style=" font-family:Arial, Helvetica, sans-serif; 
                    font-size: 22px; 
                    font-weight: 600;
                    color:#666666;">
                    Ol&aacute; ''' +
                  autoAppointmentSchedulingService
                      .autoAppointmentScheduling.patient +
                  ''', sua consulta foi marcada!
                  </div>
                  <div 
                    style=" font-family:Arial, Helvetica, sans-serif; 
                    font-size: 16px; 
                    font-weight: 600;
                    color:#888888;">
                    <p>Esta &eacute; apenas uma mensagem autom&aacute;tica, por favor n&atilde;o responda.</p>
                    </p>
                    <p>Data da Consulta: ''' +
                  new DateFormat('dd/MM/yyyy')
                      .format(dateAppointmentScheduling.asUtcTime()) +
                  '''</p>
                  <p>Turno: ''' +
                  shiftDropdownSelectComponentRef
                      .instance
                      .singleSelectModelShift
                      .selectedValues
                      .first
                      .uiDisplayName +
                  '''</p>
                    <p>Dentista: ''' +
                  dentistDropdownSelectComponentRef
                      .instance
                      .singleSelectModelDentist
                      .selectedValues
                      .first
                      .uiDisplayName +
                  '''</p>
                    <p>Procedimento: ''' +
                  procedureDropdownSelectComponentRef
                      .instance
                      .singleSelectModelProcedure
                      .selectedValues
                      .first
                      .uiDisplayName +
                  '''</p>
                    <p>Conv&ecirc;nio: ''' +
                  agreementDropdownSelectComponentRef
                      .instance
                      .singleSelectModelAgreement
                      .selectedValues
                      .first
                      .uiDisplayName +
                  '''</p>
                  </div>
              ''',
              null,
              null))
          .emailSenderGmail(); //emailSenderAmazon();

      emailSenderHTTP.sendEmail();

      showSuccessfullySave = true;
    } else {
      if (result.values.first == "duplicidade") {
        showAssertMessageSaveIvalidDate = true;
      } else {
        showNotSuccessfullySave = true;
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
