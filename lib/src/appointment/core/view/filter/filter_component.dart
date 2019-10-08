import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../../../route_paths.dart' as paths;
import '../../../../appointment/user/user_service.dart';
import '../../controller/service.dart';

@Component(
  selector: 'filter_component',
  templateUrl: 'filter_component.html',
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
    'filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProcedureFilterComponent implements OnInit {  
  ComponentRef componentRef;
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
 
  final Router _router;

  @ViewChild('containerListProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  final Service service = new Service();

  ProcedureFilterComponent(this._router, this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await onFilter();
  }

  Future<void> onFilter() async {
    componentRef?.destroy();

    service.clearAllLists();

    service.getAllAcives().then((onValue) {
      service.getListWithFilter();
    });
  }

  void onClear() {
    //description = '';

    //querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    //querySelector('#procedure-total-result-filter-text').setInnerHtml('0');
  }
}
