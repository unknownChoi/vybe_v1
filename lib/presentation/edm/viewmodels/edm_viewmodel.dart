import 'package:vybe/presentation/hip_hop/viewmodels/genre_page_viewmodel.dart';

export 'package:vybe/presentation/hip_hop/viewmodels/genre_page_viewmodel.dart';

/// clubs.genre · performances.genre 에 들어가는 EDM 장르 값.
const kEdmGenre = 'EDM';

/// EDM 페이지 — 공용 [genrePageProvider] 의 EDM 인스턴스. 이름은 호출부 유지용.
final edmViewModelProvider = genrePageProvider(kEdmGenre);
