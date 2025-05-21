// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i3;
import 'package:hive_flutter/hive_flutter.dart' as _i19;
import 'package:injectable/injectable.dart' as _i2;

import '../../clean_architectures/data/data_source/remote/gpt_api.dart' as _i7;
import '../../clean_architectures/data/data_source/remote/stream_rest_api.dart'
    as _i10;
import '../../clean_architectures/data/data_source/remote/thread_api.dart'
    as _i12;
import '../../clean_architectures/data/model/chat/chat_model.dart' as _i4;
import '../../clean_architectures/data/model/conversation/conversation_model.dart'
    as _i5;
import '../../clean_architectures/data/repositories/chat_repositories_impl.dart'
    as _i16;
import '../../clean_architectures/data/repositories/conversation_repositorie_impl.dart'
    as _i18;
import '../../clean_architectures/data/repositories/thread_repositories_impl.dart'
    as _i14;
import '../../clean_architectures/domain/repositories/chat_repositories.dart'
    as _i15;
import '../../clean_architectures/domain/repositories/conversation_repositories.dart'
    as _i17;
import '../../clean_architectures/domain/repositories/thread_repositories.dart'
    as _i13;
import '../../clean_architectures/domain/usecase/chat_usecase.dart' as _i21;
import '../../clean_architectures/domain/usecase/conversation_usecase.dart'
    as _i20;
import '../../clean_architectures/domain/usecase/setting/setting_usecase.dart'
    as _i8;
import '../../clean_architectures/presentation/chat_bot/bloc/chat_bloc.dart'
    as _i23;
import '../../clean_architectures/presentation/conversation/bloc/conversation_bloc.dart'
    as _i22;
import '../services/speech_to_text_service.dart' as _i9;
import '../services/text_to_speech_service.dart' as _i11;
import 'modules/data_source_module.dart' as _i25;
import 'modules/storage_module.dart' as _i24;

const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final hiveBoxModule = _$HiveBoxModule();
  final dataSourceModule = _$DataSourceModule();
  gh.singleton<_i3.Box<_i4.ChatModel>>(() => hiveBoxModule.chatBox());
  gh.singleton<_i3.Box<_i5.ConversationModel>>(
      () => hiveBoxModule.conversationBox());
  gh.factory<_i6.Dio>(
    () => dataSourceModule.dioChatBot(),
    instanceName: 'chatBotDio',
    registerFor: {_prod},
  );
  gh.factory<_i7.GPTApi>(
      () => _i7.GPTApi(gh<_i6.Dio>(instanceName: 'chatBotDio')));
  gh.factory<_i8.SettingUseCase>(() => _i8.SettingUseCase());
  gh.factory<_i9.SpeechToTextService>(() => _i9.SpeechToTextService());
  gh.factory<_i10.StreamRestApi>(
      () => _i10.StreamRestApi(dio: gh<_i6.Dio>(instanceName: 'chatBotDio')));
  gh.factory<_i11.TextToSpeechService>(() => _i11.TextToSpeechService());
  gh.factory<_i12.ThreadApi>(() => _i12.ThreadApi(gh<_i10.StreamRestApi>()));
  gh.factory<_i13.ThreadRepositories>(() => _i14.ThreadRepositoriesImpl(
        gh<_i7.GPTApi>(),
        gh<_i12.ThreadApi>(),
      ));
  gh.factory<_i15.ChatRepositories>(
      () => _i16.ChatRepositoriesImpl(gh<_i7.GPTApi>()));
  gh.factory<_i17.ConversationRepositories>(
      () => _i18.ConversationRepositoriesImpl(
            gh<_i19.Box<_i5.ConversationModel>>(),
            gh<_i7.GPTApi>(),
          ));
  gh.factory<_i20.ConversationUserCase>(
      () => _i20.ConversationUserCase(gh<_i17.ConversationRepositories>()));
  gh.factory<_i21.ChatUseCase>(() => _i21.ChatUseCase(
        gh<_i15.ChatRepositories>(),
        gh<_i17.ConversationRepositories>(),
        gh<_i13.ThreadRepositories>(),
      ));
  gh.factory<_i22.ConversationBloc>(
      () => _i22.ConversationBloc(gh<_i20.ConversationUserCase>()));
  gh.factory<_i23.ChatBloc>(() => _i23.ChatBloc(
        gh<_i21.ChatUseCase>(),
        gh<_i9.SpeechToTextService>(),
        gh<_i11.TextToSpeechService>(),
      ));
  return getIt;
}

class _$HiveBoxModule extends _i24.HiveBoxModule {}

class _$DataSourceModule extends _i25.DataSourceModule {}
