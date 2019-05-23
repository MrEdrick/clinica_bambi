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
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:intl/intl.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_list_card_component.template.dart'
    as appointment_scheduling_list;
import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_edit_component.template.dart'
    as appointment_scheduling_edit;

import '../../appointment/user/user_service.dart';

import '../../appointment/shift/shift.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/shift/shift_selection_options.dart';

import '../../appointment/dentist/dentistUI.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/dentist/dentist_selection_options.dart';

import '../../appointment/appointment_scheduling/appointment_scheduling.dart';
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
    popupBindings,
    ClassProvider(DentistService),
    ClassProvider(ShiftService)
  ],
  styleUrls: const [
    'appointment_scheduling_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AgendamentoFilterComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final List<ComponentRef> listComponentRef = new List<ComponentRef>();

  AppointmentSchedulingService _appointmentSchedulingService = new AppointmentSchedulingService();

  AppointmentSchedulingService get appointmentSchedulingService => _appointmentSchedulingService;
  set appointmentSchedulingService(AppointmentSchedulingService appointmentSchedulingService) =>
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

  @ViewChild('containerListApoointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditAppointmentscheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  List<List<Map<String, dynamic>>> listScheduling =
      new List<List<Map<String, dynamic>>>();
  final List<AppointmentScheduling> listAppointmentSchedulingByDate = new List<AppointmentScheduling>();

  int totalResultFilter = 0;

  static ItemRenderer<Shift> _displayNameRendererShift =
      (HasUIDisplayName item) => item.uiDisplayName;

  List<Shift> _listShift;
  final ShiftService _shiftService;

  static ItemRenderer<Shift> _itemRendererShift =
      newCachingItemRenderer<Shift>((shift) => "${shift.description}");

  ItemRenderer<Shift> get itemRendererShift =>
      useItemRenderer ? _itemRendererShift : _displayNameRendererShift;

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
      singleSelectModelShift.selectedValues.length > 0
          ? itemRendererShift(singleSelectModelShift.selectedValues.first)
          : 'Turno';

  String get singleSelectedShift {
    if (singleSelectModelShift.selectedValues.isNotEmpty) {
      return singleSelectModelShift.selectedValues.first.uiDisplayName;
    } else {
      return null;
    }
  }

  final SelectionModel<Shift> multiSelectModelShift =
      SelectionModel<Shift>.multi();

  Future<void> _getListShift() async {
    _listShift = await _shiftService.getAllShiftAcives();
  }

  //----
  List<DentistUI> _listDentist;
  final DentistService _dentistService;

  static ItemRenderer<DentistUI> _displayNameRendererDentist =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<DentistUI> _itemRendererDentist =
      newCachingItemRenderer<DentistUI>((dentista) => "${dentista.name}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRendererDentist;

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

  String get singleSelectDentistLabel =>
      singleSelectModelDentist.selectedValues.length > 0
          ? itemRendererDentist(singleSelectModelDentist.selectedValues.first)
          : 'Dentista da consulta';

  String get singleSelectedDentist {
    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      return singleSelectModelDentist.selectedValues.first.uiDisplayName;
    } else {
      return null;
    }
  }

  final SelectionModel<DentistUI> multiSelectModel =
      SelectionModel<DentistUI>.multi();

  Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistUIAcives();
  }

  AgendamentoFilterComponent(this._dentistService, this._shiftService,
      this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    _getListDentist();
    _getListShift();

    await onFilter();
  }

  void onLoad() {
    listComponentRef.clear();
    listDate.forEach((date) {
      ComponentFactory<appointment_scheduling_list.AgendamentoAppointmentSchedulingListCardComponent>
          appointmentSchedulingList =
          appointment_scheduling_list.AppointmentSchedulingListCardComponentNgFactory;

      ComponentRef appointmentSchedulingListComponent =
          _loader.loadNextToLocation(appointmentSchedulingList, materialContainerList);

      appointmentSchedulingListComponent.instance.date = date;
      appointmentSchedulingListComponent.instance.componentRef = appointmentSchedulingListComponent;
      listComponentRef.add(appointmentSchedulingListComponent);
    });

    _changeDetectorRef.markForCheck();
  }

  List<Date> onPrepareFilter() {
    if (finalDate.isBefore(initialDate)) {
      finalDate = initialDate;
    }

    querySelector('#appointment-scheduling-result-filter-text').setInnerHtml('0');

    initialDateFormated =
        new DateFormat('dd/MM/yyyy').format(initialDate.asUtcTime());
    finalDateFormated =
        new DateFormat('dd/MM/yyyy').format(finalDate.asUtcTime());

    daysDif = finalDate.asUtcTime().difference(initialDate.asUtcTime()).inDays;

    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      dentistName = singleSelectModelDentist.selectedValues.first.name;
      dentistId = singleSelectModelDentist.selectedValues.first.id;
    } else {
      dentistId = '';
    }

    if (singleSelectModelShift.selectedValues.isNotEmpty) {
      shiftDescription =
          singleSelectModelShift.selectedValues.first.description;
      shiftId = singleSelectModelShift.selectedValues.first.id;
    } else {
      shiftId = '';
    }

    listDate.clear();
    for (var i = 0; i <= daysDif; i++) {
      listDate.add(initialDate.add(days: i));
    }

    return listDate;
  }

  Future<void> onFilter() async {
    listComponentRef.forEach((componentRef) {
      componentRef.destroy();
    });

    listDate = onPrepareFilter();

    new AppointmentSchedulingService().clearAllAppointmentSchedulingByDate();

    await listDate.forEach((date) async {
      int total = 0;

      new AppointmentSchedulingService()
          .getAllAppointmentSchedulingByDateMap(date)
          .then((onValue) {
        total += (new AppointmentSchedulingService().getAppointmentSchedulingWithFilterFromList(
            date.toString(), {
          "dentistId": dentistId,
          "shiftId": shiftId,
          "patient": patientName
        })).length;

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
    ComponentFactory<appointment_scheduling_edit.AppointmentschedulingEditComponent>
        appointmentSchedulingEdit = appointment_scheduling_edit.AppointmentSchedulingEditComponentNgFactory;

    ComponentRef appointmentSchedulingEditComponent =
        _loader.loadNextToLocation(appointmentSchedulingEdit, materialContainerAdd);
    appointmentSchedulingEditComponent.instance.componentRef = appointmentSchedulingEditComponent;
  }

  void onClear() {
    if (!singleSelectModelDentist.selectedValues.isEmpty) {
      singleSelectModelDentist
          ?.deselect(singleSelectModelDentist?.selectedValues?.first);
    }

    if (!singleSelectModelShift.selectedValues.isEmpty) {
      singleSelectModelShift
          ?.deselect(singleSelectModelShift?.selectedValues?.first);
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
