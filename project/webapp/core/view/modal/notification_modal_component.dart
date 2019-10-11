import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import 'modal_configuration.dart';

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

  @Input()
  ModalConfiguration modalConfiguration;

  @Input()
  ComponentRef componentRef;

  NotificationModalComponent(this._changeDetectorRef);

  void ngOnInit() {   
    _changeDetectorRef.markForCheck();
  }

  void onDismissModal() {
    
  }
}
