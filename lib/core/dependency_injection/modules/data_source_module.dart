import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../app_core_factory.dart';
import '../../components/configurations/configurations.dart';

@module
abstract class DataSourceModule {
  @Named('chatBotDio')
  @prod
  Dio dioChatBot() => AppCoreFactory.createDio(Configurations.baseUrl);
}
