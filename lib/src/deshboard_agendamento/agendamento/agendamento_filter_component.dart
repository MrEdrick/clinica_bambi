import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:intl/intl.dart';

//import '../agendamento/agendamento_list_card_component.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_list_card_component.template.dart'
    as agendamento_list;

import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';

import '../../agendamento/shift/shift.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/shift/shift_selection_options.dart';

import '../../agendamento/dentist/dentistUI.dart';
import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/dentist/dentist_selection_options.dart';

//import '../agendamento/agendamento_edit_component.dart';

import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/consulta/consulta_service.dart';

@Component(
  selector: 'agendamento_filter_component',
  templateUrl: 'agendamento_filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives,
    NgFor,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialDatepickerComponent,
    DateRangeInputComponent,
    MaterialDropdownSelectComponent,
    MultiDropdownSelectValueAccessor,
    MaterialFabComponent,
    //AgendamentoListCardComponent,
    //AgendamentoEditComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
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
    'agendamento_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AgendamentoFilterComponent implements OnInit {
  ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  ConsultaService _consultaService = new ConsultaService();

  ConsultaService get consultaService => _consultaService;
  set consultaService(ConsultaService consultaService) =>
      _consultaService = consultaService;

  User _user;

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  Date dataInicial = new Date.today();
  Date dataFinal = new Date.today().add(days: 1);
  List<Date> listDate = new List<Date>(); 

  String dataInicialFormatada;
  String dataFinalFormatada;

  int daysDif = 1;

  String turnoDescription;
  String shiftId;

  String dentistName;
  String dentistId;

  String patientName;

  @ViewChild('containerListAgendamento', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  List<List<Map<String, dynamic>>> listScheduling =
      new List<List<Map<String, dynamic>>>();
  final List<Consulta> listAppointmentSchedulingByDate = new List<Consulta>();

  int totalResultFilter = 0;

  static ItemRenderer<Shift> _displayNameRendererShift =
      (HasUIDisplayName item) => item.uiDisplayName;

  List<Shift> _listShift;
  final ShiftService _shiftService;

  static ItemRenderer<Shift> _itemRendererShift =
      newCachingItemRenderer<Shift>((shift) => "${shift.description}");

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

  final SelectionModel<Shift> singleSelectModelShift = SelectionModel.single();

  String get singleSelectShiftLabel =>
      singleSelectModelShift.selectedValues.length > 0
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
  List<DentistUI> _listDentist;
  final DentistService _dentistService;

  static ItemRenderer<DentistUI> _displayNameRendererDentist =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<DentistUI> _itemRendererDentist =
      newCachingItemRenderer<DentistUI>((dentista) => "${dentista.name}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRendererDentist;

  DentistSelectionOptions<DentistUI> dentistListOptions;

  StringSelectionOptions<DentistUI> get dentistOptions {
    if (_listDentist == null) {
      return null;
    }

    dentistListOptions = DentistSelectionOptions<DentistUI>(_listDentist);

    return dentistListOptions;
  }

  final SelectionModel<DentistUI> singleSelectModelDentist =
      SelectionModel.single();

  String get singleSelectDentistLabel =>
      singleSelectModelDentist.selectedValues.length > 0
          ? itemRendererDentist(singleSelectModelDentist.selectedValues.first)
          : 'Dentista da consulta';

  String get singleSelectedDentist {
    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      return singleSelectModelDentist.selectedValues.first.uiDisplayName;
    } else {
      return null;
    }
  }

  final SelectionModel<DentistUI> multiSelectModel =
      SelectionModel<DentistUI>.multi();

  Future<void> _getListDentist() async {
    _listDentist = await _dentistService.getAllDentistUIAcives();
  }

  AgendamentoFilterComponent(
      this._dentistService, this._shiftService, this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    user = new UserService().user;
    if (user == null) return;

    _getListDentist();
    _getListShift();

    await onFilter();
  }

  void onLoad() {
    listDate.forEach((date) {
      ComponentFactory<agendamento_list.AgendamentoListCardComponent>
          agendamentoList =
          agendamento_list.AgendamentoListCardComponentNgFactory;

      ComponentRef agendamentoListComponent =
        _loader.loadNextToLocation(agendamentoList, materialContainerList);

      agendamentoListComponent.instance.date = date;
    });
    
    _changeDetectorRef.markForCheck();
  }

  List<Date> onPrepareFilter() {
    if (dataFinal.isBefore(dataInicial)) {
      dataFinal = dataInicial;
    }

    querySelector('#agendamento-result-filter-text').setAttribute('value', '0');
    querySelector('#agendamento-result-filter-text').setInnerHtml('0');

    dataInicialFormatada =
        new DateFormat('dd/MM/yyyy').format(dataInicial.asUtcTime());
    dataFinalFormatada =
        new DateFormat('dd/MM/yyyy').format(dataFinal.asUtcTime());

    daysDif = dataFinal.asUtcTime().difference(dataInicial.asUtcTime()).inDays;

    if (singleSelectModelDentist.selectedValues.isNotEmpty) {
      dentistName = singleSelectModelDentist.selectedValues.first.name;
      dentistId = singleSelectModelDentist.selectedValues.first.id;
    } else {
      dentistId = '';
    }

    if (singleSelectModelShift.selectedValues.isNotEmpty) {
      turnoDescription =
          singleSelectModelShift.selectedValues.first.description;
      shiftId = singleSelectModelShift.selectedValues.first.shiftId;
    } else {
      shiftId = '';
    }
  
    for (var i = 0; i <= daysDif; i++) {
      listDate.add(dataInicial.add(days: i));
    }

    return listDate;
  }

  Future<void> onFilter() async {
    listDate = onPrepareFilter();
    
    new ConsultaService()
          .clearAllAppointmentSchedulingByDate();
    
    await listDate.forEach((date) async {
      new ConsultaService()
          .getAllAppointmentSchedulingByDateMap(date)
          .then((onValue) {
        new ConsultaService().getAppointmentSchedulingWithFilterFromList(
            date.toString(), {
          "dentistId": dentistId,
          "shiftId": shiftId,
          "patient": patientName
        });

        if (listDate.last == date) {
          
          onLoad();
        }
      });
    });
    return;
  }

  void onAdd() {
    consultaService.consulta = null;
    querySelector('#editAgendamento').click();
    querySelector('#agendamento-edit-app').style.display = 'block';
  }

  void onClear() {
    if (!singleSelectModelDentist.selectedValues.isEmpty) {
      singleSelectModelDentist
          ?.deselect(singleSelectModelDentist?.selectedValues?.first);
    }

    dataInicial = new Date.today();
    dataFinal = new Date.today().add(days: 7);

    dataInicialFormatada = '';
    dataFinalFormatada = '';
    dentistName = '';
    turnoDescription = '';

    patientName = '';

    querySelector('#total-result-filter-text').setAttribute('value', '0');
    querySelector('#total-result-filter-text').setInnerHtml('0');
  }
}
