import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_button/material_fab.dart';
import '../../agendamento/user/user_service.dart';
import '../../route_paths.dart' as paths;

import '../../agendamento/dentist/dentist.dart';
import '../../agendamento/dentist/dentist_service.dart';

import 'dentist_list_card_component.dart';
import 'dentist_edit_component.dart';

@Component(
  selector: 'dentist_filter_component',
  templateUrl: 'dentist_filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives,
    NgFor,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialDropdownSelectComponent,
    MultiDropdownSelectValueAccessor,
    MaterialFabComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'dentist_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DentistFilterComponent implements OnActivate, OnInit {
  
  List<Dentist> _dentistList;
  
  List<Dentist> get dentistList => _dentistList;
  set dentistList(List<Dentist> dentistLisat) => _dentistList = dentistList;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  final Router _router;

  String dentistName;
  String dentistId;

  final List<Date> listDates = new List<Date>();
 
  int totalResultFilter = 0;

  DentistFilterComponent(this._router);

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
    querySelector('#dentist-total-result-filter-text').setAttribute('value', '0');
    querySelector('#dentisti-total-result-filter-text').setInnerHtml('0');

    listDates.clear();
  }

  void onAdd() {

  }

  void onClear() {

    dentistName = '';
    dentistId = '';

    //querySelector('#total-result-filter-text').setAttribute('value', '0');
    //querySelector('#total-result-filter-text').setInnerHtml('0');
  }
}
