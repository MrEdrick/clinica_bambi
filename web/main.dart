import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:ClinicaBambi/app_component.template.dart' as ng;
import 'package:intl/date_symbol_data_http_request.dart';

import 'package:firebase/firebase.dart' as fb;
import 'assets/assets.dart';

import 'main.template.dart' as self;

const useHashLS = false;
@GenerateInjector(
  routerProvidersHash, // You can use routerProviders in production
)
final InjectorFactory injector = self.injector$Injector;

void main() async {
  await config(); 

  try {
    fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId);
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }

  initializeDateFormatting("pt_BR", "/dates/").then((_) => 
    runApp(ng.AppComponentNgFactory, createInjector: injector));
  ;
}
