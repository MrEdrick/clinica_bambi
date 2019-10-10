import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/shift/shift.dart';
import '../../appointment/shift/shiftUI.dart';
import '../../appointment/shift/shift_service.dart';
import '../../appointment/shift/shift_selection_options.dart';

@Component(
    selector: 'shift_dropdown_select_component',
    styleUrls: const [
      'shift_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'shift_dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor
    ],
    providers: [
      windowBindings
    ])
class ShiftDropdownSelectComponent implements OnInit {
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
  
  List<ShiftUI> _listShift;
  final ShiftService _shiftService = new ShiftService();

  bool useItemRenderer = false;

  static ItemRenderer<ShiftUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<ShiftUI> _itemRendererShift =
      newCachingItemRenderer<ShiftUI>(
          (shift) => "${shift.uiDisplayName}");

  ItemRenderer<ShiftUI> get itemRendererShift =>
      useItemRenderer ? _itemRendererShift : _displayNameRenderer;

  ShiftSelectionOptions<ShiftUI> shiftListOptions;

  StringSelectionOptions<ShiftUI> get shiftOptions {
    if (_listShift == null) {
      return null;
    }

    shiftListOptions = ShiftSelectionOptions<ShiftUI>(_listShift);

    return shiftListOptions;
  }

  @Input()
  SelectionModel<ShiftUI> singleSelectModelShift =
      SelectionModel.single();

  @Output()
  Stream get selectionChanges {
    return singleSelectModelShift.selectionChanges;  
  }

  String get singleSelectShiftLabel =>
      singleSelectModelShift.selectedValues == null
          ? '  '
          : singleSelectModelShift.selectedValues.length > 0
              ? itemRendererShift(
                  singleSelectModelShift.selectedValues.first)
              : 'Turno';

  String get singleSelectedShift =>
      singleSelectModelShift.selectedValues.isNotEmpty
          ? singleSelectModelShift.selectedValues.first.uiDisplayName
          : null;

  ShiftDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _listShift = new List<ShiftUI>();
    await _shiftService.getShiftListWithFilterFromList({}).forEach((map) {
      _listShift.add(new ShiftUI(_shiftService.turnMapInShift(map).id, 
                                 _shiftService.turnMapInShift(map).description));
    });
  }
}
