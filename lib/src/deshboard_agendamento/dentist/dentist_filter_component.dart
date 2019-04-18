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

import 'package:ClinicaBambi/src/deshboard_agendamento/dentist/dentist_list_card_component.template.dart'
    as dentist_list;
import 'package:ClinicaBambi/src/deshboard_agendamento/dentist/dentist_edit_component.template.dart'
    as dentist_edit;

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
  final DentistService _dentistService = new DentistService();
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  ComponentRef componentRef;
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

  @ViewChild('containerListDentist', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditDentist', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  DentistFilterComponent(this._router, this._changeDetectorRef, this._loader);

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
    if (new UserService().user == null) return;
  }

  void onFilter() async {
    componentRef.destroy();

    _dentistService.clearAllDentistList();

    _dentistService.getAllDentistAcives().then((onValue) {
      _dentistService
          .getDentistListWithFilterFromList({"name": dentistName});
      onLoad();
    });
  }

  void onLoad() {
    ComponentFactory<dentist_list.DentistListCardComponent> dentistList =
        dentist_list.DentistListCardComponentNgFactory;

    ComponentRef dentistListComponent =
        _loader.loadNextToLocation(dentistList, materialContainerList);

    dentistListComponent.instance.componentRef = dentistListComponent;
    componentRef = dentistListComponent;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    _dentistService.dentist = null;
    ComponentFactory<dentist_edit.DentistEditComponent>
        dentistEdit = dentist_edit.DentistEditComponentNgFactory;

    ComponentRef dentistEditComponent =
        _loader.loadNextToLocation(dentistEdit, materialContainerAdd);
    dentistEditComponent.instance.componentRef = dentistEditComponent;
  }

  void onClear() {
    dentistName = '';
    dentistId = '';

    querySelector('#total-result-filter-text').setAttribute('value', '0');
    querySelector('#total-result-filter-text').setInnerHtml('0');
  }
}
