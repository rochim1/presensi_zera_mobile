import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:presensi_data/presensi_data.dart';

// ─── State ──────────────────────────────────────────

class LogbookState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<LogbookEntry> logbooks;
  final String? errorMessage;
  final String? successMessage;
  final DateTime selectedDate;

  final List<String> categories;
  final bool? isLoadingCategories;
  final String? categoryError;
  final bool showingAllEmployees;
  final List<LogbookUserSummary> userSummaries;
  final Map<String, List<LogbookEntry>> userLogbooks;
  final Set<String> loadingUserIds;
  final Map<String, String> userLoadErrors;
  final String expandedUserId;

  const LogbookState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.logbooks = const [],
    this.errorMessage,
    this.successMessage,
    required this.selectedDate,
    this.categories = const [],
    this.isLoadingCategories = false,
    this.categoryError,
    this.showingAllEmployees = false,
    this.userSummaries = const [],
    this.userLogbooks = const {},
    this.loadingUserIds = const {},
    this.userLoadErrors = const {},
    this.expandedUserId = '',
  });

  /// Logbooks grouped by tanggal_log
  Map<String, List<LogbookEntry>> get groupedLogbooks {
    final groups = <String, List<LogbookEntry>>{};
    for (final log in logbooks) {
      groups.putIfAbsent(log.tanggalLog, () => []).add(log);
    }
    // Sort each group by jam_mulai
    for (final entries in groups.values) {
      entries.sort((a, b) => (a.jamMulai ?? '').compareTo(b.jamMulai ?? ''));
    }
    return groups;
  }

  LogbookState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<LogbookEntry>? logbooks,
    String? errorMessage,
    String? successMessage,
    DateTime? selectedDate,
    List<String>? categories,
    bool? isLoadingCategories,
    String? categoryError,
    bool? showingAllEmployees,
    List<LogbookUserSummary>? userSummaries,
    Map<String, List<LogbookEntry>>? userLogbooks,
    Set<String>? loadingUserIds,
    Map<String, String>? userLoadErrors,
    String? expandedUserId,
  }) {
    return LogbookState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      logbooks: logbooks ?? this.logbooks,
      errorMessage: errorMessage,
      successMessage: successMessage,
      selectedDate: selectedDate ?? this.selectedDate,
      categories: categories ?? this.categories,
      isLoadingCategories:
          isLoadingCategories ?? this.isLoadingCategories ?? false,
      categoryError: categoryError,
      showingAllEmployees: showingAllEmployees ?? this.showingAllEmployees,
      userSummaries: userSummaries ?? this.userSummaries,
      userLogbooks: userLogbooks ?? this.userLogbooks,
      loadingUserIds: loadingUserIds ?? this.loadingUserIds,
      userLoadErrors: userLoadErrors ?? this.userLoadErrors,
      expandedUserId: expandedUserId ?? this.expandedUserId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    logbooks,
    errorMessage,
    successMessage,
    selectedDate,
    categories,
    isLoadingCategories,
    categoryError,
    showingAllEmployees,
    userSummaries,
    userLogbooks,
    loadingUserIds,
    userLoadErrors,
    expandedUserId,
  ];
}

// ─── Cubit ──────────────────────────────────────────

class LogbookCubit extends Cubit<LogbookState> {
  final LogbookRemoteDatasource remoteDatasource;

  LogbookCubit({required this.remoteDatasource})
    : super(LogbookState(selectedDate: DateTime.now()));

  String _messageFromError(Object error) {
    if (error is GraphQlException) {
      return error.message?.trim().isNotEmpty == true
          ? error.message!.trim()
          : 'Terjadi kesalahan saat memproses logbook';
    }
    return error.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> init() async {
    await fetchCategories();
    await fetchLogbooks();
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(isLoadingCategories: true, categoryError: null));
    try {
      final categories = await remoteDatasource.getCategories();
      emit(
        state.copyWith(
          categories: categories,
          isLoadingCategories: false,
          categoryError: categories.isEmpty
              ? 'Kategori logbook belum tersedia'
              : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCategories: false,
          categoryError: 'Gagal memuat kategori logbook',
        ),
      );
    }
  }

