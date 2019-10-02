import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

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
  final ChangeDetectorRef _changeDetectorRef;
  ComponentRef componentRef;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  @Input()
  String title;

  @Output('onClickMenuItem')
  get onClickMenuItem => new StreamController<void>();

  DeshboardMenuItemComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _changeDetectorRef.markForCheck();
  }
}
