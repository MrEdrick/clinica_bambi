import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../model/application.dart';

import '../deshboard_menu_item_component.template.dart'
    as deshboard_menu_item_component;

@Component(
  selector: 'deshboard_menu_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_menu_component.html',
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
    'deshboard_menu_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardMenuComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final List<ComponentRef> listComponentRefMenuItem = new List<ComponentRef>();

  @Input()
  ComponentRef componentRef;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  @Input()
  Application application;

  @Output('onClickMenuItem')
  get onClickMenuItem => new StreamController<void>();

  @ViewChild('viewContainerRefMenuItem', read: ViewContainerRef)
  ViewContainerRef viewContainerRefMenuItem;

  DeshboardMenuComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    listComponentRefMenuItem.clear();
    
    application.fileList.forEach((file) {
      ComponentFactory<deshboard_menu_item_component.DeshboardMenuItemComponent>
        componentFactoryDeshboardMenuItem =
        deshboard_menu_item_component.DeshboardMenuItemComponentNgFactory;
    
      listComponentRefMenuItem.add(_loader.loadNextToLocation(componentFactoryDeshboardMenuItem, viewContainerRefMenuItem));

      listComponentRefMenuItem.last.instance.onClickMenuItem.listen((_) => onClickMenuItem());
      listComponentRefMenuItem.last.instance.file = file;
      listComponentRefMenuItem.last.componentRef = listComponentRefMenuItem.last;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
