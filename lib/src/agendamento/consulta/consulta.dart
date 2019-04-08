import '../shift/shift.dart';
import '../dentist/dentist.dart';
import '../agreement/agreement.dart';
import 'package:intl/intl.dart';

class Consulta {
  String _id;
  String _shiftId;
  String _hourId;
  String _minuteId;
  String _dentistId;
  String _paciente;
  String _email;
  String _telefone;
  String _dataConsultaAgendamento;
  String _idUser;
  Shift _shift;
  Dentist _dentist;
  Agreement _agreement;

  Consulta( this._id, this._dataConsultaAgendamento, 
            this._hourId, this._minuteId, this._shiftId, this._dentistId, 
            this._paciente, this._email, this._telefone, this._idUser,
            this._shift, this._dentist, this._agreement);

  String get id => _id;
  set id(String id) => _id = id;


  String get dataConsultaAgendamentoFormated { 
    return new DateFormat('dd/MM/yyyy').format(DateTime.parse(_dataConsultaAgendamento));
  }

  String get dataConsultaAgendamento => _dataConsultaAgendamento;
  set dataConsultaAgendamento(String dataConsultaAgendamento) => _dataConsultaAgendamento = dataConsultaAgendamento;

  String get shiftId {
    if ((_shiftId == '') || (_shiftId == null)) {
      if ((_hourId == 'JVWNJdwwqjFXCbmuGWf0')
          || (_hourId == 'Q14M2Diimon1ksVLO3TO')
          || (_hourId == 'hql4fUJfU8vhoxaF7IkB')
          || (_hourId == 'mUFFpnp6CP53gnEuS9DU')) {
          _shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
          _shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }

    return _shiftId;
  }

  set shiftId(String shiftId) { 
    _shiftId = shiftId;

    if ((_shiftId == '') || (_shiftId == null)) {
      if ((_hourId == 'JVWNJdwwqjFXCbmuGWf0')
          || (_hourId == 'Q14M2Diimon1ksVLO3TO')
          || (_hourId == 'hql4fUJfU8vhoxaF7IkB')
          || (_hourId == 'mUFFpnp6CP53gnEuS9DU')) {
          _shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
          _shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }
  }

  String get hourId => _hourId;
  set hourId(String hourId) => _hourId = hourId;

  String get minuteId => _minuteId;
  set minuteId(String minuteId) => _minuteId = minuteId; 

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get paciente => _paciente;
  set paciente(String paciente) => _paciente = paciente;

  String get email => _email;
  set email(String email) => _email = email;

  String get telefone => _telefone;
  set telefone(String telefone) => _telefone = telefone;

  String get idUser => _idUser;
  set idUser(String idUser) => _idUser = idUser;

  Shift get shift => _shift;
  set shift(Shift shift) => _shift = shift;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  Agreement get agreement => _agreement;
  set agreement(Agreement agreement) => _agreement = agreement;

}
