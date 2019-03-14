import 'patient_account.dart';

class PatientAccountService {
  static PatientAccount _patientAccount = null;

  PatientAccount get patientAccount => _patientAccount;
  set patientAccount(PatientAccount patientAccount) => _patientAccount = patientAccount;
}