mixin SalesTargetGraphQl {
  String get queryGetMySalesTarget => r'''
    query GetAllSalesTargets($filter: FilterSalesTarget, $sorting: SortingSalesTarget, $pagination: pagination) {
      GetAllSalesTargets(filter: $filter, sorting: $sorting, pagination: $pagination) {
        targets {
          _id
          periode
          salesman_id {
            _id
            name
          }
          salesman_nama
          area
          role
          target_sales
          achievement
          target_call
          actual_call
          target_ec
          actual_ec
          target_noo
          actual_noo
          status
          run_rate
          daily_breakdown {
            date
            daily_target_sales
            daily_target_call
            daily_target_ec
            daily_target_noo
            achievement
            actual_call
            actual_ec
            actual_noo
            is_working_day
            reason
          }
        }
      }
    }
  ''';
}
