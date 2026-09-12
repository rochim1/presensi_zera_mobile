mixin SurveyGraphql {
  String get getMySurveysQuery =>
      r'''query GetMySurveys($pagination: pagination) {
  GetMySurveys(pagination: $pagination) {
    surveys {
      _id
      survey_code
      title
      description
      form_template_id { _id form_template_name }
      start_date
      end_date
      is_anonymous
      is_required
      total_responses
      createdAt
    }
    info_page {
      count
    }
  }
}''';
}
