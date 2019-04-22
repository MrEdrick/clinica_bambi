import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_service.dart';
import 'requirement_edit_component.dart';

@Component(
    selector: 'requirement-card-app',
    styleUrls: const [
      'requirement_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'requirement_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      RequirementEditComponent,
      ModalComponent,
    ])

class RequirementCardComponent {
  Requirement _requirement;
  RequirementService requirementService;

  bool showEditAgendamentoEditApp = false;

  Requirement get requirement => _requirement;
  @Input()
  set requirement(Requirement requirement) => _requirement = requirement; 

  RequirementCardComponent();

  void onEdit() {
    requirementService = new RequirementService();
    requirementService.requirement = requirement;
    querySelector('#editRequirement').click();
    querySelector('#requirement-edit-app').style.display = 'block';
  }
}
