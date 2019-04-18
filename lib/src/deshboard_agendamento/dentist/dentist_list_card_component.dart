import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import '../../agendamento/dentist/dentist.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_row_component.template.dart'
    as agendamento_row;

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'dentist_list_card_component',
    styleUrls: const [
      'dentist_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_list_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
    ])
class DentistListCardComponent implements OnInit {
  final List<Dentist> listDentist = new List<Dentist>();

  DentistListCardComponent();

  int totalResultByDay;

  bool showDeteleCertification = false;

  int deleteIndex = -1;

  void ngOnInit() {
    if (new UserService().user == null) 
      return;

  }

}
