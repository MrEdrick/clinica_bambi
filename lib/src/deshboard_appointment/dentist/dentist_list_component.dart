import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import '../../appointment/dentist/dentist_service.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_card_component.template.dart'
    as dentist_card;

import '../../appointment/user/user_service.dart';

@Component(
    selector: 'dentist_list_component',
    styleUrls: const [
      'dentist_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dentist_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives
    ])
class DentistListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;
  final List<String> listDentistId = new List<String>();
  
  @Input()
  ComponentRef componentRef;

  @ViewChild('materialContainerCard', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  DentistListComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
    
    List<Map> _list = new DentistService().getDentistListWithFilter();
    
    _list.forEach((dentist) {
      
      ComponentFactory<dentist_card.DentistCardComponent>
          dentistCard =
          dentist_card.DentistCardComponentNgFactory;
      
      ComponentRef dentistCardComponent =
        _loader.loadNextToLocation(dentistCard, materialContainerCard);
      
      dentistCardComponent.instance.dentistId = dentist["documentPath"];
      dentistCardComponent.instance.componentRef = dentistCardComponent;
           
    });
    
    _changeDetectorRef.markForCheck();
  }
}
