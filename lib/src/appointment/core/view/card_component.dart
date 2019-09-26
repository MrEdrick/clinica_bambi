import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../controller/service.dart';
import 'edit_component.dart';

@Component(
    selector: 'card-app',
    styleUrls: const [
      'card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      EditComponent,
      ModalComponent,
    ])

class CardComponent {
  Map _map;
  Service service;

  bool showEditAgendamentoEditApp = false;

  Map get map => _map;
  @Input()
  set map(Map map) => _map = map; 

  CardComponent();

  void onEdit() {
    service = new Service();
    service.map = map;
    querySelector('#edit').click();
    querySelector('#edit-app').style.display = 'block';
  }
}
