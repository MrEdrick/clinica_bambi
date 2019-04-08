import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import 'procedure_card_component.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_constants.dart';

import '../../firebase/firestore.dart';
import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'dentist-list-card-app',
    styleUrls: const [
      'dentist_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_list_card_component.html',
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ProcedureCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      MaterialToggleComponent
    ])
class ProcedureListCardComponent implements OnInit {
  bool state = true;

  final List<Procedure> listProcedure = new List<Procedure>();

  User _user;

  ProcedureListCardComponent();

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  @Input()
  String procedureId;

  @Input()
  int index;

  int totalResultByDay;

  bool showDeteleCertification = false;

  int deleteIndex = -1;

  void ngOnInit() {
    if (new UserService().user == null) 
      return;

    selectItensFireBase();
  }

  void selectItensFireBase() {
    List<Map> _listDocumentSnapshot = new List<Map>();

    List<Map> _listDocumentSnapshotTemp = new List<Map>();

    FireStoreApp fireStoreApp = new FireStoreApp(PROCEDURE_COLLECTION);

    fireStoreApp.ref
        .get()
        .then((querySnapshot) {
          totalResultByDay = 0;

          querySnapshot.forEach((doc) {
            Map map = new Map.from(doc.data());
            map['documentPath'] = doc.id;
            _listDocumentSnapshot.add(map);
          });

          fireStoreApp.FireStoreOffLine();
        }).then((result) {
            _listDocumentSnapshotTemp.clear();  

            totalResultByDay = _listDocumentSnapshot.length;

            if (totalResultByDay == 0) {
              querySelector("#procedure-list-card-app-" + index.toString())
                  ?.parent
                  ?.remove();
              return;
            }

            int totalResult;

            if (querySelector('#procedure-total-result-filter-text').getAttribute('value') ==
                null) {
              totalResult = 0;
            } else {
              totalResult = int.parse(querySelector('#dentist-total-result-filter-text')
                  .getAttribute('value')
                  .toString());
            }

            totalResult = totalResult + totalResultByDay;
            querySelector('#procedure-total-result-filter-text')
                .setAttribute('value', totalResult?.toString());
            querySelector('#procedure-total-result-filter-text')
                .setInnerHtml(totalResult?.toString());

            listProcedure.clear();

            _listDocumentSnapshot.forEach((doc) {
              _turnInConsulta(doc).then((procedure) {
                listProcedure.add(procedure);
              });
            });

          }
        );
  }

  Future<Procedure> _turnInConsulta(Map docSnapshot) async {
    return new Procedure(
      docSnapshot["id"],
      docSnapshot["description"],
      docSnapshot["state"]
    );
  }
}
