import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_service.dart';
import '../../agendamento/procedure/procedure_selection_options.dart';

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
    ])
class ProcedureDropdownSelectComponent implements OnInit {
  @Input()
  ComponentRef componentRef;
  List<Procedure> _listProcedure;
  final ProcedureService _procedureService;

  static ItemRenderer<Procedure> _itemRendererProcedure =
      newCachingItemRenderer<Procedure>((procedure) => "${procedure.description}");

  ItemRenderer<Procedure> get itemRendererProcedure =>
      useItemRenderer ? _itemRendererProcedure : _displayNameRenderer;

  ProcedureSelectionOptions<Procedure> procedureListOptions;

  StringSelectionOptions<Procedure> get procedureOptions {
    if (_listProcedure == null) {
      return null;
    }

    procedureListOptions = ProcedureSelectionOptions<Procedure>(_listProcedure);

    return procedureListOptions;
  }

  final SelectionModel<Procedure> singleSelectModelProcedure = SelectionModel.single();

  String get singleSelectProcedureLabel =>
    singleSelectModelProcedure.selectedValues == null
    ? '  '
    : singleSelectModelProcedure.selectedValues.length > 0
          ? itemRendererProcedure(singleSelectModelProcedure.selectedValues.first)
          : 'Procedimento';

  String get singleSelectedProcedure =>
      singleSelectModelProcedure.selectedValues.isNotEmpty
          ? singleSelectModelProcedure.selectedValues.first.uiDisplayName
          : null;

  ProcedureDropdownSelectComponent(this._procedureService);

  void ngOnInit() {
  }
}
