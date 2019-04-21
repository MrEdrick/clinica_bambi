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

@Component(
  selector: 'procedure_filter_component',
  templateUrl: 'procedure_filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialFabComponent,
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

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  final Router _router;

  String description;

  int totalResultFilter = 0;


  ProcedureFilterComponent(this._router);

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user != null) {
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
  }

  void onAdd() {
  }

  void onClear() {
    description = '';

    querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    querySelector('#procedure-total-result-filter-text').setInnerHtml('0');
  }
}
