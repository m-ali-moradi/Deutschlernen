class AppUiText {
  const AppUiText(this.displayLanguage);

  final String displayLanguage;

  bool get isEnglish => displayLanguage != 'de';

  String either({required String german, required String english}) {
    return isEnglish ? english : german;
  }
}
