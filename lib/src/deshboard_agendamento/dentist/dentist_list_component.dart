import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import '../../agendamento/dentist/dentist_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/dentist/dentist_row_component.template.dart'
    as dentist_row;

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'dentist_list_component',
    styleUrls: const [
      'dentist_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
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

  @ViewChild('materialContainerRow', read: ViewContainerRef)
  ViewContainerRef materialContainerRow;

  DentistListComponent(this._loader, this._changeDetectorRef);

  int totalResultByDay;

  bool showDeteleCertification = false;

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
    
    List<Map> _list = new DentistService().getDentistListWithFilter();
    
    _list.forEach((dentist) {
      
      ComponentFactory<dentist_row.DentistRowComponent>
          dentistRow =
          dentist_row.DentistRowComponentNgFactory;
      
      ComponentRef dentistRowComponent =
        _loader.loadNextToLocation(dentistRow, materialContainerRow);
      
      dentistRowComponent.instance.dentistId = dentist["documentPath"];
      dentistRowComponent.instance.componentRef = dentistRowComponent;
           
    });
    
    _changeDetectorRef.markForCheck();
  }
}
