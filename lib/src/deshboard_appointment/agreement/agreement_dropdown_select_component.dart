import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/agreement/agreementUI.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/agreement/agreement_selection_options.dart';

@Component(
    selector: 'agreement_dropdown_select_component',
    styleUrls: const [
      'agreement_dropdown_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'agreement_dropdown_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor
    ],
    providers: [windowBindings])
class AgreementDropdownSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final List<AgreementUI> listAgreement = new List<AgreementUI>();

  @Input()
  ComponentRef componentRef;

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.markForCheck();
  }

  List<String> _listAgreementIdToShow;
  @Input()
  set listAgreementIdToShow(List<String> listAgreementIdToShow) {
    _listAgreementIdToShow = listAgreementIdToShow;
    listAgreement.clear();
    _listAgreementIdToShow.forEach((agreementId) {
      toListAgreementList({"agreementId": agreementId});
    });
  }

  List<AgreementUI> _listAgreement;
  final AgreementService _agreementService = new AgreementService();

  bool useItemRenderer = false;

  static ItemRenderer<AgreementUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<AgreementUI> _itemRendererAgreement =
      newCachingItemRenderer<AgreementUI>(
          (agreement) => "${agreement.uiDisplayName}");

  ItemRenderer<AgreementUI> get itemRendererAgreement =>
      useItemRenderer ? _itemRendererAgreement : _displayNameRenderer;

  AgreementSelectionOptions<AgreementUI> agreementListOptions;

  StringSelectionOptions<AgreementUI> get agreementOptions {
    if (_listAgreement == null) {
      return null;
    }

    agreementListOptions =
        AgreementSelectionOptions<AgreementUI>(_listAgreement);

    return agreementListOptions;
  }

  @Input()
  SelectionModel<AgreementUI> singleSelectModelAgreement =
      SelectionModel.single();

  String get singleSelectAgreementLabel =>
      singleSelectModelAgreement.selectedValues == null
          ? '  '
          : singleSelectModelAgreement.selectedValues.length > 0
              ? itemRendererAgreement(
                  singleSelectModelAgreement.selectedValues.first)
              : 'Convenio';

  String get singleSelectedAgreement =>
      singleSelectModelAgreement.selectedValues.isNotEmpty
          ? singleSelectModelAgreement.selectedValues.first.uiDisplayName
          : null;

  AgreementDropdownSelectComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _listAgreement = new List<AgreementUI>();
    toListAgreementList({});
  }

  void toListAgreementList(Map filter) async {
    await _agreementService
        .getAgreementListWithFilterFromList(filter)
        .forEach((map) {
      listAgreement.add(new AgreementUI(
          _agreementService.turnMapInAgreement(map).id,
          _agreementService.turnMapInAgreement(map).description));
    });
  }
}
