import 'dart:async';
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
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:firebase/firebase.dart' as fb;
import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';
import '../../route_paths.dart' as paths;

import '../../agendamento/shift/shift.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/shift/shift_selection_options.dart';

import '../../agendamento/dentist/dentist.dart';
import '../../agendamento/dentist/dentistUI.dart';
import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/dentist/dentist_selection_options.dart';

import 'dentist_list_card_component.dart';
import 'dentist_edit_component.dart';

@Component(
  selector: 'dentist-filter-app',
  templateUrl: 'dentist_filter_component.html',
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
    DentistListCardComponent,
    DentistEditComponent
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings,
    ClassProvider(DentistService),
    ClassProvider(ShiftService)
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

  User user;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  final Router _router;

  String turnoDescription;
  String shiftId;

  String dentistName;
  String dentistId;

  final List<Date> listDates = new List<Date>();
 
  int totalResultFilter = 0;

  static ItemRenderer<Shift> _displayNameRendererShift =
      (HasUIDisplayName item) => item.uiDisplayName;

  List<Shift> _listShift;
  final ShiftService _shiftService;

  static ItemRenderer<Shift> _itemRendererShift =
      newCachingItemRenderer<Shift>(
          (shift) => "${shift.description}");

  ItemRenderer<Shift> get itemRendererShift =>
      useItemRenderer ? _itemRendererShift : _displayNameRendererShift;

  ShiftSelectionOptions<Shift> shiftListOptions;

  StringSelectionOptions<Shift> get shiftOptions {
    if (_listShift == null) {
      return null;
    }

    shiftListOptions = ShiftSelectionOptions<Shift>(_listShift);

    return shiftListOptions;
  }

  final SelectionModel<Shift> singleSelectModelShift =
      SelectionModel.single();

  String get singleSelectShiftLabel => singleSelectModelShift.selectedValues.length > 0
          ? itemRendererShift(singleSelectModelShift.selectedValues.first)
          : 'Turno';

  String get singleSelectedShift {
    if (singleSelectModelShift.selectedValues.isNotEmpty) {
      return singleSelectModelShift.selectedValues.first.uiDisplayName;
    } else {
      return null;
    }
  }
  final SelectionModel<Shift> multiSelectModelShift =
      SelectionModel<Shift>.multi();

  Future<void> _getListShift() async {
    _listShift = await _shiftService.getAllShiftAcives();
  }
  //----
  List<Dentist> _listDentist;
  final DentistService _dentistService;

  static ItemRenderer<Shift> _displayNameRendererDentist =
    (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<Dentist> _itemRendererDentist =
      newCachingItemRenderer<Dentist>(
          (dentista) => "${dentista.name}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRendererDentist;

  DentistSelectionOptions<Dentist> dentistListOptions;

  StringSelectionOptions<Dentist> get dentistOptions {
    if (_listDentist == null) {
      return null;
    }

    dentistListOptions = DentistSelectionOptions<Dentist>(_listDentist);

    return dentistListOptions;
  }

  final SelectionModel<DentistUI> singleSelectModelDentist =
      SelectionModel.single();

  String get singleSelectDentistLabel => singleSelectModelDentist.selectedValues.length > 0
          ? itemRendererDentist(singleSelectModelDentist.selectedValues.first)
          : 'Dentista da consulta';

  String get singleSelectedDentist {
    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      return singleSelectModelDentist.selectedValues.first.uiDisplayName;
    } else {
      return null;
    }
  }
  final SelectionModel<Dentist> multiSelectModel =
      SelectionModel<Dentist>.multi();

  Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistAcives();
  }

  DentistFilterComponent(this._router, this._dentistService, this._shiftService);

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
      
    _getListDentist();
    _getListShift();
  }

  void onFilter() {   
    querySelector('#dentist-total-result-filter-text').setAttribute('value', '0');
    querySelector('#dentisti-total-result-filter-text').setInnerHtml('0');

    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      dentistName = singleSelectModelDentist.selectedValues.first.name;
      dentistId = singleSelectModelDentist.selectedValues.first.id;
    } else {
      dentistId = '';
    }

      if (singleSelectModelShift.selectedValues.isNotEmpty) {
      turnoDescription = singleSelectModelShift.selectedValues.first.description;
      shiftId = singleSelectModelShift.selectedValues.first.shiftId;
    } else {
      shiftId = '';
    }

    listDates.clear();

  }

  void onAdd() {
    _dentistService.dentist = null;
    querySelector('#editDentist').click();
    querySelector('#dentist-edit-app').style.display = 'block';
  }

  void onClear() {
    if (!singleSelectModelDentist.selectedValues.isEmpty) {
      singleSelectModelDentist
          ?.deselect(singleSelectModelDentist?.selectedValues?.first);
    }
    
    dentistName = '';
    turnoDescription = '';


    querySelector('#total-result-filter-text').setAttribute('value', '0');
    querySelector('#total-result-filter-text').setInnerHtml('0');
  }
}
