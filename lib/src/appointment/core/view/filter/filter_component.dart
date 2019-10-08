import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../../controller/service/service.dart';
import '../../controller/factory/factory_filter_field.dart';
import '../../model/collection.dart';

@Component(
  selector: 'filter_component',
  templateUrl: 'filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives
  ],
  providers: const [
    materialProviders
  ],
  styleUrls: const [
    'filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProcedureFilterComponent implements OnInit {  
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  final List<ComponentRef> listComponentRefGilterField = new List<ComponentRef>();

  @Input()
  ComponentRef componentRef;

  @Input()
  Collection collection;
  
  @ViewChild('viewContainerRefFilterField', read: ViewContainerRef)
  ViewContainerRef viewContainerRefFilterField;

  final Service service = new Service();

  ProcedureFilterComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    listComponentRefGilterField.clear();

    collection.fieldList.forEach((field) {
      listComponentRefGilterField.add(new FactoryFilterField(field, _loader,
              viewContainerRefFilterField)
          .addField());
    });

    await onFilter();

    _changeDetectorRef.markForCheck();
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
