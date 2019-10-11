class GenericService {

  String returnStringEmptyIfNull(var variable) {
    return variable == null ? '' : variable; 
  }
}