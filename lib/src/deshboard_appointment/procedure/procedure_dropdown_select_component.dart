import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/procedure/procedureUI.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/procedure/procedure_selection_options.dart';

@Component(
    selector: 'procedure_dropdown_select_component',
    styleUrls: const [
      'procedure_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'procedure_dropdown_select_component.html',
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
class ProcedureDropdownSelectComponent implements OnInit {
  List<ProcedureUI> _listProcedure;
  final ProcedureService _procedureService = new ProcedureService();

  @Input()
  ComponentRef componentRef;

  @Input()
  bool disabled = false;
  
  bool useItemRenderer = false;

  static ItemRenderer<ProcedureUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<ProcedureUI> _itemRendererProcedure =
      newCachingItemRenderer<ProcedureUI>(
          (procedure) => "${procedure.uiDisplayName}");

  ItemRenderer<ProcedureUI> get itemRendererProcedure =>
      useItemRenderer ? _itemRendererProcedure : _displayNameRenderer;

  ProcedureSelectionOptions<ProcedureUI> procedureListOptions;

  StringSelectionOptions<ProcedureUI> get procedureOptions {
    if (_listProcedure == null) {
      return null;
    }

    procedureListOptions = ProcedureSelectionOptions<ProcedureUI>(_listProcedure);

    return procedureListOptions;
  }

  @Input()
  SelectionModel<ProcedureUI> singleSelectModelProcedure =
      SelectionModel.single();

  @Output()
  Stream get selectionChanges {
    return singleSelectModelProcedure.selectionChanges;  
  }

  String get singleSelectProcedureLabel =>
      singleSelectModelProcedure.selectedValues == null
          ? '  '
          : singleSelectModelProcedure.selectedValues.length > 0
              ? itemRendererProcedure(
                  singleSelectModelProcedure.selectedValues.first)
              : 'Procedimento';

  String get singleSelectedProcedure =>
      singleSelectModelProcedure.selectedValues.isNotEmpty
          ? singleSelectModelProcedure.selectedValues.first.uiDisplayName
          : null;

  ProcedureDropdownSelectComponent();

  void ngOnInit() async {
    _listProcedure = new List<ProcedureUI>();
    await _procedureService.getProcedureListWithFilterFromList({}).forEach((map) {
      _listProcedure.add(new ProcedureUI(_procedureService.turnMapInProcedure(map).id,
                                         _procedureService.turnMapInProcedure(map).description));
    });
  }
}
