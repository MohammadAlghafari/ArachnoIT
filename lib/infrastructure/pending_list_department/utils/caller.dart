abstract class Caller<T, V> {
  Future<V> call(T param);
}