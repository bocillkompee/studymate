import 'api_client.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get isAuthenticated => _accessToken != null;

  Future<void> login({required String email, required String password}) async {
    // TODO(API): kirim POST /auth/login, lalu simpan token JWT dari respons.
    // Token dipakai ApiClient sebagai header Authorization: Bearer <JWT>.
    throw UnimplementedError('Login REST API belum tersedia.');
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO(API): kirim POST /auth/register dan tangani respons server.
    throw UnimplementedError('Registrasi REST API belum tersedia.');
  }

  void restoreSession(String token) {
    _accessToken = token;
    _apiClient.setAccessToken(token);
  }

  Future<void> logout() async {
    // TODO(API): panggil endpoint logout bila backend menyediakannya.
    _accessToken = null;
    _apiClient.clearAccessToken();
  }
}
