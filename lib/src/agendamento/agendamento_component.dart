import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_datepicker/calendar.dart';
import 'package:angular_components/material_datepicker/material_calendar_picker.dart';
import 'package:angular_components/material_datepicker/material_time_picker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'agendamento-app',
  templateUrl: 'agendamento_component.html',
  directives: const [
    coreDirectives,  
    MaterialCalendarPickerComponent,
    MaterialTimePickerComponent],
  providers: const [materialProviders, windowBindings, datepickerBindings],
  styleUrls: const [
    'agendamento_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AgendamentoComponent {
  String email = '';
  String subject = '';
  String tel = '';

  DateTime time = DateTime.now();

  static Date date(int days) => Date.today().add(days: days);

  CalendarState plainModel =
      CalendarState.selected([CalendarSelection('range', date(-4), date(4))]);
}
