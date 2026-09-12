import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/apotek/apotek_item_card.dart';

@RoutePage()
class ApotekSearchPage extends StatefulWidget {
  const ApotekSearchPage({super.key});

  @override
  State<ApotekSearchPage> createState() => _ApotekSearchPageState();
}

class _ApotekSearchPageState extends State<ApotekSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';
  bool _showSuggestions = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
      _showSuggestions = query.isEmpty;
    });

    if (query.isNotEmpty) {
      context.read<ApotekGetAllDataCubit>().onSearchData(query);
      context.read<ApotekQueryCubit>().postData(query);
    }
  }

  void _onTapSuggestion(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      _showSuggestions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ApotekGetAllDataCubit>()),
        BlocProvider(create: (context) => sl<ApotekQueryCubit>()..getAllData()),
      ],
      child: Scaffold(
        appBar: AppBarWidget(
          title: TextField(
            controller: _searchController,
            onSubmitted: _onSearchChanged,
            style: const TextStyle(
              fontSize: 19.0,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Cari outlet...',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintStyle: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: _currentQuery.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
            cursorColor: AppColors.secondary,
          ),
        ),
        body: _showSuggestions
            ? _buildSuggestions(context)
            : _buildResults(context),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ApotekQueryCubit>()..getAllData(),
      child: BlocBuilder<ApotekQueryCubit, ApotekQueryState>(
        builder: (context, state) {
          if (state.status.isLoaded) {
            return ListView.builder(
              itemCount: state.queries?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () =>
                      _onTapSuggestion(state.queries?[index].query ?? ''),
                  leading: const Icon(Icons.history_rounded),
                  minLeadingWidth: AppDimens.paddingSmall,
                  title: Text(state.queries?[index].query ?? ''),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<ApotekGetAllDataCubit>()..onSearchData(_currentQuery),
        ),
        BlocProvider(create: (context) => sl<ApotekQueryCubit>()),
      ],
      child: BlocBuilder<ApotekQueryCubit, ApotekQueryState>(
        builder: (ctxQuery, _) {
          return BlocConsumer<ApotekGetAllDataCubit, ApotekGetAllDataState>(
            listener: (context, state) {
              if (state.status.isLoaded && state.apoteks!.isNotEmpty) {
                ctxQuery.read<ApotekQueryCubit>().postData(_currentQuery);
              }
            },
            builder: (context, state) => NotificationListener(
              onNotification: (scroll) {
                if (scroll is ScrollEndNotification) {
                  if (AppUtility.isBottomNotif(scroll)) {
                    context.read<ApotekGetAllDataCubit>().onSearchData(
                      _currentQuery,
                    );
                  }
                }
                return true;
              },
              child: _setList(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _setList(BuildContext context, ApotekGetAllDataState state) {
    if (state.status.isLoaded) {
      if (state.apoteks!.isEmpty) {
        return const FailureViewWidget(
          emptyState: EmptyState.emptyList,
          failure: NotFoundFailure(message: 'Outlet tidak ditemukan'),
        );
      }

      return ListView.separated(
        itemCount: state.hasMax!
            ? state.apoteks!.length
            : state.apoteks!.length + 1,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.apoteks!.length) return const ShimmerInfinity();
          final apotek = state.apoteks?[index];

          if (apotek == null) {
            return const SizedBox.shrink();
          }

          return ApotekItemCard(
            apotek: apotek,
            onTap: () =>
                context.router.push(ApotekDetailPageRoute(apotek: apotek)),
          );
        },
        separatorBuilder: (context, index) => AppDimens.paddingMediumX.hSpace,
      );
    } else if (state.status.isNotLoaded) {
      return FailureViewWidget(failure: state.failure);
    } else {
      return ListView.separated(
        itemCount: 8,
        padding: const EdgeInsets.all(AppDimens.paddingMediumX),
        itemBuilder: (_, _) =>
            ShimmerCustom(size: Size(context.width, AppDimens.size5X)),
        separatorBuilder: (_, _) => AppDimens.paddingSmallX.hSpace,
      );
    }
  }
}
