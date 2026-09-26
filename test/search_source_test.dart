import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/search_trend_model.dart';

/// 서버 `RANKED_SOURCES = ['input', 'suggestion']` 과 같아야 한다 — 어긋나면
/// 집계가 버릴 로그를 쓰거나, 집계에 필요한 로그를 안 쓴다.
void main() {
  test('SearchSource.ranked 는 input · suggestion 만', () {
    expect(
      SearchSource.values.where((s) => s.ranked),
      [SearchSource.input, SearchSource.suggestion],
    );
  });
}
