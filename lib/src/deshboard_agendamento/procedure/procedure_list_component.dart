import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../agendamento/user/user_service.dart';
import '../../agendamento/procedure/procedure_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/procedure/procedure_row_component.template.dart'
    as procedure_row;

@Component(
    selector: 'procedure_list_component',
    styleUrls: const [
      'procedure_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'procedure_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
    ])
class ProcedureListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;
  final List<String> listProcedureId = new List<String>();
  
  @Input()
  ComponentRef componentRef;

  @ViewChild('materialContainerRow', read: ViewContainerRef)
  ViewContainerRef materialContainerRow;

  ProcedureListComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
    
    List<Map> _list = new ProcedureService().getProcedureListWithFilter();
    
    _list.forEach((procedure) {
      
      ComponentFactory<procedure_row.ProcedureRowComponent>
          procedureRow =
          procedure_row.ProcedureRowComponentNgFactory;
      
      ComponentRef procedureRowComponent =
        _loader.loadNextToLocation(procedureRow, materialContainerRow);
      
      procedureRowComponent.instance.procedureId = procedure["documentPath"];
      procedureRowComponent.instance.componentRef = procedureRowComponent;
           
    });
    
    _changeDetectorRef.markForCheck();
  }
}
