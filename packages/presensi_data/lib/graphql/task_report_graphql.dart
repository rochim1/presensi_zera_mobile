mixin TaskReportGraphQl {
  String get getMyTaskReport => r'''
    query GetAllTaskReport($filter: TaskReportFilter, $sorting: SortingTask, $pagination: pagination) {
      GetAllTaskReport(filter: $filter, sorting: $sorting, pagination: $pagination) {
        additional_info {
          total_cost
          total_order_value
          total_distance_final
          total_tasks_cancel
          total_tasks
          total_tasks_done
          total_tasks_pending
        }
      }
    }
  ''';
}
