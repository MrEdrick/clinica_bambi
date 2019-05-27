import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/procedure/procedure.dart';
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

  @Input()
  ComponentRef componentRef;
  
  List<Procedure> _listProcedure;
  final ProcedureService _procedureService = new ProcedureService();

  bool useItemRenderer = false;

  static ItemRenderer<ProcedureUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<ProcedureUI> _itemRendererProcedure =
      newCachingItemRenderer<ProcedureUI>(
          (procedure) => "${procedure.description}");

  ItemRenderer<ProcedureUI> get itemRendererProcedure =>
      useItemRenderer ? _itemRendererProcedure : _displayNameRenderer;

  ProcedureSelectionOptions<Procedure> procedureListOptions;

  StringSelectionOptions<Procedure> get procedureOptions {
    if (_listProcedure == null) {
      return null;
    }

    procedureListOptions = ProcedureSelectionOptions<Procedure>(_listProcedure);

    return procedureListOptions;
  }

  final SelectionModel<ProcedureUI> singleSelectModelProcedure =
      SelectionModel.single();

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
    _listProcedure = await _procedureService.getAllProcedureAcives();
  }
}
