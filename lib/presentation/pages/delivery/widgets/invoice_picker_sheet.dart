import 'package:flutter/material.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/_presentation.dart';
import 'package:presensi_mobile/presentation/widgets/global/text_field_custom/text_formatter.dart';

class InvoicePickerSheet extends StatefulWidget {
  final List<SalesOrderEntity> invoices;
  final bool showAmountInput;

  const InvoicePickerSheet({
    super.key,
    required this.invoices,
    this.showAmountInput = false,
  });

  @override
  State<InvoicePickerSheet> createState() => _InvoicePickerSheetState();
}

class _InvoicePickerSheetState extends State<InvoicePickerSheet> {
  late List<SalesOrderEntity> _items;
  final Map<String, TextEditingController> _paymentControllers = {};

  @override
  void initState() {
    super.initState();
    _items = widget.invoices.map((e) {
      return e.copyWith(
        isSelected: e.isSelected,
        paymentAmount: e.paymentAmount,
      );
    }).toList();

    // Initialize controllers for each invoice
    for (final item in _items) {
      final key = item.id ?? item.noOrder ?? '';
      final controller = TextEditingController(
        text: item.paymentAmount > 0
            ? item.paymentAmount.toInt().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (m) => '${m[1]}.')
            : '',
      );
      _paymentControllers[key] = controller;
    }
  }

  @override
  void dispose() {
    for (final c in _paymentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _itemKey(SalesOrderEntity item) =>
      item.id ?? item.noOrder ?? '';

  int get _selectedCount => _items.where((e) => e.isSelected).length;

  double get _totalAmount {
    if (!widget.showAmountInput) {
      return _items.where((e) => e.isSelected).fold(0.0, (sum, e) => sum + (e.sisaTagihan ?? 0));
    }
    return _items.where((e) => e.isSelected).fold(0.0, (sum, e) => sum + e.paymentAmount);
  }

  bool get _isValid {
    final selected = _items.where((e) => e.isSelected).toList();
    if (selected.isEmpty) return false;
    if (!widget.showAmountInput) return true;
    return selected.any((e) => e.paymentAmount > 0);
  }

  void _toggleSelection(int index) {
    setState(() {
      final item = _items[index];
      final newSelected = !item.isSelected;
      _items[index] = item.copyWith(
        isSelected: newSelected,
        paymentAmount: newSelected ? item.paymentAmount : 0,
      );
      if (!newSelected) {
        final key = _itemKey(item);
        _paymentControllers[key]?.clear();
      }
    });
  }

  void _updatePaymentAmount(int index, String value) {
    final numericStr = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(numericStr) ?? 0;
    setState(() {
      _items[index] = _items[index].copyWith(paymentAmount: amount);
    });
  }

  void _setLunas(int index) {
    final item = _items[index];
    final sisa = item.sisaTagihan ?? 0;
    final key = _itemKey(item);

    // Format the value with dots as thousand separator
    final formatted = sisa.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

    _paymentControllers[key]?.text = formatted;
    _paymentControllers[key]?.selection = TextSelection.collapsed(
      offset: formatted.length,
    );

    setState(() {
      _items[index] = _items[index].copyWith(
        isSelected: true,
        paymentAmount: sisa.toDouble(),
      );
    });
  }

  Color _statusPembayaranColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'partial':
      case 'sebagian':
        return AppColors.orange;
      case 'unpaid':
      case 'belum_bayar':
        return AppColors.red;
      case 'paid':
      case 'lunas':
        return AppColors.green;
      default:
        return AppColors.grey;
    }
  }

  Color _statusPembayaranBgColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'partial':
      case 'sebagian':
        return AppColors.lightOrange;
      case 'unpaid':
      case 'belum_bayar':
        return AppColors.lightRed;
      case 'paid':
      case 'lunas':
        return AppColors.lightGreen;
      default:
        return AppColors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Pilih Tagihan',
                      style: context.textStyle.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_items.length} tagihan tersedia',
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
          // List
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: AppColors.grey.shade300),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada tagihan tersedia',
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
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final key = _itemKey(item);

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
                            // Main card
                            InkWell(
                              onTap: () => _toggleSelection(index),
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
                                            _toggleSelection(index),
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
                                          // No Order + Status
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.noOrder ?? '-',
                                                  style: context
                                                      .textStyle.titleSmall
                                                      ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      _statusPembayaranBgColor(
                                                          item.statusPembayaran),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimens
                                                              .radiusSmall),
                                                ),
                                                child: Text(
                                                  (item.statusPembayaran ??
                                                          '-')
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color:
                                                        _statusPembayaranColor(
                                                            item.statusPembayaran),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Total order
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                'Total Order',
                                                style: context
                                                    .textStyle.bodySmall
                                                    ?.copyWith(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${(item.totalOrder?.toInt() ?? 0).textDecimalDigit}',
                                                style: context
                                                    .textStyle.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          // Sisa tagihan
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                'Sisa Tagihan',
                                                style: context
                                                    .textStyle.bodySmall
                                                    ?.copyWith(
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${(item.sisaTagihan?.toInt() ?? 0).textDecimalDigit}',
                                                style: context
                                                    .textStyle.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Payment input (shown when selected)
                            if (item.isSelected && widget.showAmountInput)
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 52,
                                  right: AppDimens.paddingMediumX,
                                  bottom: AppDimens.paddingMediumX,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            _paymentControllers[key],
                                        keyboardType:
                                            TextInputType.number,
                                        inputFormatters: [
                                          IdrTextInputFormatter(),
                                        ],
                                        decoration: InputDecoration(
                                          prefixText: 'Rp ',
                                          prefixStyle: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          hintText: 'Masukkan nominal',
                                          hintStyle: TextStyle(
                                            color: AppColors.grey.shade400,
                                            fontSize: 13,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppDimens.radiusMedium),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppDimens.radiusMedium),
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                          isDense: true,
                                        ),
                                        onChanged: (val) =>
                                            _updatePaymentAmount(
                                                index, val),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 40,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            _setLunas(index),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppDimens.radiusMedium),
                                          ),
                                          padding: const EdgeInsets
                                              .symmetric(horizontal: 12),
                                        ),
                                        child: const Text(
                                          'Lunas',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total tagih info
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.showAmountInput ? 'Total Pembayaran' : 'Total Sisa Tagihan',
                          style: context.textStyle.bodyMedium?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          'Rp ${_totalAmount.toInt().textDecimalDigit}',
                          style: context.textStyle.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    text: 'Konfirmasi ($_selectedCount tagihan)',
                    onPressed: _isValid
                        ? () {
                            final selected = _items
                                .where((e) => e.isSelected)
                                .toList();
                            Navigator.of(context).pop(selected);
                          }
                        : () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
