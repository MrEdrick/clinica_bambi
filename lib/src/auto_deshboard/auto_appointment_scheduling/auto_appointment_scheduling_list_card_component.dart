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
import 'auto_agendamento_card_component.dart';
import '../firebase/firestore.dart';
import '../agendamento/consulta/consulta.dart';
import '../agendamento/user/user.dart';
import '../agendamento/dentist/dentist_service.dart';
import '../agendamento/shift/shift_service.dart';
import '../agendamento/agreement/agreement_service.dart';
import '../agendamento/user/user_service.dart';

@Component(
    selector: 'auto-agendamento-list-card-app',
    styleUrls: const [
      'auto_agendamento_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_agendamento_list_card_component.html',
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AutoAgendamentoCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
    ])
class AutoAgendamentoListCardComponent implements OnInit {
  final List<Consulta> listConsultas = new List<Consulta>();

  User _user;

  AutoAgendamentoListCardComponent();

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  @Input()
  Date dataConsulta;

  @Input()
  String dentistId;
  
  @Input()
  String shiftId;

  @Input()
  String patientId;

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

    void ListsApplyFilter() {
      if (_listDocumentSnapshotTemp.length > 0) {
        _listDocumentSnapshotTemp.forEach((doc) {
          _listDocumentSnapshot.add(new Map.from(doc));
        });

        _listDocumentSnapshotTemp.clear();
      }
    }

    FireStoreApp fireStoreApp = new FireStoreApp('appointmentsScheduling');

    fireStoreApp.ref
        .where('dateAppointmentScheduling', '==',
            new DateFormat('yyyy-MM-dd').format(dataConsulta.asUtcTime()))
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
                  if ((doc["hourId"] == 'JVWNJdwwqjFXCbmuGWf0')
                      || (doc["hourId"] == 'Q14M2Diimon1ksVLO3TO')
                      || (doc["hourId"] == 'hql4fUJfU8vhoxaF7IkB')
                      || (doc["hourId"] == 'mUFFpnp6CP53gnEuS9DU')) {
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

            _listDocumentSnapshot.forEach((doc) {
              if (doc["id"].toString().indexOf(patientId) > -1) {
                _listDocumentSnapshotTemp.add(new Map.from(doc));
              }
            });
            
            ListsApplyFilter();

            totalResultByDay = _listDocumentSnapshot.length;

            if (totalResultByDay == 0) {
              querySelector("#auot-agendamento-list-card-app-" + index.toString())
                  ?.parent
                  ?.remove();
              return;
            }

            int totalResult;

            if (querySelector('#total-result-filter-text').getAttribute('value') ==
                null) {
              totalResult = 0;
            } else {
              totalResult = int.parse(querySelector('#total-result-filter-text')
                  .getAttribute('value')
                  .toString());
            }

            totalResult = totalResult + totalResultByDay;
            querySelector('#total-result-filter-text')
                .setAttribute('value', totalResult?.toString());
            querySelector('#total-result-filter-text')
                .setInnerHtml(totalResult?.toString());

            listConsultas.clear();

            _listDocumentSnapshot.forEach((doc) {
              _turnInConsulta(doc).then((consulta) {
                listConsultas.add(consulta);
              });
            });

          }
        );
  }

  Future<Consulta> _turnInConsulta(Map docSnapshot) async {
    return new Consulta(
      docSnapshot["documentPath"],
      docSnapshot["dateAppointmentScheduling"],
      docSnapshot["hourId"],
      docSnapshot["minuteId"],
      docSnapshot["shiftId"],
      docSnapshot["dentistId"],
      docSnapshot["patient"],
      docSnapshot["email"],
      docSnapshot["tel"],
      user.id,
      await new ShiftService().getShiftById(docSnapshot["id"]),
      await new DentistService().getDentistById(docSnapshot["dentistId"]),
      await new AgreementService().getAgreementById(docSnapshot["agreementId"]),
    );
  }

  void onDelete(int index) {
    deleteIndex = index;
    showDeteleCertification = true;
  }

  void deleteConsulta() {
    FireStoreApp fireStoreApp = new FireStoreApp('appointmentsScheduling');
    fireStoreApp.deleteItem(listConsultas[deleteIndex].id);
    listConsultas.removeAt(deleteIndex);
    showDeteleCertification = false;
    deleteIndex = -1;
  }

  void noDeleteConsulta() {
    showDeteleCertification = false;
    deleteIndex = -1;
  }
}