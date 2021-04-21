part of 'settings_cubit.dart';

enum SettingsStatus { loading, loaded, unknown, error }

enum SettingsLocale { unknown, hebrew, english }

class SettingsState extends Equatable {
  const SettingsState._({
    this.locale = SettingsLocale.unknown,
    this.status = SettingsStatus.unknown,
  }) : assert(locale != null);

  const SettingsState.loading() : this._(status: SettingsStatus.loading);

  const SettingsState.loaded(SettingsLocale locale)
      : this._(status: SettingsStatus.loaded, locale: locale);

  const SettingsState.unknown() : this._();

  const SettingsState.error() : this._(status: SettingsStatus.error);

  final SettingsLocale locale;

  final SettingsStatus status;

  @override
  List<Object> get props => [locale, status];
}
