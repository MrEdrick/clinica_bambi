import 'Requirement.dart';

class RequirementService {
  static Requirement _requirement = null;

  Requirement get requirement => _requirement;
  set requirement(Requirement requirement) => _requirement = requirement;
}