import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/requirement/requirement_service.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/requirement/requirement_card_component.template.dart'
    as requirement_card;

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
      materialInputDirectives
    ])
class RequirementListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;
  final List<String> listDentistId = new List<String>();
  
  @Input()
  ComponentRef componentRef;

  @ViewChild('materialContainerCard', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  RequirementListComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
    
    List<Map> _list = new RequirementService().getRequirementListWithFilter();
    
    _list.forEach((requirement) {
      
      ComponentFactory<requirement_card.RequirementCardComponent>
          requirementCard =
          requirement_card.RequirementCardComponentNgFactory;
      
      ComponentRef requirementCardComponent =
        _loader.loadNextToLocation(requirementCard, materialContainerCard);
      
      requirementCardComponent.instance.requirementId = requirement["documentPath"];
      requirementCardComponent.instance.componentRef = requirementCardComponent;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
