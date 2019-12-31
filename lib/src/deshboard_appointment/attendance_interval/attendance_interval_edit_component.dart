import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/interval/intervalUI.dart';
import '../../appointment/interval/interval_service.dart';
import '../../appointment/attendance_interval/attendance_interval.dart';
import '../../appointment/attendance_interval/attendance_interval_service.dart';

import 'package:ClinicaBambi/src/deshboard_appointment/interval/interval_dropdown_select_component.template.dart'
    as interval_dropdown_select_list_component;

@Component(
    selector: 'attendance_interval_edit_component',
    styleUrls: const [
      'attendance_interval_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'attendance_interval_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
    ],
    providers: [windowBindings, datepickerBindings])
class AttendanceIntervalEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final List<ComponentRef> listComponentRefDropdownSelect =
      new List<ComponentRef>();

  final AttendanceIntervalService attendanceIntervalService =
      new AttendanceIntervalService();
  final IntervalService intervalService = new IntervalService();

  @Input()
  String shiftId;

  @Input()
  String shiftDescription;

  @Input()
  int startTime;

  @Input()
  int endTime;

  @Input()
  String dentistId;

  ComponentRef intervalDropdownSelectComponentRef;

  @ViewChild('intervalDropdownSelect', read: ViewContainerRef)
  ViewContainerRef materialContainerIntervalDropdownSelect;

  AttendanceIntervalEditComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await intervalService.getAllIntervalAcives();

    clearListComponentRef(listComponentRefDropdownSelect);

    ComponentFactory<
        interval_dropdown_select_list_component
            .IntervalDropdownSelectComponent> intervalDropdownSelectComponent;

    intervalDropdownSelectComponent = interval_dropdown_select_list_component
        .IntervalDropdownSelectComponentNgFactory;

    intervalDropdownSelectComponentRef = _loader.loadNextToLocation(
        intervalDropdownSelectComponent,
        materialContainerIntervalDropdownSelect);

    listComponentRefDropdownSelect.add(intervalDropdownSelectComponentRef);

    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    if (attendanceIntervalService.attendanceInterval.intervalId != null) {
      intervalDropdownSelectComponentRef.instance.singleSelectModelInterval
          .select(new IntervalUI(
              attendanceIntervalService.attendanceInterval.intervalId,
              attendanceIntervalService.attendanceInterval.interval.time
                  .toString()));
    }
  }

  void clearListComponentRef(List<ComponentRef> listComponentRef) {
    listComponentRef.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRef.clear();
  }
}
