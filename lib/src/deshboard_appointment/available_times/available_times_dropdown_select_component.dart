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

  String availableTimesObservation = "";

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    if ((_listAvailableTimes == null) || (_listAvailableTimes?.length == 0)) {
      _disabled = true;
    } else {
      _disabled = disabled;
    }

    _changeDetectorRef.markForCheck();
  }

  bool _showAvailableTimes = false;
  @Input()
  set showAvailableTimes(bool showAvailableTimes) {
    _showAvailableTimes = showAvailableTimes;

    if (!showAvailableTimes) {
      shiftId = '';
      dentistId = '';
    }

    listAvailableTimes();
  }

  final List<AvailableTimesUI> _listAvailableTimes =
      new List<AvailableTimesUI>();
  final AvailableTimesService _availableTimesService =
      new AvailableTimesService();

  bool useItemRenderer = false;

  static ItemRenderer<AvailableTimesUI> _displayNameRenderer =
      (HasUIDisplayName item) => item?.uiDisplayName;

  static ItemRenderer<AvailableTimesUI> _itemRendererAvailableTimes =
      newCachingItemRenderer<AvailableTimesUI>(
          (availableTimes) => "${availableTimes?.uiDisplayName}");

  ItemRenderer<AvailableTimesUI> get itemRendererAvailableTimes =>
      useItemRenderer ? _itemRendererAvailableTimes : _displayNameRenderer;

  AvailableTimesSelectionOptions<AvailableTimesUI> availableTimesListOptions;

  StringSelectionOptions<AvailableTimesUI> get availableTimesOptions {
    if ((_listAvailableTimes == null) || (_listAvailableTimes?.length == 0)) {
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
      singleSelectModelAvailableTimes?.selectedValues == null
          ? '  '
          : singleSelectModelAvailableTimes?.selectedValues?.length > 0
              ? itemRendererAvailableTimes(
                  singleSelectModelAvailableTimes?.selectedValues?.first)
              : 'Horários Disponíveis';

  String get singleSelectedAvailableTimes => singleSelectModelAvailableTimes
          ?.selectedValues?.isNotEmpty
      ? singleSelectModelAvailableTimes?.selectedValues?.first?.uiDisplayName
      : null;

  @Output()
  Stream get selectionChanges {
    return singleSelectModelAvailableTimes.selectionChanges;
  }

  AvailableTimesDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    await listAvailableTimes();
  }

  void listAvailableTimes() async {
    _listAvailableTimes.clear();
    _availableTimesService.clearAllAvailableTimesList();

    if ((shiftId == null) || (dentistId == null) || (date == null)) {
      return;
    }

    availableTimesObservation = "Buscando...";
    _changeDetectorRef.markForCheck();

    await _availableTimesService
        .getAllAvailableTimesUIAcives(shiftId, dentistId, date)
        .then((_list) {
      _list.forEach((avaliableTime) {
        _listAvailableTimes.add(avaliableTime);
      });

      if (_listAvailableTimes.length > 0) {
        _disabled = false;
      } else {
        _disabled = true;
      }

      availableTimesObservation = "";
      _changeDetectorRef.markForCheck();
    });
  }
}
