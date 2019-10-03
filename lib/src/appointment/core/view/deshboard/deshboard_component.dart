import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
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
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import '../../../../route_paths.dart' as paths;

import '../../../user/user_service.dart';
import '../../model/application.dart';

import '../deshboard_menu_component.template.dart' as deshboard_menu_component;
import '../filter/filter_component.template.dart' as filter_component;

@Component(
  selector: 'deshboard_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_component.html',
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
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'deshboard_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardComponent implements OnActivate, OnInit {
  final Router _router;
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final UserService _userService = new UserService();

  ComponentRef componentRefMenu;
  ComponentRef componentRefFilter;

  final UserService userService = new UserService();

  @Input()
  Application application;

  @ViewChild('viewContainerRefMenu', read: ViewContainerRef)
  ViewContainerRef viewContainerRefMenu;

  @ViewChild('viewContainerRefFilter', read: ViewContainerRef)
  ViewContainerRef viewContainerRefFilter;

  DeshboardComponent(this._router, this._loader, this._changeDetectorRef);

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (userService.user == null) {
        _router.navigate(paths.login.toUrl());
      } else {
        querySelector('#wh-widget-send-button').style.display = 'none';
        _changeDetectorRef.markForCheck();
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;

    ComponentFactory<deshboard_menu_component.DeshboardMenuComponent>
        componentFactoryDeshboardMenu =
        deshboard_menu_component.DeshboardMenuComponentNgFactory;
    componentRefMenu = _loader.loadNextToLocation(
        componentFactoryDeshboardMenu, viewContainerRefMenu);

    componentRefMenu.instance.onClickMenuItem.listen((_) => loadFilter());
    componentRefMenu.instance.application = application;
    componentRefMenu.instance.componentRef = componentRefMenu;
  }

  void loadFilter() {
    ComponentFactory<filter_component.FilterComponent> componentFactoryFilter =
        filter_component.FilterComponentNgFactory;
    componentRefFilter = _loader.loadNextToLocation(
        componentFactoryFilter, viewContainerRefFilter);
    _changeDetectorRef.checkNoChanges();

    componentRefFilter.instance.componentRef = componentRefFilter;
  }
}
