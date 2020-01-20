import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/available_times/available_timesUI.dart';
import '../../appointment/available_times/available_times_service.dart';
import '../../appointment/available_times/available_times_selection_options.dart';

@Component(
    selector: 'available_times_dropdown_select_component',
    styleUrls: const [
      'available_times_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'available_times_dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor
    ],
    providers: [windowBindings])
class AvailableTimesDropdownSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  ComponentRef componentRef;

  @Input()
  Date date;

  @Input()
  String shiftId;

  @Input()
  String dentistId;

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.markForCheck();
  }

  bool _showAvailableTimes = false;
  @Input()
  set listDentisitIdToShow(bool showAvailableTimes) {
    _showAvailableTimes = showAvailableTimes;
    if (showAvailableTimes) {
      listAvailableTimes();
    }
  }

  List<AvailableTimesUI> _listAvailableTimes;
  final AvailableTimesService _availableTimesService =
      new AvailableTimesService();

  bool useItemRenderer = false;

  static ItemRenderer<AvailableTimesUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<AvailableTimesUI> _itemRendererAvailableTimes =
      newCachingItemRenderer<AvailableTimesUI>(
          (availableTimes) => "${availableTimes.description}");

  ItemRenderer<AvailableTimesUI> get itemRendererAvailableTimes =>
      useItemRenderer ? _itemRendererAvailableTimes : _displayNameRenderer;

  AvailableTimesSelectionOptions<AvailableTimesUI> availableTimesListOptions;

  StringSelectionOptions<AvailableTimesUI> get availableTimesOptions {
    if (_listAvailableTimes == null) {
      return null;
    }

    availableTimesListOptions =
        AvailableTimesSelectionOptions<AvailableTimesUI>(_listAvailableTimes);

    return availableTimesListOptions;
  }

  @Input()
  SelectionModel<AvailableTimesUI> singleSelectModelAvailableTimes =
      SelectionModel.single();

  String get singleSelectAvailableTimesLabel =>
      singleSelectModelAvailableTimes.selectedValues == null
          ? '  '
          : singleSelectModelAvailableTimes.selectedValues.length > 0
              ? itemRendererAvailableTimes(
                  singleSelectModelAvailableTimes.selectedValues.first)
              : 'Horários Disponíveis';

  String get singleSelectedAvailableTimes =>
      singleSelectModelAvailableTimes.selectedValues.isNotEmpty
          ? singleSelectModelAvailableTimes.selectedValues.first.uiDisplayName
          : null;

  @Output()
  Stream get selectionChanges {
    return singleSelectModelAvailableTimes.selectionChanges;
  }

  AvailableTimesDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if ((shiftId == null) || (dentistId == null) || (date == null)) {
      return;
    }

    await listAvailableTimes();
  }

  void listAvailableTimes() async {
    _listAvailableTimes.clear();
    (await _availableTimesService.getAllAvailableTimesByShiftIdDentistId(
            shiftId, dentistId, date))
        .forEach((availableTimes) {
      _listAvailableTimes
          .add(new AvailableTimesUI(availableTimes.time, availableTimes.time));
    });
  }
}
