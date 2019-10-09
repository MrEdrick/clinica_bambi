import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../../../appointment/user/user_service.dart';
import '../../controller/service/service.dart';

import 'card_component.template.dart'
    as card_component;

@Component(
    selector: 'list_component',
    styleUrls: const [
      'list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
    ])
class ListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  final List<ComponentRef> listComponentRefCard = new List<ComponentRef>();
  final List<String> listId = new List<String>();
  final UserService userService = new UserService();
  final Service service = new Service();

  @Input()
  ComponentRef componentRef;

  @ViewChild('viewContainerRefCard', read: ViewContainerRef)
  ViewContainerRef viewContainerRefCard;

  ListComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() {
    if (userService.user == null) 
      return;

    listComponentRefCard.clear();
    
    service.getListWithFilter().forEach((item) {
      ComponentFactory<card_component.CardComponent>
          componentFactoryCard =
          card_component.CardComponentNgFactory;
      
      listComponentRefCard.add(_loader.loadNextToLocation(componentFactoryCard, viewContainerRefCard));
      
      listComponentRefCard.last.instance.id = item["documentPath"];
      listComponentRefCard.last.instance.componentRef = listComponentRefCard.last;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
