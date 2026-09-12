import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class LoanRemoteDataSource {
  Future<List<EmployeeLoanModel>> getEmployeeLoans(
    GetEmployeeLoansParams params,
  );

  Future<EmployeeLoanModel> createEmployeeLoan(CreateEmployeeLoanParams params);
}

class LoanRemoteDataSourceImpl implements LoanRemoteDataSource {
  final GraphQlService graphQlService;

  LoanRemoteDataSourceImpl(this.graphQlService);

  @override
  Future<List<EmployeeLoanModel>> getEmployeeLoans(
    GetEmployeeLoansParams params,
  ) async {
    const String query = r'''
      query GetAllEmployeeLoans($filter: EmployeeLoanFilterInput, $pagination: PaginationInput) {
        GetAllEmployeeLoans(filter: $filter, pagination: $pagination) {
          items {
            _id
            loan_number
            employee_id
            employee_name
            loan_type
            loan_type_label
            principal_amount
            interest_rate
            interest_type
            loan_term_months
            monthly_payment
            total_payment
            total_interest
            outstanding_balance
            purpose
            deduction_method
            deduction_start_period
            disbursement_date
            approval_status
            approved_at
            rejected_reason
            payment_schedule {
              _id
              period
              due_date
              principal
              interest
              total
              status
              paid_date
              paid_amount
              payment_method
            }
            createdAt
            updatedAt
          }
          totalCount
        }
      }
    ''';

    final data = await graphQlService.query(
      query: query,
      variables: {
        'pagination': {'page': params.page, 'limit': params.limit},
        'filter': {
          if (params.employeeId != null) 'employee_id': params.employeeId,
          if (params.approvalStatus != null)
            'approval_status': params.approvalStatus,
          if (params.loanType != null) 'loan_type': params.loanType,
          if (params.search != null && params.search!.trim().isNotEmpty)
            'search': params.search!.trim(),
          if (params.dateFrom != null)
            'date_from': params.dateFrom!.toIso8601String().split('T').first,
          if (params.dateTo != null)
            'date_to': params.dateTo!.toIso8601String().split('T').first,
        },
      },
    );

    if (data == null) {
      throw GraphQlException(message: 'Data is null');
    }

    final getAllEmployeeLoansData = data['GetAllEmployeeLoans'];
    if (getAllEmployeeLoansData == null ||
        getAllEmployeeLoansData['items'] == null) {
      return [];
    }

    final List items = getAllEmployeeLoansData['items'];
    return items.map((e) => EmployeeLoanModel.fromJson(e)).toList();
  }

  @override
  Future<EmployeeLoanModel> createEmployeeLoan(
    CreateEmployeeLoanParams params,
  ) async {
    const String mutation = r'''
      mutation CreateAndSubmitEmployeeLoan($input: CreateEmployeeLoanInput!) {
        CreateAndSubmitEmployeeLoan(input: $input) {
          _id
          loan_number
          approval_status
          rejected_reason
        }
      }
    ''';

    final data = await graphQlService.mutation(
      mutation: mutation,
      variables: {
        'input': {
          'employee_id': params.employeeId,
          'loan_type': params.loanType,
          'principal_amount': params.principalAmount,
          'interest_rate': params.interestRate,
          'interest_type': params.interestType,
          'loan_term_months': params.loanTermMonths,
          'purpose': params.purpose,
          'deduction_method': params.deductionMethod,
          'deduction_start_period': params.deductionStartPeriod,
        },
      },
    );

    if (data == null) {
      throw GraphQlException(message: 'Data is null');
    }

    final createEmployeeLoanData = data['CreateAndSubmitEmployeeLoan'];
    if (createEmployeeLoanData == null) {
      throw GraphQlException(message: 'Failed to create loan');
    }

    return EmployeeLoanModel.fromJson(createEmployeeLoanData);
  }
}
