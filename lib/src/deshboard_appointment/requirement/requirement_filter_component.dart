import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/requirement/requirement_service.dart';
import '../../route_paths.dart' as paths;

import 'package:ClinicaBambi/src/deshboard_appointment/requirement/requirement_list_component.template.dart'
    as requirement_list;
import 'package:ClinicaBambi/src/deshboard_appointment/requirement/requirement_edit_component.template.dart'
    as requirement_edit;


@Component(
  selector: 'requirement_filter_component',
  templateUrl: 'requirement_filter_component.html',
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
    popupBindings
  ],
  styleUrls: const [
    'requirement_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class RequirementFilterComponent implements OnActivate,  OnInit {
  RequirementService _requirementService = new RequirementService();
  ComponentRef componentRef;
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader; 
  final Router _router;

  String description;

  @ViewChild('containerListRequirement', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditRequirement', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  RequirementFilterComponent(this._router, this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await onFilter();
  }

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

  void onFilter() {   
    componentRef?.destroy();

    _requirementService.clearAllRequirementList();

    _requirementService.getAllRequirementAcives().then((onValue) {
      _requirementService.getRequirementListWithFilterFromList({"description": description});

      onLoad();
    });
  }

  void onLoad() {
    ComponentFactory<requirement_list.RequirementListComponent> requirementList =
        requirement_list.RequirementListComponentNgFactory;

    ComponentRef requirementListComponent =
        _loader.loadNextToLocation(requirementList, materialContainerList);

    requirementListComponent.instance.componentRef = requirementListComponent;
    componentRef = requirementListComponent;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    _requirementService.requirement = null;
    ComponentFactory<requirement_edit.RequirementEditComponent> requirementEdit =
        requirement_edit.RequirementEditComponentNgFactory;

    ComponentRef requirementEditComponent =
        _loader.loadNextToLocation(requirementEdit, materialContainerAdd);
    requirementEditComponent.instance.componentRef = requirementEditComponent;
  }

  void onClear() {
    description = '';

    querySelector('#requirement-total-result-filter-text').setAttribute('value', '0');
    querySelector('#requirement-total-result-filter-text').setInnerHtml('0');
  }
}
