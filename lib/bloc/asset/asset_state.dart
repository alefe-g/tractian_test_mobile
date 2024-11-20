import 'package:tractian_test_mobile/models/location_model.dart';

abstract class AssetState {}

class AssetInitialState extends AssetState {}

class AssetLoadingState extends AssetState {}

class AssetLoadedState extends AssetState {
  final List<LocationModel> locations;
  AssetLoadedState(this.locations);
}

class AssetErrorState extends AssetState {
  final String message;
  AssetErrorState(this.message);
}