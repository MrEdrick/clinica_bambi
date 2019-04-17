import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:firebase/firebase.dart' as fb;

import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';
import '../../route_paths.dart' as paths;
import '../../agendamento/procedure/procedure.dart';
import 'procedure_list_card_component.dart';
import 'procedure_edit_component.dart';

@Component(
  selector: 'procedure_filter_component',
  templateUrl: 'procedure_filter_component.html',
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
    ProcedureListCardComponent,
    ProcedureEditComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'procedure_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProcedureFilterComponent implements OnActivate, OnInit {
  
  List<Procedure> _procedureList;
  
  List<Procedure> get procedureList => _procedureList;
  set procedureList(List<Procedure> procedureLisat) => _procedureList = procedureList;

  User _user;
  
  User get user => _user;
  @Input()
  set user(User user) => _user = user;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  final Router _router;

  String description;

  final List<Date> listDates = new List<Date>();
 
  int totalResultFilter = 0;


  ProcedureFilterComponent(this._router);

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user != null) {
        user = new User(fb.auth().currentUser.uid,
                              fb.auth().currentUser.displayName, 
                              fb.auth().currentUser.email);

        onFilter();
      } else {
        _router.navigate(paths.login.toUrl());
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  void ngOnInit() { 
    if (new UserService().user == null)
      return;
  }

  void onFilter() {   
    querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    querySelector('#procedure-total-result-filter-text').setInnerHtml('0');

    listDates.clear();

  }

  void onAdd() {
    querySelector('#editProcedure').click();
    querySelector('#procedure-edit-app').style.display = 'block';
  }

  void onClear() {
    description = '';

    querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    querySelector('#procedure-total-result-filter-text').setInnerHtml('0');
  }
}
