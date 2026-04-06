import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/meeting_remote_datasource.dart';
import '../data/repositories/meeting_repository_impl.dart';
import '../domain/repositories/meeting_repository.dart';
import '../domain/usecases/meeting_usecases.dart';
import '../presentation/blocs/meeting/meeting_bloc.dart';
import '../core/constants/app_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => MeetingBloc(
        createMeetingUseCase: sl(),
        joinMeetingUseCase: sl(),
        rejoinMeetingUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => CreateMeetingUseCase(sl()));
  sl.registerLazySingleton(() => JoinMeetingUseCase(sl()));
  sl.registerLazySingleton(() => RejoinMeetingUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MeetingRepository>(
    () => MeetingRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MeetingRemoteDataSource>(
    () => MeetingRemoteDataSourceImpl(dio: sl()),
  );

  print(AppConstants.baseUrl);
  // External
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    return dio;
  });
}
