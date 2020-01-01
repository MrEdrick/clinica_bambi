import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/interval/intervalUI.dart';
import '../../appointment/interval/interval_service.dart';
import '../../appointment/interval/interval_selection_options.dart';

@Component(
    selector: 'interval_dropdown_select_component',
    styleUrls: const [
      'interval_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'interval_dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor
    ],
    providers: [windowBindings])
class IntervalDropdownSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  ComponentRef componentRef;

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.markForCheck();
  }

  List<IntervalUI> _listInterval;
  final IntervalService _intervalService = new IntervalService();

  bool useItemRenderer = false;

  static ItemRenderer<IntervalUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<IntervalUI> _itemRendererInterval =
      newCachingItemRenderer<IntervalUI>(
          (interval) => "${interval.description}");

  ItemRenderer<IntervalUI> get itemRendererInterval =>
      useItemRenderer ? _itemRendererInterval : _displayNameRenderer;

  IntervalSelectionOptions<IntervalUI> intervalListOptions;

  StringSelectionOptions<IntervalUI> get intervalOptions {
    if (_listInterval == null) {
      return null;
    }

    intervalListOptions = IntervalSelectionOptions<IntervalUI>(_listInterval);

    return intervalListOptions;
  }

  @Input()
  SelectionModel<IntervalUI> singleSelectModelInterval =
      SelectionModel.single();

  String get singleSelectIntervalLabel => singleSelectModelInterval
              .selectedValues ==
          null
      ? '  '
      : singleSelectModelInterval.selectedValues.length > 0
          ? itemRendererInterval(singleSelectModelInterval.selectedValues.first)
          : 'Itervalo';

  String get singleSelectedInterval =>
      singleSelectModelInterval.selectedValues.isNotEmpty
          ? singleSelectModelInterval.selectedValues.first.uiDisplayName
          : null;

  @Output()
  Stream get selectionChanges {
    return singleSelectModelInterval.selectionChanges;  
  }

  IntervalDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _listInterval = new List<IntervalUI>();
    await _intervalService.getIntervalListWithFilterFromList({}).forEach((map) {
      _listInterval.add(new IntervalUI(
          _intervalService.turnMapInInterval(map).id,
          _intervalService.turnMapInInterval(map).time.toString()));
    });
  }
}
