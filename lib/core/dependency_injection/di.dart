import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';
// import 'di.config.dart';

GetIt injector = GetIt.asNewInstance();

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
  externalPackageModulesBefore: [],
)
Future<void> configureDependencies({
  @factoryParam String? environment,
  EnvironmentFilter? environmentFilter,
}) async =>
    await init(
      injector,
      environment: environment,
      environmentFilter: environmentFilter,
    );
