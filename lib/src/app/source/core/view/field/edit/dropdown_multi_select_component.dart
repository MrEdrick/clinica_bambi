import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/material_select/material_select_searchbox.dart';

import '../../../controller/service/service.dart';
import '../../../view/ui/ui.dart';
import '../../../view/ui/ui_selection_options.dart';

@Component(
    selector: 'dropdown-multi-select-component',
    styleUrls: const [
      'dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor,
      MaterialSelectSearchboxComponent
    ],
    providers: [windowBindings])
class DropdownMultiSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final Service _service = new Service();

  List<UI> _list;

  @Input()
  ComponentRef componentRef;

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.markForCheck();
  }

  @Input()
  String description;

  bool useItemRenderer = false;

  static ItemRenderer<UI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<UI> _itemRenderer =
      newCachingItemRenderer<UI>((procedure) => "${procedure.uiDisplayName}");

  ItemRenderer<UI> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

  UISelectionOptions<UI> listOptions;

  StringSelectionOptions<UI> get options {
    if (_list == null) {
      return null;
    }

    listOptions = UISelectionOptions<UI>(_list);

    return listOptions;
  }

  final SelectionModel<UI> multiSelectModel = SelectionModel<UI>.multi();

  @Output()
  Stream get selectionChanges {
    return multiSelectModel.selectionChanges;
  }

  String get multiSelectLabel {
    var selectedValues = multiSelectModel.selectedValues;
    if (selectedValues.isEmpty) {
      return "";
    } else if (selectedValues.length == 1) {
      return itemRenderer(selectedValues.first);
    } else {
      return "${itemRenderer(selectedValues.first)} + ${selectedValues.length - 1} more";
    }
  }

  String get multiSelected =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(',');

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      Timer.run(() {
        searchbox.focus();
      });
    }
  }

  DropdownMultiSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _list = new List<UI>();
    await _service.getListWithFilter().forEach((map) {
      _list.add(new UI(
          _service.map[_service.id], _service.map[_service.description]));
    });
  }
}