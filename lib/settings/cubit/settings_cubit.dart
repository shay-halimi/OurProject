import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.unknown()) {
    if (_sharedPreferences.containsKey(localeKey)) {
      emit(SettingsState.loaded(
        SettingsLocale.values[_sharedPreferences.getInt(localeKey)],
      ));
    }
  }

  static const String localeKey = 'locale';

  static SharedPreferences _sharedPreferences;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setLocale(SettingsLocale locale) async {
    await _sharedPreferences.setInt(localeKey, locale.index);

    emit(SettingsState.loaded(locale));
  }
}
