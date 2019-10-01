import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import '../../../../route_paths.dart' as paths;

import '../filter/filter_component.template.dart' as filter_component;

@Component(
  selector: 'deshboard_menu_item_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_menu_item_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    MaterialIconComponent
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'deshboard_menu_item_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardMenuItemComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  ComponentRef componentRef;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  @Input()
  String title;

  @ViewChild('viewContainerRefFilter', read: ViewContainerRef)
  ViewContainerRef viewContainerRefFilter;

  DeshboardMenuItemComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    _changeDetectorRef.markForCheck();
  }

  void loadFilter() {
    ComponentFactory<filter_component.FilterComponent> componentFactoryFilter =
        filter_component.FilterComponentNgFactory;
    componentRef = _loader.loadNextToLocation(
        componentFactoryFilter, viewContainerRefFilter);
  }

  void onClickMenuItem(String filter) {
    componentRef.destroy();

    _changeDetectorRef.checkNoChanges();
  }
}
