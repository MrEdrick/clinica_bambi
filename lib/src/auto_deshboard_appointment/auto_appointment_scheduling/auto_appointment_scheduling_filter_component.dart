import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:intl/intl.dart';

import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_list_component.template.dart'
    as auto_appointment_scheduling_list;
import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_edit_component.template.dart'
    as auto_appointment_scheduling_edit;

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift/shift_dropdown_select_component.template.dart'
    as shift_dropdown_select_list_component;

import '../../appointment/user/user_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/patient_account/patient_account_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling.dart';

@Component(
  selector: 'auto_appointment_scheduling_filter_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'auto_appointment_scheduling_filter_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialDatepickerComponent,
    DateRangeInputComponent,
    MaterialDropdownSelectComponent,
    MultiDropdownSelectValueAccessor,
    MaterialFabComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'auto_appointment_scheduling_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AutoAppointmentSchedulingFilterComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  final List<ComponentRef> listComponentRef = new List<ComponentRef>();
  final List<ComponentRef> listComponentRefDropdownSelect =
      new List<ComponentRef>();

  final DentistService dentistService = new DentistService();
  final ShiftService shiftService = new ShiftService();
  final AgreementService agreementService = new AgreementService();

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;

  final AutoAppointmentSchedulingService autoAppointmentSchedulingService =
      new AutoAppointmentSchedulingService();
  final PatientAccountService patientAccountService =
      new PatientAccountService();

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  Date initialDate = new Date.today();
  Date finalDate = new Date.today();
  List<Date> listDate = new List<Date>();

  String initialDateFormated;
  String finalDateFormated;

  int daysDif = 1;

  String shiftDescription;
  String shiftId;

  String dentistName;
  String dentistId;

  String patientName;

  @ViewChild('containerListAutoAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditAutoAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  @ViewChild('dentistDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistDropdownSelect;

  @ViewChild('shiftDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerShiftDropdownSelect;

  List<List<Map<String, dynamic>>> listScheduling =
      new List<List<Map<String, dynamic>>>();
  final List<AutoAppointmentScheduling> listAutoAppointmentSchedulingByDate =
      new List<AutoAppointmentScheduling>();

  int totalResultFilter = 0;

  AutoAppointmentSchedulingFilterComponent(
      this._loader, this._changeDetectorRef);

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
    await shiftService.getAllShiftAcives();
    await agreementService.getAllAgreementAcives();

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
            shift_dropdown_select_list_component.ShiftDropdownSelectComponent>
        shiftDropdownSelectComponent = shift_dropdown_select_list_component
            .ShiftDropdownSelectComponentNgFactory;

    shiftDropdownSelectComponentRef = _loader.loadNextToLocation(
        shiftDropdownSelectComponent, materialContainerShiftDropdownSelect);

    listComponentRefDropdownSelect.add(shiftDropdownSelectComponentRef);

    _changeDetectorRef.markForCheck();

    await onFilter(false);
  }

  void onLoad() {
    listDate.forEach((date) {
      List<Map> _list = autoAppointmentSchedulingService
          .getAutoAppointmentSchedulingFromListWithFilterByPatientAccountIdDate(
              patientAccountService.patientAccount.id, date);
      if (_list.length > 0) {
        ComponentFactory<
                auto_appointment_scheduling_list
                    .AutoAppointmentSchedulingListComponent>
            autoAppointmentSchedulingList = auto_appointment_scheduling_list
                .AutoAppointmentSchedulingListComponentNgFactory;

        ComponentRef autoAppointmentSchedulingListComponent =
            _loader.loadNextToLocation(
                autoAppointmentSchedulingList, materialContainerList);

        autoAppointmentSchedulingListComponent.instance.date = date;
        autoAppointmentSchedulingListComponent.instance.list = _list;
        autoAppointmentSchedulingListComponent.instance.componentRef =
            autoAppointmentSchedulingListComponent;
        listComponentRef.add(autoAppointmentSchedulingListComponent);
      }
    });

    _changeDetectorRef.markForCheck();
  }

  Future<List<Date>> onPrepareFilter(bool toFilterDate) async {
    if (finalDate.isBefore(initialDate)) {
      finalDate = initialDate;
    }
    querySelector('#auto-appointment-scheduling-result-filter-text')
        .setInnerHtml('0');
    listDate.clear();
    if (toFilterDate) {
      initialDateFormated =
          new DateFormat('dd/MM/yyyy').format(initialDate.asUtcTime());
      finalDateFormated =
          new DateFormat('dd/MM/yyyy').format(finalDate.asUtcTime());

      daysDif =
          finalDate.asUtcTime().difference(initialDate.asUtcTime()).inDays;

      for (var i = 0; i <= daysDif; i++) {
        listDate.add(initialDate.add(days: i));
      }

      autoAppointmentSchedulingService.clearAllAutoAppointmentScheduling();
    } else {
      await autoAppointmentSchedulingService
          .getAllAutoAppointmentSchedulingByPatientAccountIdDate(
              patientAccountService.patientAccount.id);
    
      autoAppointmentSchedulingService
          .autoAppointmentSchedulingByPatientAccountId.values
          .forEach((listAutoAppointmentScheduling) {
        listAutoAppointmentScheduling.forEach((autoAppointmentScheduling) {
          if (autoAppointmentScheduling.isNotEmpty) {
            if (!listDate.contains(new Date.parse(
                autoAppointmentScheduling["dateAppointmentScheduling"],
                new DateFormat("yyyy-MM-dd")))) {
              listDate.add(new Date.parse(
                  autoAppointmentScheduling["dateAppointmentScheduling"],
                  new DateFormat("yyyy-MM-dd")));
            }
          }
        });
      });

      listDate.sort();
      listDate = listDate.reversed;
    }
    return listDate;
  }

  Future<void> onFilter(bool toFilterDate) async {
    clearListComponentRef(listComponentRef);

    listDate = await onPrepareFilter(toFilterDate);

    listDate = listDate.toList();

    await listDate.forEach((date) async {
      int total = 0;
      var total_aux;
      
      autoAppointmentSchedulingService
          .getAllAutoAppointmentSchedulingByPatientAccountIdDateMap(
              patientAccountService.patientAccount.id, date)
          .then((onValue) {
        
        total_aux = (autoAppointmentSchedulingService
                .getAutoAppointmentSchedulingWithFilterFromList(
                    patientAccountService.patientAccount.id, date, {
          "dentistId": dentistId,
          "shiftId": shiftId,
          "patient": patientName
        }))
            ?.length;
            
        total += total_aux == null ? 0 : total_aux;

        if (listDate.last == date) {
          onLoad();

          querySelector('#auto-appointment-scheduling-result-filter-text')
              .setInnerHtml(total.toString());
        }
      });
    });

    return;
  }

  void onAdd() {
    autoAppointmentSchedulingService.autoAppointmentScheduling =
        autoAppointmentSchedulingService.returnEmptyAutoAppointmentScheduling();
    ComponentFactory<
            auto_appointment_scheduling_edit
                .AutoAppointmentSchedulingEditComponent>
        autoAppointmentSchedulingEdit = auto_appointment_scheduling_edit
            .AutoAppointmentSchedulingEditComponentNgFactory;

    ComponentRef autoAppointmentSchedulingEditComponent =
        _loader.loadNextToLocation(
            autoAppointmentSchedulingEdit, materialContainerAdd);
    autoAppointmentSchedulingEditComponent.instance.componentRef =
        autoAppointmentSchedulingEditComponent;
  }

  void onClear() async {
    initialDate = new Date.today();
    finalDate = new Date.today();

    initialDateFormated = '';
    finalDateFormated = '';
    dentistName = '';
    shiftDescription = '';

    patientName = '';

    await onFilter(false);
  }
}