  Future<String?> addCategory(String name) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) return null;
    try {
      final createdName = await remoteDatasource.createCategory(normalizedName);
      final categories = {...state.categories, createdName}.toList();
      emit(
        state.copyWith(
          categories: categories,
          categoryError: null,
          successMessage: 'Kategori logbook berhasil ditambahkan',
        ),
      );
      return createdName;
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Gagal menambahkan kategori logbook: $e'),
      );
      return null;
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    emit(state.copyWith(selectedDate: date));
    await fetchLogbooks();
  }

  Future<void> setShowingAllEmployees(bool value) async {
    emit(state.copyWith(showingAllEmployees: value));
    await fetchLogbooks();
  }

  final int _limit = 15;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoadingNext = false;

  bool get hasReachedMax => _hasReachedMax;
  bool get isLoadingNext => _isLoadingNext;

  Future<void> fetchLogbooks() async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    _currentPage = 1;
    _hasReachedMax = false;

    try {
      final date = state.selectedDate;
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      if (state.showingAllEmployees) {
        final summaries = await remoteDatasource.getUserSummaries(
          startDate: dateStr,
          endDate: dateStr,
        );
        emit(
          state.copyWith(
            isLoading: false,
            logbooks: const [],
            userSummaries: summaries,
            userLogbooks: const {},
            loadingUserIds: const {},
            userLoadErrors: const {},
            expandedUserId: '',
          ),
        );
        return;
      }

      final logbooks = await remoteDatasource.getAllLogbook(
        page: _currentPage,
        limit: _limit,
        startDate: dateStr,
        endDate: dateStr,
        allUsers: state.showingAllEmployees,
      );

      _hasReachedMax = logbooks.length < _limit;
      emit(
        state.copyWith(
          isLoading: false,
          logbooks: logbooks,
          userSummaries: const [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> toggleUserLogbooks(String userId) async {
    if (state.expandedUserId == userId) {
      emit(state.copyWith(expandedUserId: ''));
      return;
    }
    emit(state.copyWith(expandedUserId: userId));
    if (state.userLogbooks.containsKey(userId) ||
        state.loadingUserIds.contains(userId)) {
      return;
    }
    await fetchUserLogbooks(userId);
  }

  Future<void> fetchUserLogbooks(String userId) async {
    if (userId.isEmpty) return;
    final loading = {...state.loadingUserIds, userId};
    final errors = Map<String, String>.from(state.userLoadErrors)
      ..remove(userId);
    emit(state.copyWith(loadingUserIds: loading, userLoadErrors: errors));
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);
      final entries = await remoteDatasource.getAllLogbook(
        page: 1,
        limit: 100,
        startDate: dateStr,
        endDate: dateStr,
        userId: userId,
      );
      final userLogbooks = Map<String, List<LogbookEntry>>.from(
        state.userLogbooks,
      )..[userId] = entries;
      final updatedLoading = {...state.loadingUserIds}..remove(userId);
      emit(
        state.copyWith(
          userLogbooks: userLogbooks,
          loadingUserIds: updatedLoading,
        ),
      );
    } catch (e) {
      final updatedLoading = {...state.loadingUserIds}..remove(userId);
      final updatedErrors = Map<String, String>.from(state.userLoadErrors)
        ..[userId] = 'Gagal memuat detail logbook';
      emit(
        state.copyWith(
          loadingUserIds: updatedLoading,
          userLoadErrors: updatedErrors,
        ),
      );
    }
  }

  Future<void> fetchNextPage() async {
    if (_hasReachedMax || _isLoadingNext || state.isLoading) return;
    if (state.logbooks.isEmpty) return;

    _isLoadingNext = true;
    // Emit state to trigger rebuild if needed, though we don't have a loadingNext flag in state yet.
    // For simplicity with Equatable, we'll just fetch and append.

    try {
      final date = state.selectedDate;
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      _currentPage++;

      final newLogbooks = await remoteDatasource.getAllLogbook(
        page: _currentPage,
        limit: _limit,
        startDate: dateStr,
        endDate: dateStr,
        allUsers: state.showingAllEmployees,
      );

      _hasReachedMax = newLogbooks.length < _limit;
      final updatedList = List<LogbookEntry>.from(state.logbooks)
        ..addAll(newLogbooks);
      emit(state.copyWith(logbooks: updatedList));
    } catch (e) {
      _currentPage--;
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      _isLoadingNext = false;
    }
  }

  Future<bool> addLogbook({
    required String judulTugas,
    String? deskripsi,
    String? kategoriTugas,
    String? jamMulai,
    String? jamSelesai,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);
      final input = <String, dynamic>{
        'tanggal_log': dateStr,
        'judul_tugas': judulTugas,
        'deskripsi': deskripsi ?? '',
        if (kategoriTugas != null && kategoriTugas.trim().isNotEmpty)
          'kategori_tugas': kategoriTugas,
        if (jamMulai != null && jamMulai.trim().isNotEmpty)
          'jam_mulai': jamMulai,
        if (jamSelesai != null && jamSelesai.trim().isNotEmpty)
          'jam_selesai': jamSelesai,
      };
      await remoteDatasource.createLogbook(input);
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Logbook berhasil ditambahkan',
        ),
      );
      await fetchLogbooks();
      return true;
    } catch (e) {
      emit(
        state.copyWith(isSubmitting: false, errorMessage: _messageFromError(e)),
      );
      return false;
    }
  }

  Future<bool> updateLogbook({
    required String id,
    required String judulTugas,
    String? deskripsi,
    String? kategoriTugas,
    String? jamMulai,
    String? jamSelesai,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(state.selectedDate);
      await remoteDatasource.updateLogbook({
        '_id': id,
        'tanggal_log': dateStr,
        'judul_tugas': judulTugas,
        'deskripsi': deskripsi ?? '',
        'kategori_tugas': kategoriTugas,
        'jam_mulai': jamMulai,
        'jam_selesai': jamSelesai,
      });
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Logbook berhasil diperbarui',
        ),
      );
      await fetchLogbooks();
      return true;
    } catch (e) {
      emit(
        state.copyWith(isSubmitting: false, errorMessage: _messageFromError(e)),
      );
      return false;
    }
  }

  Future<void> deleteLogbookEntry(String id) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      await remoteDatasource.deleteLogbook(id);
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'Logbook berhasil dihapus',
        ),
      );
      await fetchLogbooks();
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
