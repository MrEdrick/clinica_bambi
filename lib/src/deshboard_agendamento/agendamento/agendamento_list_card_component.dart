import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'agendamento_card_component.dart';
import '../../firebase/firestore.dart';
import '../../agendamento/consulta/appointment_scheduling_constants.dart';
import '../../agendamento/consulta/consulta_service.dart';
import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/user/user.dart';
import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/agreement/agreement_service.dart';
import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'agendamento-list-card-app',
    styleUrls: const [
      'agendamento_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'agendamento_list_card_component.html',
    //changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AgendamentoCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
    ])
class AgendamentoListCardComponent implements OnInit {
  final List<String> listAppointmentSchedulingId = new List<String>();

  User _user;

  AgendamentoListCardComponent();

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  @Input()
  List<Map> scheduling;

  @Input()
  String dentistId;

  @Input()
  String shiftId;

  @Input()
  String patientName;

  @Input()
  int index;

  int totalResultByDay;

  bool showDeteleCertification = false;

  int deleteIndex = -1;

  void ngOnInit() {
    if (new UserService().user == null) return;

    selectItensFireBase();
  }

  void selectItensFireBase() async {
    if (scheduling == null) {
      return;
    }

    List<Map> _listDocumentSnapshot = new List<Map>();

    /*List<Map> _listDocumentSnapshotTemp = new List<Map>();

    void ListsApplyFilter() {
      if (_listDocumentSnapshotTemp.length > 0) {
        _listDocumentSnapshotTemp.forEach((doc) {
          _listDocumentSnapshot.add(new Map.from(doc));
        });

        _listDocumentSnapshotTemp.clear();
      }
    }*/

    totalResultByDay = 0;
    _listDocumentSnapshot = scheduling;
    
    /*listDocumentSnapshotTemp.clear();

    _listDocumentSnapshot.forEach((doc) {
      if ((dentistId != null) && (dentistId != '')) {
        if (dentistId == doc["dentistId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      } else {
        _listDocumentSnapshotTemp.add(new Map.from(doc));
      }
    });

    if ((dentistId != null) && (dentistId != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    if ((shiftId != null) && (shiftId != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if ((doc["shiftId"] == '') || (doc["shiftId"] == null)) {
          if ((doc["hourId"] == 'JVWNJdwwqjFXCbmuGWf0') ||
              (doc["hourId"] == 'Q14M2Diimon1ksVLO3TO') ||
              (doc["hourId"] == 'hql4fUJfU8vhoxaF7IkB') ||
              (doc["hourId"] == 'mUFFpnp6CP53gnEuS9DU')) {
            doc["shiftId"] = '1a5XNjDT8qfLQ53KSSxh';
          } else {
            doc["shiftId"] = 'fBXihJRGPTPepfkfbxSs';
          }
        }

        if (shiftId == doc["shiftId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((shiftId != null) && (shiftId != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    if ((patientName != null) && (patientName != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["patient"].toString().indexOf(patientName) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((patientName != null) && (patientName != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();*/

    totalResultByDay = _listDocumentSnapshot.length;

    if (totalResultByDay == 0) {
      querySelector("#agendamento-list-card-app-" + index.toString())
          ?.parent
          ?.remove();
      return;
    }

    int totalResult;

    if (querySelector('#agendamento-result-filter-text')
            .getAttribute('value') ==
        null) {
      totalResult = 0;
    } else {
      totalResult = int.parse(querySelector('#agendamento-result-filter-text')
          .getAttribute('value')
          .toString());
    }

    totalResult = totalResult + totalResultByDay;
    querySelector('#agendamento-result-filter-text')
        .setAttribute('value', totalResult?.toString());
    querySelector('#agendamento-result-filter-text')
        .setInnerHtml(totalResult?.toString());

    listAppointmentSchedulingId.clear();

    _listDocumentSnapshot.forEach((doc) async {
      listAppointmentSchedulingId.add(doc['documentPath']);
    });

  }

  void onDelete(int index) {
    deleteIndex = index;
    showDeteleCertification = true;
  }

  void deleteConsulta() {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);
    _fireStoreApp.deleteItem(listAppointmentSchedulingId[deleteIndex]);
    _fireStoreApp.FireStoreOffLine();
    listAppointmentSchedulingId.removeAt(deleteIndex);
    showDeteleCertification = false;
    deleteIndex = -1;
  }

  void noDeleteConsulta() {
    showDeteleCertification = false;
    deleteIndex = -1;
  }
}
