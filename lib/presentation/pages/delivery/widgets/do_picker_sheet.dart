import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';

class DoPickerSheet extends StatefulWidget {
  final List<DeliveryOrderEntity> deliveryOrders;

  const DoPickerSheet({
    super.key,
    required this.deliveryOrders,
  });

  @override
  State<DoPickerSheet> createState() => _DoPickerSheetState();
}

class _DoPickerSheetState extends State<DoPickerSheet> {
  late List<DeliveryOrderEntity> _items;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    _items = widget.deliveryOrders
        .map((e) => e.copyWith(isSelected: e.isSelected))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DeliveryOrderEntity> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((e) {
      final query = _searchQuery.toLowerCase();
      return (e.noDo?.toLowerCase().contains(query) ?? false) ||
          (e.noOrder?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  int get _selectedCount => _items.where((e) => e.isSelected).length;

  void _toggleSelection(int globalIndex) {
    setState(() {
      _items[globalIndex] = _items[globalIndex].copyWith(
        isSelected: !_items[globalIndex].isSelected,
      );
    });
  }

  void _toggleExpand(int filteredIndex) {
    setState(() {
      if (_expandedIndices.contains(filteredIndex)) {
        _expandedIndices.remove(filteredIndex);
      } else {
        _expandedIndices.add(filteredIndex);
      }
    });
  }

  int _globalIndex(DeliveryOrderEntity item) {
    return _items.indexWhere((e) => e.id == item.id);
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'dikirim':
      case 'dalam_pengiriman':
        return AppColors.blue;
      case 'selesai':
      case 'diterima':
        return AppColors.green;
      case 'batal':
      case 'ditolak':
        return AppColors.red;
      case 'pending':
      case 'menunggu':
        return AppColors.orange;
      default:
        return AppColors.grey;
    }
  }

  Color _statusBgColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'dikirim':
      case 'dalam_pengiriman':
        return AppColors.lightBlue;
      case 'selesai':
      case 'diterima':
        return AppColors.lightGreen;
      case 'batal':
      case 'ditolak':
        return AppColors.lightRed;
      case 'pending':
      case 'menunggu':
        return AppColors.lightOrange;
      default:
        return AppColors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLargeX),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMediumX),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Surat Jalan (DO)',
                      style: context.textStyle.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_items.length} surat jalan tersedia',
                      style: context.textStyle.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingMediumX,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari No. DO / No. Order...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                  _expandedIndices.clear();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: AppColors.grey.shade300),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada DO ditemukan',
                          style: context.textStyle.bodyMedium?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMediumX,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final gIdx = _globalIndex(item);
                      final isExpanded = _expandedIndices.contains(index);
                      final itemCount = item.items?.length ?? 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: item.isSelected
                              ? AppColors.primary.withValues(alpha: 0.05)
                              : Colors.white,
                          border: Border.all(
                            color: item.isSelected
                                ? AppColors.primary
                                : AppColors.borderGrey,
                            width: item.isSelected ? 1.5 : 1,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusMediumX),
                        ),
                        child: Column(
                          children: [
                            // Main card content
                            InkWell(
                              onTap: () => _toggleSelection(gIdx),
                              borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMediumX),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    AppDimens.paddingMediumX),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Checkbox
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: item.isSelected,
                                        onChanged: (_) =>
                                            _toggleSelection(gIdx),
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.noDo ?? '-',
                                                  style: context
                                                      .textStyle.titleSmall
                                                      ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color:
                                                        AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              // Status badge
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _statusBgColor(
                                                      item.status),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimens
                                                              .radiusSmall),
                                                ),
                                                child: Text(
                                                  (item.status ?? '-')
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: _statusColor(
                                                        item.status),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Order: ${item.noOrder ?? '-'}',
                                            style: context
                                                .textStyle.bodySmall
                                                ?.copyWith(
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Items count & expand
                                          if (itemCount > 0)
                                            InkWell(
                                              onTap: () =>
                                                  _toggleExpand(index),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.inventory_2_outlined,
                                                    size: 14,
                                                    color: AppColors.primary,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '$itemCount item produk',
                                                    style: context
                                                        .textStyle.bodySmall
                                                        ?.copyWith(
                                                      color:
                                                          AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Icon(
                                                    isExpanded
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    size: 18,
                                                    color: AppColors.primary,
                                                  ),
                                                ],
                                              ),
                                            )
                                          else
                                            Text(
                                              'Total: ${(item.totalItem?.toInt() ?? 0)} item',
                                              style: context
                                                  .textStyle.bodySmall
                                                  ?.copyWith(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Expandable items list
                            if (isExpanded && itemCount > 0)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  left: 52,
                                  right: AppDimens.paddingMediumX,
                                  bottom: AppDimens.paddingMediumX,
                                ),
                                padding: const EdgeInsets.all(
                                    AppDimens.paddingSmallX),
                                decoration: BoxDecoration(
                                  color: AppColors.bgSecondary,
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radiusMedium),
                                ),
                                child: Column(
                                  children: item.items!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final product = entry.value;
                                    final isLast =
                                        entry.key == item.items!.length - 1;
                                    return Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  product.namaProduk ?? '-',
                                                  style: context
                                                      .textStyle.bodySmall,
                                                ),
                                              ),
                                              Text(
                                                '${(product.qty?.toInt() ?? 0)} ${product.satuan ?? ''}',
                                                style: context
                                                    .textStyle.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!isLast)
                                          Divider(
                                            height: 1,
                                            color: AppColors.grey.shade200,
                                          ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Bottom bar
          Container(
            padding: EdgeInsets.fromLTRB(AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX, AppDimens.paddingMediumX + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.grey.shade200, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: AppButton(
                text: 'Pilih ($_selectedCount DO)',
                onPressed: _selectedCount > 0
                    ? () {
                        final selected =
                            _items.where((e) => e.isSelected).toList();
                        Navigator.of(context).pop(selected);
                      }
                    : () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
