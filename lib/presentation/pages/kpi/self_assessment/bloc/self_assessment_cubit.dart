import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'self_assessment_state.dart';

class SelfAssessmentCubit extends Cubit<SelfAssessmentState> {
  final Logger logger;
  final GetKpiAssignmentDetail getDetail;
  final SubmitSelfAssessment submitSelfAssessment;

  SelfAssessmentCubit({
    required this.logger,
    required this.getDetail,
    required this.submitSelfAssessment,
  }) : super(const SelfAssessmentState());

  Future<void> init(String assignmentId) async {
    emit(
      state.copyWith(
        assignmentId: assignmentId,
        detailState: const BaseState.loading(),
      ),
    );
    final result = await getDetail(assignmentId);

    result.fold(
      (failure) {
        emit(state.copyWith(detailState: BaseState.failure(failure)));
      },
      (data) {
        final ratings = <String, double>{};
        final comments = <String, String>{};
        for (var score in data.scores ?? []) {
          if (score.indicator != null &&
              score.indicator!.id != null &&
              score.indicator!.id!.isNotEmpty) {
            if (score.selfRating != null) {
              ratings[score.indicator!.id!] = score.selfRating!
                  .clamp(1.0, 5.0)
                  .toDouble();
            }
            comments[score.indicator!.id!] = score.catatanKaryawan ?? '';
          }
        }
        emit(
          state.copyWith(
            detailState: BaseState.success(data),
            ratings: ratings,
            comments: comments,
            globalComment: data.catatanKaryawanGlobal ?? '',
          ),
        );
      },
    );
  }

  void updateRating(String indicatorId, double rating) {
    final newRatings = Map<String, double>.from(state.ratings);
    newRatings[indicatorId] = rating;
    emit(state.copyWith(ratings: newRatings));
  }

  void updateComment(String indicatorId, String comment) {
    final newComments = Map<String, String>.from(state.comments);
    newComments[indicatorId] = comment;
    emit(state.copyWith(comments: newComments));
  }

  void updateGlobalComment(String comment) {
    emit(state.copyWith(globalComment: comment));
  }

  Future<void> submit() async {
    if (state.assignmentId.isEmpty || state.submitState.isLoading) return;

    emit(state.copyWith(submitState: const BaseState.loading()));

    final scores = state.ratings.entries
        .map(
          (e) => SelfScoreInputParams(
            indicatorId: e.key,
            selfRating: e.value,
            catatanKaryawan: state.comments[e.key],
          ),
        )
        .toList();

    final params = SubmitSelfAssessmentParams(
      assignmentId: state.assignmentId,
      scores: scores,
      catatanKaryawanGlobal: state.globalComment,
    );

    final result = await submitSelfAssessment(params);

    result.fold(
      (failure) {
        emit(state.copyWith(submitState: BaseState.failure(failure)));
      },
      (success) {
        emit(state.copyWith(submitState: const BaseState.success(null)));
      },
    );
  }
}
