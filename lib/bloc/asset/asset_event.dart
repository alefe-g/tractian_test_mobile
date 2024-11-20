abstract class AssetEvent {}

class FetchAssetsEvent extends AssetEvent {
  final String companyId;
  final String? searchQuery;
  final String? status;

  FetchAssetsEvent(
    this.companyId, {
    this.searchQuery,
    this.status,
  });
}
