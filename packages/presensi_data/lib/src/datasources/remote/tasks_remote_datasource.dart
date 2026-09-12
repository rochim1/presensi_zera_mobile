import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class TasksRemoteDatasource {
  /// get all Tasks
  Future<List<TasksEntity>> getAllData(TasksFilterEntity params);

  /// get all Tasks
  Future<List<TasksEntity>> getAllPerjalanan(TasksFilterEntity params);

  /// create new Tasks
  Future<TasksEntity> postData(TasksParamsEntity params);

  /// get all Apotek
  Future<List<ApotekEntity>> getAllApotek();

  /// checking task
  Future<TasksEntity> postCompleted(TasksCompletedParamsEntity params);

  /// canceled task
  Future<TasksEntity> postCanceled(TasksCanceledParamsEntity params);
}

class TasksRemoteDatasourceImpl extends TasksRemoteDatasource
    with TasksGraphQl {
  final GraphQlService graphQlService;

  TasksRemoteDatasourceImpl(this.graphQlService);

  @override
  Future<List<TasksEntity>> getAllData(TasksFilterEntity params) async {
    final data = await graphQlService.query(
      query: getAllTask,
      variables: params.toJson(),
    );

    final listAsMap =
        data['GetAllVisitPlans']['visitPlans'] as List<dynamic>;

    return listAsMap.map((e) => TasksModel.fromJson(e)).toList();
  }

  @override
  Future<TasksEntity> postData(TasksParamsEntity params) async {
    print('GQL_PAYLOAD_DEBUG: ${params.toJson()}');
    final data = await graphQlService.mutation(
      mutation: createTask,
      variables: params.toJson(),
    );

    return TasksModel.fromJson(data['CreateVisitPlan'] as Map<String, dynamic>);
  }

  @override
  Future<List<ApotekEntity>> getAllApotek() async {
    final data = await graphQlService.query(query: getAllApotekData);

    final listAsMap = data['GetAllApotik']['apotik'] as List<dynamic>;

    return listAsMap.map((e) => ApotikModel.fromJson(e)).toList();
  }

  @override
  Future<TasksEntity> postCompleted(TasksCompletedParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: completedOrCanceledATask,
      variables: params.toJson(),
    );

    return TasksModel.fromJson(data['CompletedATask'] as Map<String, dynamic>);
  }

  @override
  Future<TasksEntity> postCanceled(TasksCanceledParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: completedOrCanceledATask,
      variables: params.toJson(),
    );

    return TasksModel.fromJson(data['CompletedATask'] as Map<String, dynamic>);
  }

  @override
  Future<List<TasksEntity>> getAllPerjalanan(TasksFilterEntity params) async {
    final data = await graphQlService.query(
      query: getAllDataPerjalanan,
      variables: params.toPerjalanan(),
    );

    final listAsMap =
        data['GetAllVisitPlans']['visitPlans'] as List<dynamic>;

    return listAsMap.map((e) => TasksModel.fromJson(e)).toList();
  }
}
