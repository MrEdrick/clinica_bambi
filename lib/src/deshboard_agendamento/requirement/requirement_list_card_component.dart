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

import 'requirement_card_component.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_constants.dart';

import '../../firebase/firestore.dart';
import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'requirement-list-card-app',
    styleUrls: const [
      'requirement_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'requirement_list_card_component.html',
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      RequirementCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      MaterialToggleComponent
    ])
class RequirementListCardComponent implements OnInit {
  bool state = true;

  final List<Requirement> listRequirement = new List<Requirement>();

  User _user;

  RequirementListCardComponent();

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  @Input()
  String description;

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

    FireStoreApp fireStoreApp = new FireStoreApp(REQUIREMENT_COLLECTION);

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
              querySelector("#requirement-list-card-app-" + index.toString())
                  ?.parent
                  ?.remove();
              return;
            }

            int totalResult;

            if (querySelector('#requirement-total-result-filter-text').getAttribute('value') ==
                null) {
              totalResult = 0;
            } else {
              totalResult = int.parse(querySelector('#requirement-total-result-filter-text')
                  .getAttribute('value')
                  .toString());
            }

            totalResult = totalResult + totalResultByDay;
            querySelector('#requirement-total-result-filter-text')
                .setAttribute('value', totalResult?.toString());
            querySelector('#requirement-total-result-filter-text')
                .setInnerHtml(totalResult?.toString());

            listRequirement.clear();

            _listDocumentSnapshot.forEach((doc) {
              _turnInConsulta(doc).then((requirement) {
                listRequirement.add(requirement);
              });
            });

          }
        );
  }

  Future<Requirement> _turnInConsulta(Map docSnapshot) async {
    return new Requirement(
      docSnapshot["id"],
      docSnapshot["description"],
      docSnapshot["state"]
    );
  }
}
