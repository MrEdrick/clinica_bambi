import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../controller/service.dart';
import '../../model/collection.dart';

import 'label_component_component.template.dart'
    as label_component;
import 'edit_component_component.template.dart'
    as edit_component;

@Component(
    selector: 'notification-modal-component',
    styleUrls: const [
      'notification_modal_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'notification_modal_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
    ])

class NotificationModalComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  @Input()
  String title;

  @Input()
  String message;

  @Input()
  bool showModal;

  @Input()
  ComponentRef componentRef;

  NotificationModalComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() {   
    _changeDetectorRef.markForCheck();
  }

  void onDismissModal() {
    
  }
}
