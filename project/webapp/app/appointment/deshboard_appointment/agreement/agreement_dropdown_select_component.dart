import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart' as prefix0;
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/model/selection/selection_model.dart';

import '../../appointment/core/view/ui.dart';
import '../../appointment/core/view/ui_selection_options.dart';
import '../../appointment/agreement/agreement_service.dart';

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

  @Input()
  ComponentRef componentRef;

  bool _disabled = false;
  bool get disabled => _disabled;
  @Input()
  set disabled(bool disabled) {
    _disabled = disabled;

    _changeDetectorRef.markForCheck();
  }

  List<UI> _listAgreement;
  final AgreementService _agreementService = new AgreementService();

  bool useItemRenderer = false;

  static ItemRenderer<UI> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  static ItemRenderer<UI> _itemRendererAgreement =
      newCachingItemRenderer<UI>((agreement) => "${agreement.description}");

  ItemRenderer<UI> get itemRendererAgreement =>
      useItemRenderer ? _itemRendererAgreement : _displayNameRenderer;

  UISelectionOptions<UI> agreementListOptions;

  StringSelectionOptions<UI> get agreementOptions {
    if (_listAgreement == null) {
      return null;
    }

    agreementListOptions = UISelectionOptions<UI>(_listAgreement);

    return agreementListOptions;
  }

  @Input()
  SelectionModel<UI> singleSelectModelAgreement = SelectionModel.single();

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
    _listAgreement = new List<UI>();
    await _agreementService.getListWithFilter().forEach((map) {
      _listAgreement.add(new UI((_agreementService..map = map).convertMap().id,
          (_agreementService..map = map).convertMap().description));
    });
  }
}
