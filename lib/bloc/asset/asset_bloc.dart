import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:tractian_test_mobile/api/use_api.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_event.dart';
import 'package:tractian_test_mobile/bloc/asset/asset_state.dart';
import 'package:tractian_test_mobile/models/asset_model.dart';
import 'package:tractian_test_mobile/models/location_model.dart';
import 'package:tractian_test_mobile/repositories/app_repository.dart';
import 'package:tractian_test_mobile/services/fetch_assets_tree_service.dart';

class AssetBloc {
  final _useApi = UseApi();
  final _appRespository = AppRepository();
  final _stateController = StreamController<AssetState>.broadcast();
  final _eventController = StreamController<AssetEvent>();

  AssetBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  Stream<AssetState> get streamState => _stateController.stream;

  addEvent(AssetEvent event) async {
    _eventController.sink.add(event);
  }

  _mapEventToState(AssetEvent event) {
    if (event is FetchAssetsEvent) {
      _fetchAssets(
        event.companyId,
        searchQuery: event.searchQuery,
        status: event.status,
      );
    }
  }

  _fetchAssets(
    String? companyId, {
    String? searchQuery,
    String? status,
  }) async {
    _stateController.sink.add(AssetLoadingState());
    List<AssetModel>? assets;
    List<LocationModel>? locations;
    final locationIds = <String>[];

    try {
      locations = await _useApi.fetchLocations(companyId: companyId ?? '');
      await _appRespository.upsertLocations(locations: locations);
    } on SocketException {
      locations = await _appRespository.fetchLocationsByCompanyId(
        companyId: companyId ?? '',
      );
    } catch (e) {
      _stateController.sink.add(
        AssetErrorState('Ocorreu um erro ao carregar os dados'),
      );
    }

    try {
      assets = await _useApi.fetchAssets(companyId: companyId ?? '');
      await _appRespository.upsertAssets(assets: assets);
    } on SocketException {
      if (locations != null) {
        for (final location in locations) {
          if (location.id != null) locationIds.add(location.id!);
        }
      }
      assets = await _appRespository.fetchAssetsByLocationIds(
        companyId: companyId ?? '',
        locationIds: locationIds,
      );
    } catch (e) {
      _stateController.sink.add(
        AssetErrorState('Ocorreu um erro ao tentar ersgatar os dados'),
      );
    }

    final service = FetchAssetsTreeService(
      locations: locations ?? [],
      assets: assets ?? [],
      searchQuery: searchQuery,
      status: status,
    );

    final results = await Isolate.run(() => service.locations);

    _stateController.sink.add(AssetLoadedState(results));
  }

  dispose() {
    _stateController.close();
    _eventController.close();
  }
}
