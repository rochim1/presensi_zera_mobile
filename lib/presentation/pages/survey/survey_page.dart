import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

import 'bloc/survey_state.dart';
import 'survey_status.dart';
import 'widgets/_widgets.dart';

@RoutePage()
class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SurveyCubit>()..init(),
      child: const SurveyView(),
    );
  }
}

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  String? _resolveToken(BuildContext context) {
    final tokenFromAppState = context
        .read<AppCubit>()
        .state
        .session
        .data
        ?.token;
    if (tokenFromAppState != null && tokenFromAppState.isNotEmpty) {
      return tokenFromAppState;
    }

    final tokenFromFlavor = fl.token;
    if (tokenFromFlavor != null && tokenFromFlavor.isNotEmpty) {
      return tokenFromFlavor;
    }

    return null;
  }

  Uri _buildSurveyFillUri({required String surveyId}) {
    final flavorConfig = sl<FlavorConfig>();
    final baseUrl = flavorConfig.baseApi ?? flavorConfig.values?.baseApi;
    final serverUrl = baseUrl?.replaceAll(RegExp(r'/graphql/?$'), '') ?? '';
    final uri = Uri.parse(serverUrl);
    
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: '/mobile/survey/$surveyId',
    );
  }

  void _onTapFillSurvey(BuildContext context, String surveyId) {
    final token = _resolveToken(context);

    if (token == null) {
      AppSnackbar.showError(
        context,
        'Token login tidak ditemukan. Silakan login ulang.',
      );
      return;
    }

    final surveyUri = _buildSurveyFillUri(surveyId: surveyId);
    context.router.push(InAppBrowserPageRoute(url: surveyUri.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyCubit, SurveyState>(
      builder: (context, state) {
        final cubit = context.read<SurveyCubit>();

        return Scaffold(
          appBar: const AppTopBar(
            title: 'Survey Saya',
            backgroundColor: AppColors.transparent,
          ),
          body: AppInfiniteScrollView<Survey>(
            onRefresh: cubit.onRefresh,
            state: state.surveys,
            onFetchNext: cubit.fetchNextPage,
            itemBuilder: (context, survey) {
              final surveyStatus = SurveyDisplayStatusExt.fromSurvey(survey);

              return SurveyCard(
                survey: survey,
                status: surveyStatus,
                onTapFill: surveyStatus.isFillable
                    ? () => _onTapFillSurvey(context, survey.id)
                    : null,
              );
            },
            separatorBuilder: (context, index) => AppDimens.h12.hSpace,
            loadingBuilder: (context) => SliverList.separated(
              itemBuilder: (context, index) => const SurveyCard.shimmer(),
              separatorBuilder: (context, index) => AppDimens.h12.hSpace,
              itemCount: 5,
            ),
          ),
        );
      },
    );
  }
}
