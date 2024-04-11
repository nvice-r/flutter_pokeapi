abstract class Paging<T> {
  final int? count;
  final List<T> results;
  final String? next;
  final String? previous;

  Paging(
      {required this.count,
      required this.results,
      required this.next,
      required this.previous});
}

extension PagingExts on Paging {
  bool hasNext() {
    return next?.isNotEmpty ?? false;
  }

  bool hasPrevious() {
    return previous?.isNotEmpty ?? false;
  }
}
