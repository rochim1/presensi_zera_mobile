import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LoginRemoteDatasource {
  /// Login with email and password
  Future<LoginUserEntity> signIn(LoginParamsEntity params);

  /// Register new user
  Future<bool> register(RegisterParamsEntity params);

  /// Check email availability
  Future<bool> checkEmailAvailable(String email);

  /// Check username availability
  Future<bool> checkUsernameAvailable(String username);

  /// Logout current session
  Future<bool> signOut();
}

class LoginRemoteDatasourceImpl extends LoginRemoteDatasource
    with LoginGraphQl {
  final GraphQlService graphQlService;

  LoginRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<LoginUserEntity> signIn(LoginParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: signInMutation,
      variables: params.toJson(),
    );

    final map = data['Login'];
    final tk = map['token'] as String;
    final rm = map['remember_me'] ?? null;
    if (rm != null && rm.isNotEmpty) {
      final decode = Jwt.decode(rm);
      return LoginUserModel.fromJson(map, decode);
    } else {
      final decode = Jwt.decode(tk);
      return LoginUserModel.fromJson(map, decode);
    }
  }

  @override
  Future<bool> register(RegisterParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: registerMutation,
      variables: params.toJson(),
    );

    return data['CreateUser']?['_id'] != null;
  }

  @override
  Future<bool> checkEmailAvailable(String email) async {
    final data = await graphQlService.query(
      query: checkEmailAvailableQuery,
      variables: {'email': email},
    );

    return data['CheckEmailAvailable'] ?? false;
  }

  @override
  Future<bool> checkUsernameAvailable(String username) async {
    final data = await graphQlService.query(
      query: checkUsernameAvailableQuery,
      variables: {'username': username},
    );

    return data['CheckUsernameAvailable'] ?? false;
  }

  @override
  Future<bool> signOut() async {
    final data = await graphQlService.mutation(mutation: signOutMutation);

    return data['Logout']?['is_successed'] ?? false;
  }
}
