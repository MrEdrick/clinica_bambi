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

import 'package:ClinicaBambi/src/deshboard_autoAppointment/autoAppointment_scheduling/autoAppointment_scheduling_list_card_component.template.dart'
    as autoAppointment_scheduling_list;
import 'package:ClinicaBambi/src/deshboard_autoAppointment/autoAppointment_scheduling/autoAppointment_scheduling_edit_component.template.dart'
    as autoAppointment_scheduling_edit;

import '../../appointment/user/user_service.dart';

import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';

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
    'autoAppointment_scheduling_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AutoAppointmentSchedulingFilterComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final List<ComponentRef> listComponentRef = new List<ComponentRef>();

  AutoAppointmentSchedulingService _autoAppointmentSchedulingService = new AutoAppointmentSchedulingService();

  AutoAppointmentSchedulingService get autoAppointmentSchedulingService => _autoAppointmentSchedulingService;
  set autoAppointmentSchedulingService(AutoAppointmentSchedulingService autoAppointmentSchedulingService) =>
      _autoAppointmentSchedulingService = autoAppointmentSchedulingService;

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

  @ViewChild('containerEditAutoAppointmentscheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  List<List<Map<String, dynamic>>> listScheduling =
      new List<List<Map<String, dynamic>>>();
  final List<AutoAppointmentScheduling> listAutoAppointmentSchedulingByDate = new List<AutoAppointmentScheduling>();

  int totalResultFilter = 0;

  AutoAppointmentSchedulingFilterComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await onFilter();
  }

  void onLoad() {
    listComponentRef.clear();
    listDate.forEach((date) {
      ComponentFactory<autoAppointment_scheduling_list.AutoAutoAppointmentSchedulingAutoAppointmentSchedulingListCardComponent>
          autoAppointmentSchedulingList =
          autoAppointment_scheduling_list.AutoAppointmentSchedulingListCardComponentNgFactory;

      ComponentRef autoAppointmentSchedulingListComponent =
          _loader.loadNextToLocation(autoAppointmentSchedulingList, materialContainerList);

      autoAppointmentSchedulingListComponent.instance.date = date;
      autoAppointmentSchedulingListComponent.instance.componentRef = autoAppointmentSchedulingListComponent;
      listComponentRef.add(autoAppointmentSchedulingListComponent);
    });

    _changeDetectorRef.markForCheck();
  }

  List<Date> onPrepareFilter() {
    if (finalDate.isBefore(initialDate)) {
      finalDate = initialDate;
    }

    querySelector('#autoAppointment-scheduling-result-filter-text').setInnerHtml('0');

    initialDateFormated =
        new DateFormat('dd/MM/yyyy').format(initialDate.asUtcTime());
    finalDateFormated =
        new DateFormat('dd/MM/yyyy').format(finalDate.asUtcTime());

    daysDif = finalDate.asUtcTime().difference(initialDate.asUtcTime()).inDays;

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

    new AutoAppointmentSchedulingService().clearAllAutoAppointmentSchedulingByDate();

    await listDate.forEach((date) async {
      int total = 0;

      new AutoAppointmentSchedulingService()
          .getAllAutoAppointmentSchedulingByDateMap(date)
          .then((onValue) {
        total += (new AutoAppointmentSchedulingService().getAutoAppointmentSchedulingWithFilterFromList(
            date.toString(), {
          "dentistId": dentistId,
          "shiftId": shiftId,
          "patient": patientName
        })).length;

        if (listDate.last == date) {
          onLoad();

          querySelector('#autoAppointment-scheduling-result-filter-text')
              .setInnerHtml(total.toString());
        }
      });
    });
    return;
  }

  void onAdd() {
    autoAppointmentSchedulingService.autoAppointmentScheduling = null;
    ComponentFactory<autoAppointment_scheduling_edit.AutoAppointmentschedulingEditComponent>
        autoAppointmentSchedulingEdit = autoAppointment_scheduling_edit.AutoAppointmentSchedulingEditComponentNgFactory;

    ComponentRef autoAppointmentSchedulingEditComponent =
        _loader.loadNextToLocation(autoAppointmentSchedulingEdit, materialContainerAdd);
    autoAppointmentSchedulingEditComponent.instance.componentRef = autoAppointmentSchedulingEditComponent;
  }

  void onClear() {
    initialDate = new Date.today();
    finalDate = new Date.today();

    initialDateFormated = '';
    finalDateFormated = '';
    dentistName = '';
    shiftDescription = '';

    patientName = '';
  }
}