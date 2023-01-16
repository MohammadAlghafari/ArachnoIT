part of 'providers_all_bloc.dart';

enum ProvidersAllStatus { initial, success, failure, loading }

@immutable
class ProvidersAllState {
  ProvidersAllState(
      {this.status = ProvidersAllStatus.initial,
      this.providers = const <ProviderItemResponse>[],
      this.hasReachedMax = false,
      this.indexItem,
      this.removedItemIndex});

  final ProvidersAllStatus status;
  final List<ProviderItemResponse> providers;
  final bool hasReachedMax;
  final Map<String, int> indexItem;
  final int removedItemIndex;
  ProvidersAllState copyWith({
    ProvidersAllStatus status,
    List<ProviderItemResponse> providers,
    bool hasReachedMax,
    Map<String, int> indexItem,
  }) {
    return ProvidersAllState(
        status: status ?? this.status,
        providers: providers ?? this.providers,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        indexItem: indexItem ?? this.indexItem,
        removedItemIndex: removedItemIndex ?? this.removedItemIndex);
  }
}