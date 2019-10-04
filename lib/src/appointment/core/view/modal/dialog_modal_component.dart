import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import 'modal_configuration.dart';

@Component(
    selector: 'dialog-modal-component',
    styleUrls: const [
      'dialog_modal_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dialog_modal_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
    ])

class DialogModalComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 

  @Input()
  ModalConfiguration modalConfiguration;

  @Input()
  bool showModal;

  @Input()
  ComponentRef componentRef;

  DialogModalComponent(this._changeDetectorRef);

  void ngOnInit() {   
    _changeDetectorRef.markForCheck();
  }

  void onDismissModal() {
    
  }
}
