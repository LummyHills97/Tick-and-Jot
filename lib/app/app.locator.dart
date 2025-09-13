import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import '../services/notes_service.dart';
import '../services/todos_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => NotesService());
  locator.registerLazySingleton(() => TodosService());
}