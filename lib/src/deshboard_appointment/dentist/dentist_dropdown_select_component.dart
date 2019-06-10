import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/dentist/dentistUI.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/dentist/dentist_selection_options.dart';

@Component(
    selector: 'dentist_dropdown_select_component',
    styleUrls: const [
      'dentist_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dentist_dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor
    ],
    providers: [windowBindings])
class DentistDropdownSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  ComponentRef componentRef;

  bool _disabled = false;
  bool get disabled => _disabled; 
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.checkNoChanges();
  }

  List<String> _listDentisitIdToShow;

  @Input()
  set listDentisitIdToShow(List<String> listDentisitIdToShow) {
    _listDentisitIdToShow = listDentisitIdToShow;
    listDentist.clear();
    _listDentisitIdToShow.forEach((dentistId) {
      toListDentistList({"dentistId": dentistId});
    });
  }

  List<DentistUI> _listDentist;

  final DentistService _dentistService = new DentistService();
  final List<DentistUI> listDentist = new List<DentistUI>();

  bool useItemRenderer = false;

  static ItemRenderer<DentistUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<DentistUI> _itemRendererDentist =
      newCachingItemRenderer<DentistUI>(
          (dentist) => "${dentist.uiDisplayName}");

  ItemRenderer<DentistUI> get itemRendererDentist =>
      useItemRenderer ? _itemRendererDentist : _displayNameRenderer;

  DentistSelectionOptions<DentistUI> dentistListOptions;

  StringSelectionOptions<DentistUI> get dentistOptions {
    if (_listDentist == null) {
      return null;
    }

    dentistListOptions = DentistSelectionOptions<DentistUI>(_listDentist);

    return dentistListOptions;
  }

  @Input()
  SelectionModel<DentistUI> singleSelectModelDentist = SelectionModel.single();

  String get singleSelectDentistLabel => singleSelectModelDentist
              .selectedValues ==
          null
      ? '  '
      : singleSelectModelDentist.selectedValues.length > 0
          ? itemRendererDentist(singleSelectModelDentist.selectedValues.first)
          : 'Dentista';

  String get singleSelectedDentist =>
      singleSelectModelDentist.selectedValues.isNotEmpty
          ? singleSelectModelDentist.selectedValues.first.uiDisplayName
          : null;

  DentistDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    listDentist.clear();
    toListDentistList({});
  }

  void toListDentistList(Map filter) async {
    await _dentistService
        .getDentistListWithFilterFromList(filter)
        .forEach((map) {
      listDentist.add(new DentistUI(_dentistService.turnMapInDentist(map).id,
          _dentistService.turnMapInDentist(map).name));
    });
  }
}
