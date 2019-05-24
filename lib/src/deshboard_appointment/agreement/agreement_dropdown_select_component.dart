import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/agreement/agreement.dart';
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
    providers: [
      windowBindings,
      ClassProvider(AgreementService)
    ])
class AgreementDropdownSelectComponent implements OnInit {

  @Input()
  ComponentRef componentRef;
  
  List<Agreement> _listAgreement;
  final AgreementService _agreementService;

  bool useItemRenderer = false;

  static ItemRenderer<AgreementUI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<AgreementUI> _itemRendererAgreement =
      newCachingItemRenderer<AgreementUI>(
          (agreement) => "${agreement.description}");

  ItemRenderer<AgreementUI> get itemRendererAgreement =>
      useItemRenderer ? _itemRendererAgreement : _displayNameRenderer;

  AgreementSelectionOptions<Agreement> agreementListOptions;

  StringSelectionOptions<Agreement> get agreementOptions {
    if (_listAgreement == null) {
      return null;
    }

    agreementListOptions = AgreementSelectionOptions<Agreement>(_listAgreement);

    return agreementListOptions;
  }

  final SelectionModel<AgreementUI> singleSelectModelAgreement =
      SelectionModel.single();

  String get singleSelectAgreementLabel =>
      singleSelectModelAgreement.selectedValues == null
          ? '  '
          : singleSelectModelAgreement.selectedValues.length > 0
              ? itemRendererAgreement(
                  singleSelectModelAgreement.selectedValues.first)
              : 'Convênio';

  String get singleSelectedAgreement =>
      singleSelectModelAgreement.selectedValues.isNotEmpty
          ? singleSelectModelAgreement.selectedValues.first.uiDisplayName
          : null;

  AgreementDropdownSelectComponent(this._agreementService);

  void ngOnInit() async {
    _listAgreement = await _agreementService.getAllAgreementAcives();
  }

}
