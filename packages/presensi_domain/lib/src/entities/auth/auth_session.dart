class AuthSession {
  final String token;
  final String appId;
  final String userId;

  const AuthSession({
    required this.token,
    required this.appId,
    required this.userId,
  });
}
