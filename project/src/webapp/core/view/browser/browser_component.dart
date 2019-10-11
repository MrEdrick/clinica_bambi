import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../../../routes/route_paths.dart' as paths;
import '../../controller/service/service.dart';

import '../filter/filter_component.template.dart' as filter_component;
import '../list/list_component.template.dart' as list_component;
import '../card/edit/edit_card_component.template.dart' as edit_card_component;

@Component(
  selector: 'browser-component',
  templateUrl: 'browser_component.html',
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
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'browser_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class BrowserComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  ComponentRef componentRefEditCard;
  ComponentRef componentRefList;
  ComponentRef componentRefFilter;

  @Input()
  ComponentRef componentRef;

  @ViewChild('viewContainerRefFilter', read: ViewContainerRef)
  ViewContainerRef viewContainerRefFilter;

  @ViewChild('viewContainerRefList', read: ViewContainerRef)
  ViewContainerRef viewContainerRefList;

  @ViewChild('viewContainerRefCardEdit', read: ViewContainerRef)
  ViewContainerRef viewContainerRefCardEdit;

  final Service service = new Service();

  BrowserComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    ComponentFactory<filter_component.FilterComponent> componentFactoryFilter =
        filter_component.FilterComponentNgFactory;

    componentRefFilter = _loader.loadNextToLocation(
        componentFactoryFilter, viewContainerRefFilter);

    componentRefFilter.instance.componentRef = componentRefFilter;

    _changeDetectorRef.markForCheck();
  }

  void onLoad() {
    ComponentFactory<list_component.ListComponent> componentFactoryList =
        list_component.ListComponentNgFactory;

    componentRefList =
        _loader.loadNextToLocation(componentFactoryList, viewContainerRefList);

    componentRefList.instance.componentRef = componentRefList;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    service.map.clear();

    ComponentFactory<edit_card_component.EditCardComponent>
        componentFactoryEdit = edit_card_component.EditCardComponentNgFactory;

    componentRefEditCard = _loader.loadNextToLocation(
        componentFactoryEdit, viewContainerRefCardEdit);
    componentRefEditCard.instance.componentRef = componentRefEditCard;

    _changeDetectorRef.markForCheck();
  }
}
