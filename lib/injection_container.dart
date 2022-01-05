import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_arch_learning/common/network/network_info.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/bloc/number_trivia_bloc.dart';

import 'common/util/type_converter.dart';
import 'number_trivia_feature/domain/repositories/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Features
  // BLoC
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: sl<GetConcreteNumberTriviaUseCase>(),
      getRandomNumberTriviaUseCase: sl<GetRandomNumberTriviaUseCase>(),
      typeConverter: sl<TypeConverter>()));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
  // Data sources
  // Shared Preferences
  sl.registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());
  sl.registerSingletonWithDependencies<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()),
      dependsOn: [SharedPreferences]);

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  // Common
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<TypeConverter>(() => TypeConverter());

  // External
  // Http client
  sl.registerLazySingleton(() => http.Client());
  // InternetConnectionChecker
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
