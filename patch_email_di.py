import re

with open('lib/injections.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Cubits
content = re.sub(
    r"(sl\.registerFactory<ChatCreateGroupCubit>.*?createConversationUseCase: sl\(\)\);)",
    r"\1\n  // Email\n  sl.registerFactory<EmailListCubit>(() => EmailListCubit(getAllEmailUsecase: sl()));",
    content
)

# Login
content = re.sub(
    r"(sl\.registerLazySingleton\(\(\) => LoginRegister\(sl\(\)\)\);)",
    r"\1\n  sl.registerLazySingleton(() => LoginCheckEmailAvailable(sl()));",
    content
)

# Usecases
content = re.sub(
    r"(sl\.registerLazySingleton\(\(\) => ChatDisconnectWebSocketUseCase\(repository: sl\(\)\)\);)",
    r"\1\n\n  // Email\n  sl.registerLazySingleton(() => GetAllEmailUsecase(sl()));\n  sl.registerLazySingleton(() => CountUnreadEmailUsecase(repository: sl()));",
    content
)

# Repositories
content = re.sub(
    r"(sl\.registerLazySingleton<ChatRepository>\(\(\) => ChatRepositoryImpl\(remoteDataSource: sl\(\)\)\);)",
    r"\1\n\n  // Email\n  sl.registerLazySingleton<EmailRepository>(() => EmailRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));",
    content
)

# RemoteDataSource
content = re.sub(
    r"(sl\.registerLazySingleton<ChatRemoteDataSource>\(\(\) => ChatRemoteDataSourceImpl\(graphQlService: sl\(\)\)\);)",
    r"\1\n\n  // Email\n  sl.registerLazySingleton<EmailRemoteDataSource>(() => EmailRemoteDataSourceImpl(graphQlService: sl()));",
    content
)

with open('lib/injections.dart', 'w', encoding='utf-8') as f:
    f.write(content)
