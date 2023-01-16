part of 'providers_favorite_bloc.dart';

enum ProvidersFavoriteStatus { initial, success, failure, loading }

@immutable
class ProvidersFavoriteState {
  ProvidersFavoriteState(
      {this.status = ProvidersFavoriteStatus.initial,
      this.providers = const <ProviderItemResponse>[],
      this.hasReachedMax = false,
      });

  final ProvidersFavoriteStatus status;
  final List<ProviderItemResponse> providers;
  final bool hasReachedMax;
  ProvidersFavoriteState copyWith({
    ProvidersFavoriteStatus status,
    List<ProviderItemResponse> providers,
    bool hasReachedMax,
  }) {
    return ProvidersFavoriteState(
        status: status ?? this.status,
        providers: providers ?? this.providers,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,);
  }
}
