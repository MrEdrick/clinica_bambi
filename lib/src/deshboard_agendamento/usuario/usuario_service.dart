import 'usuario.dart';

class UsuarioService {
  static Usuario _usuario = null;

  Usuario get usuario => _usuario;
  set usuario(Usuario usuario) => _usuario = usuario;
}