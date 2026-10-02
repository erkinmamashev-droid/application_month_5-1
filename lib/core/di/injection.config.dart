import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:news_app/core/di/register_module.dart' as _i588;
import 'package:news_app/data/remote/api/news_data_source.dart' as _i608;
import 'package:news_app/data/remote/impl/news_data_source_impl.dart' as _i273;
import 'package:news_app/data/repo_impl/news_repository_impl.dart' as _i763;
import 'package:news_app/domain/repo/news_repository.dart' as _i144;
import 'package:news_app/ui/bloc/news_bloc.dart' as _i768;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i608.NewsDataSource>(
      () => _i273.NewsDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i144.NewsRepository>(
      () => _i763.NewsRepositoryImpl(dataSource: gh<_i608.NewsDataSource>()),
    );
    gh.factory<_i768.NewsBloc>(
      () => _i768.NewsBloc(newsRepository: gh<_i144.NewsRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i588.RegisterModule {}
