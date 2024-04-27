class EnvConfig {
  static late final String aiKey;

  static void initialize({required String aiKey}) {
    EnvConfig.aiKey = aiKey;
  }
}
