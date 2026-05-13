import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_sizer.dart';
import '../../../../shared/widgets/app_text.dart';

class CalendarBottomSheet extends StatefulWidget {
  const CalendarBottomSheet({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();
    _viewMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _prevMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizerBuilder(
      child: Builder(
        builder: (innerContext) => Container(
          height: 440.h(innerContext),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _buildContent(innerContext),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext innerContext) {
    return SizerBuilder(
      child: Builder(
        builder: (innerCtx) => ListView(
          padding: .zero,
          children: [
              
              Center(
                child: Container(
                  margin: .symmetric(vertical: 10.h(innerCtx)),
                  width: 58.w(innerCtx),
                  height: 4.h(innerCtx),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA1A5B7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: .symmetric(
                  horizontal: 16.w(innerCtx),
                  vertical: 8.h(innerCtx),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _prevMonth,
                      child: Icon(
                        Icons.chevron_left,
                        color: AppColors.textPrimary,
                        size: 26.w(innerCtx),
                      ),
                    ),
                    const Spacer(),
                    AppText(
                      DateFormat('MMM yyyy').format(_viewMonth),
                      fontSize: 16,
                      fontWeight: .w700,
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _nextMonth,
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.textPrimary,
                        size: 26.w(innerCtx),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h(innerCtx)),
              Padding(
                padding: .symmetric(horizontal: 16.w(innerCtx)),
                child: Row(
                  mainAxisAlignment: .spaceAround,
                  children:
                      const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                          .map(
                            (d) => SizedBox(
                              width: 40,
                              child: AppText(
                                d,
                                fontSize: 12,
                                fontWeight: .w700,
                                textAlign: TextAlign.center,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              SizedBox(height: 8.h(innerCtx)),
              _CalendarGrid(
                viewMonth: _viewMonth,
                selectedDate: widget.selectedDate,
                onDateSelected: widget.onDateSelected,
              ),

              SizedBox(height: 16.h(innerCtx)),
            ],
          ),
        ),
      );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.viewMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime viewMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(viewMonth.year, viewMonth.month, 1);
    final startOffset = firstDayOfMonth.weekday - 1;
    final daysInMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: .symmetric(horizontal: 16.w(context)),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            mainAxisAlignment: .spaceAround,
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final dayNum = cellIndex - startOffset + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const SizedBox(width: 40, height: 40);
              }

              final date = DateTime(viewMonth.year, viewMonth.month, dayNum);
              final isSelected =
                  date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const .symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: AppColors.calendarSelectedBorder,
                            width: 1.5,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    '$dayNum',
                    fontSize: 14,
                    fontWeight: .w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
