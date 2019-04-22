import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../agendamento/user/user_service.dart';
import '../../agendamento/requirement/requirement_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/requirement/requirement_row_component.template.dart'
    as requirement_row;

@Component(
    selector: 'requirement_list_component',
    styleUrls: const [
      'requirement_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'requirement_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      materialInputDirectives,
    ])
class RequirementListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;
  final List<String> listDentistId = new List<String>();
  
  @Input()
  ComponentRef componentRef;

  @ViewChild('materialContainerRow', read: ViewContainerRef)
  ViewContainerRef materialContainerRow;

  RequirementListComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
    
    List<Map> _list = new RequirementService().getRequirementListWithFilter();
    
    _list.forEach((requirement) {
      
      ComponentFactory<requirement_row.RequirementRowComponent>
          requirementRow =
          requirement_row.RequirementRowComponentNgFactory;
      
      ComponentRef requirementRowComponent =
        _loader.loadNextToLocation(requirementRow, materialContainerRow);
      
      requirementRowComponent.instance.requirementId = requirement["documentPath"];
      requirementRowComponent.instance.componentRef = requirementRowComponent;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
