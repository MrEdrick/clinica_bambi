import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';
import '../../agendamento/requirement/requirement.dart';
import 'requirement_list_card_component.dart';
import 'requirement_edit_component.dart';

@Component(
  selector: 'requirement_filter_component',
  templateUrl: 'requirement_filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives,
    NgFor,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialFabComponent,
    RequirementListCardComponent,
    RequirementEditComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    popupBindings
  ],
  styleUrls: const [
    'requirement_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class RequirementFilterComponent implements OnInit {
  
  List<Requirement> _requirementList;
  
  List<Requirement> get requirementList => _requirementList;
  set requirementList(List<Requirement> requirementList) => _requirementList = requirementList;

  User _user;
  
  User get user => _user;
  @Input()
  set user(User user) => _user = user;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;

  String description;
 
  int totalResultFilter = 0;

  RequirementFilterComponent();

  void ngOnInit() { 
    if (new UserService().user == null)
      return;
  }

  void onFilter() {   
    querySelector('#requirement-total-result-filter-text').setAttribute('value', '0');
    querySelector('#requirement-total-result-filter-text').setInnerHtml('0');
  }

  void onAdd() {
    querySelector('#editRequirement').click();
    querySelector('#requirement-edit-app').style.display = 'block';
  }

  void onClear() {
    description = '';

    querySelector('#requirement-total-result-filter-text').setAttribute('value', '0');
    querySelector('#requirement-total-result-filter-text').setInnerHtml('0');
  }
}
