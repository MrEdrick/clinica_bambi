import 'dart:async';
import 'dart:html';
import 'package:ClinicaBambi/src/appointment/dentist/dentist_service.dart';
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

import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_list_component.template.dart'
    as appointment_scheduling_list;
import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_edit_component.template.dart'
    as appointment_scheduling_edit;

import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_dropdown_select_component.template.dart'
    as dentist_dropdown_select_list_component;
import 'package:ClinicaBambi/src/deshboard_appointment/shift/shift_dropdown_select_component.template.dart'
    as shift_dropdown_select_list_component;

import '../../appointment/user/user_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';

@Component(
  selector: 'appointment_scheduling_filter_component',
  templateUrl: 'appointment_scheduling_filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
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
    'appointment_scheduling_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AppointmentSchedulingFilterComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  final List<ComponentRef> listComponentRef = new List<ComponentRef>();
  final List<ComponentRef> listComponentRefDropdownSelect =
      new List<ComponentRef>();

  ComponentRef dentistDropdownSelectComponentRef;
  ComponentRef shiftDropdownSelectComponentRef;

  final DentistService dentistService = new DentistService();
  final ShiftService shiftService = new ShiftService();

  AppointmentSchedulingService _appointmentSchedulingService =
      new AppointmentSchedulingService();

  AppointmentSchedulingService get appointmentSchedulingService =>
      _appointmentSchedulingService;
  set appointmentSchedulingService(
          AppointmentSchedulingService appointmentSchedulingService) =>
      _appointmentSchedulingService = appointmentSchedulingService;

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

  @ViewChild('containerListAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  @ViewChild('dentistDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerDentistDropdownSelect;

  @ViewChild('shiftDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerShiftDropdownSelect;

  AppointmentSchedulingFilterComponent(this._loader, this._changeDetectorRef);

  void clearListComponentRef(List<ComponentRef> listComponentRef) {
    listComponentRef.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRef.clear();
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await dentistService.getAllDentistAcives();
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
            shift_dropdown_select_list_component.ShiftDropdownSelectComponent>
        shiftDropdownSelectComponent = shift_dropdown_select_list_component
            .ShiftDropdownSelectComponentNgFactory;

    shiftDropdownSelectComponentRef = _loader.loadNextToLocation(
        shiftDropdownSelectComponent, materialContainerShiftDropdownSelect);

    listComponentRefDropdownSelect.add(shiftDropdownSelectComponentRef);

    _changeDetectorRef.markForCheck();

    await onFilter();
  }

  void onLoad() {
    listDate.forEach((date) {
      ComponentFactory<
              appointment_scheduling_list.AppointmentSchedulingListComponent>
          appointmentSchedulingList = appointment_scheduling_list
              .AppointmentSchedulingListComponentNgFactory;

      ComponentRef appointmentSchedulingListComponent = _loader
          .loadNextToLocation(appointmentSchedulingList, materialContainerList);

      appointmentSchedulingListComponent.instance.date = date;
      appointmentSchedulingListComponent.instance.componentRef =
          appointmentSchedulingListComponent;

      listComponentRef.add(appointmentSchedulingListComponent);
    });

    _changeDetectorRef.markForCheck();
  }

  List<Date> onPrepareFilter() {
    if (finalDate.isBefore(initialDate)) {
      finalDate = initialDate;
    }

    querySelector('#appointment-scheduling-result-filter-text')
        .setInnerHtml('0');

    initialDateFormated =
        new DateFormat('dd/MM/yyyy').format(initialDate.asUtcTime());
    finalDateFormated =
        new DateFormat('dd/MM/yyyy').format(finalDate.asUtcTime());

    daysDif = finalDate.asUtcTime().difference(initialDate.asUtcTime()).inDays;

    if (!dentistDropdownSelectComponentRef
        .instance.singleSelectModelDentist.selectedValues.isEmpty) {
      dentistName = dentistDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.first.name;
      dentistId = dentistDropdownSelectComponentRef
          .instance.singleSelectModelDentist.selectedValues.first.id;
    } else {
      dentistName = '';
      dentistId = '';
    }

    if (!shiftDropdownSelectComponentRef
        .instance.singleSelectModelShift.selectedValues.isEmpty) {
      shiftDescription = shiftDropdownSelectComponentRef
          .instance.singleSelectModelShift.selectedValues.first.description;
      shiftId = shiftDropdownSelectComponentRef
          .instance.singleSelectModelShift.selectedValues.first.id;
    } else {
      shiftDescription = '';
      shiftId = '';
    }

    listDate.clear();
    for (var i = 0; i <= daysDif; i++) {
      listDate.add(initialDate.add(days: i));
    }

    return listDate;
  }

  Future<void> onFilter() async {
    clearListComponentRef(listComponentRef);

    listDate = onPrepareFilter();

    new AppointmentSchedulingService().clearAllAppointmentSchedulingByDate();

    await listDate.forEach((date) async {
      int total = 0;
      var total_aux;

      await new AppointmentSchedulingService()
          .getAllAppointmentSchedulingByDateMap(date)
          .then((onValue) {
        total_aux = (new AppointmentSchedulingService()
                .getAppointmentSchedulingWithFilterFromList(date.toString(), {
          "dentistId": dentistId,
          "shiftId": shiftId,
          "patient": patientName
        }))
            ?.length;

        total += total_aux == null ? 0 : total_aux;

        if (listDate.last == date) {
          onLoad();

          querySelector('#appointment-scheduling-result-filter-text')
              .setInnerHtml(total.toString());
        }
      });
    });

    return;
  }

  void onAdd() {
    appointmentSchedulingService.appointmentScheduling = null;

    ComponentFactory<
            appointment_scheduling_edit.AppointmentSchedulingEditComponent>
        appointmentSchedulingEdit =
        appointment_scheduling_edit.AppointmentSchedulingEditComponentNgFactory;

    ComponentRef appointmentSchedulingEditComponent = _loader
        .loadNextToLocation(appointmentSchedulingEdit, materialContainerAdd);

    appointmentSchedulingEditComponent.instance.componentRef =
        appointmentSchedulingEditComponent;
  }

  void onClear() {
    if (!dentistDropdownSelectComponentRef
        .instance.singleSelectModelDentist.selectedValues.isEmpty) {
      dentistDropdownSelectComponentRef.instance.singleSelectModelDentist
          ?.deselect(dentistDropdownSelectComponentRef
              .instance.singleSelectModelDentist?.selectedValues?.first);
    }

    if (!shiftDropdownSelectComponentRef
        .instance.singleSelectModelShift.selectedValues.isEmpty) {
      shiftDropdownSelectComponentRef.instance.singleSelectModelShift?.deselect(
          shiftDropdownSelectComponentRef
              .instance.singleSelectModelShift?.selectedValues?.first);
    }

    initialDate = new Date.today();
    finalDate = new Date.today();

    initialDateFormated = '';
    finalDateFormated = '';
    dentistName = '';
    shiftDescription = '';

    patientName = '';
  }
}
