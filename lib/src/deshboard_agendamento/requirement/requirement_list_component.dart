import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../agendamento/user/user_service.dart';

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

  RequirementListComponent();

  void ngOnInit() {
    if (new UserService().user == null) 
      return;

  }
}
