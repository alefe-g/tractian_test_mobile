import 'dart:async';
import 'dart:io';

import 'package:tractian_test_mobile/api/use_api.dart';
import 'package:tractian_test_mobile/bloc/company/company_event.dart';
import 'package:tractian_test_mobile/bloc/company/company_state.dart';
import 'package:tractian_test_mobile/repositories/app_repository.dart';

class CompanyBloc {
  final _useApi = UseApi();
  final _appRespository = AppRepository();
  final _stateController = StreamController<CompanyState>();
  final _eventController = StreamController<CompanyEvent>();

  CompanyBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  Stream<CompanyState> get streamState => _stateController.stream;

  addEvent(CompanyEvent event) async {
    _eventController.sink.add(event);
  }

  _mapEventToState(CompanyEvent event) {
    if (event is FetchCompaniesEvent) {
      _fetchCompanies();
    }
  }

  _fetchCompanies() async {
    _stateController.sink.add(CompanyLoadingState());

    try {
      final companies = await _useApi.fetchCompanies();
      await _appRespository.upsertCompanies(companies: companies);
      _stateController.sink.add(CompanyLoadedState(companies));
    } on SocketException {
      final companies = await _appRespository.fetchCompanies();
      _stateController.sink.add(CompanyLoadedState(companies));
    } catch (e) {
      _stateController.sink.add(CompanyErrorState(
        'Algum erro ocorreu tentando resgatar os dados',
      ));
    }
  }

  dispose() {
    _stateController.close();
    _eventController.close();
  }
}
