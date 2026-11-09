class ApiClient {
  ApiClient({String? baseUrl})
    : baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'http://localhost:8080/api',
          );

  final String baseUrl;
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String token) {
    _accessToken = token;
  }

  void clearAccessToken() {
    _accessToken = null;
  }

  // TODO(API): gunakan package http dan kirim header
  // Authorization: Bearer <JWT> pada setiap request.
  //
  // Contoh untuk emulator Android:
  // --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
  //
  // Contoh untuk Chrome:
  // --dart-define=API_BASE_URL=http://localhost:8080/api
}
