import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import '../../agendamento/dentist/dentist_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_row_component.template.dart'
    as dentist_row;

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'dentist_list_component',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'dentist_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
    ])
class DentistListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  @ViewChild('containerRowDentist', read: ViewContainerRef)
  ViewContainerRef materialContainerRow;

  DentistListComponent(this._changeDetectorRef, this._loader);

  int totalResultByDay;

  bool showDeteleCertification = false;

  int deleteIndex = -1;

  void ngOnInit() {
    if (new UserService().user == null) 
      return;

    List<Map> _list = new DentistService().getDentistListWithFilter();
    _list.forEach((dentist) {
      ComponentFactory<dentist_row.DentistCardComponent>
          dentistRow =
          dentist_row.DentistCardComponentNgFactory;

      ComponentRef dentistListComponent =
        _loader.loadNextToLocation(dentistRow, materialContainerRow);

      dentistListComponent.instance.appointmentSchedulerId = dentist["documentPath"];
      dentistListComponent.instance.componentRef = dentistListComponent;
    });
    
    _changeDetectorRef.markForCheck();
  }

}
