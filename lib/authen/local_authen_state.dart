import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_authen_state.freezed.dart';

@freezed
class LocalAuthenState with _$LocalAuthenState {
  const factory LocalAuthenState({@Default(false) bool isSuccessful}) =
      _LocalAuthenState;
}
