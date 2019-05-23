import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'agendamento_card_component.dart';
import '../../agendamento/consulta/consulta_service.dart';
import '../../agendamento/user/user_service.dart';
import 'package:intl/intl.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_card_component.template.dart'
    as agendamento_card;

@Component(
    selector: 'agendamento_list_card_component.',
    styleUrls: const [
      'agendamento_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'agendamento_list_card_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AgendamentoCardComponent,
      MaterialInputComponent,
      materialInputDirectives,
      ModalComponent,
    ])
class AgendamentoListCardComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  final List<String> listAppointmentSchedulingId = new List<String>();

  AgendamentoListCardComponent(this._loader, this._changeDetectorRef);

  @Input()
  Date date;

  @Input()
  ComponentRef componentRef;

  String dateFormated;

  int totalResultByDay;

  bool showDeteleCertification = false;

  @ViewChild('containerCardAgendamento', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  void ngOnInit() {
    if (new UserService().user == null) return;

    dateFormated = new DateFormat("EEEE, dd 'de' MMMM 'de' yyyy").format(date.asUtcTime());

    List<Map> _list = new ConsultaService().getAppointmentSchedulingFromListWithFilterByDate(date.toString());
    
    _list.forEach((appointmentScheduling) {
      ComponentFactory<agendamento_card.AgendamentoCardComponent>
          agendamentoCard =
          agendamento_card.AgendamentoCardComponentNgFactory;

      ComponentRef agendamentoListComponent =
        _loader.loadNextToLocation(agendamentoCard, materialContainerCard);

      agendamentoListComponent.instance.appointmentSchedulerId = appointmentScheduling["documentPath"];
      agendamentoListComponent.instance.componentRef = agendamentoListComponent;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
