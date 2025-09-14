import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Complete SetOnVacationScreen (single file)
class SetOnVacationScreen extends StatefulWidget {
  const SetOnVacationScreen({Key? key}) : super(key: key);

  @override
  State<SetOnVacationScreen> createState() => _SetOnVacationScreenState();
}

class _SetOnVacationScreenState extends State<SetOnVacationScreen> {
  DateTime currentDate = DateTime.now();
  DateTime selectedMonth = DateTime.now();

  // Map keyed by dayNumber -> vacation details
  final Map<int, Map<String, dynamic>> vacations = {};

  void _prevMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    });
  }

  void _toggleVacationForDay(int day, bool isCurrentMonth) {
    if (!isCurrentMonth) return;
    setState(() {
      if (vacations.containsKey(day)) {
        vacations.remove(day);
      } else {
        final dt = DateTime(selectedMonth.year, selectedMonth.month, day);
        vacations[day] = {
          'date': dt,
          'day': _weekdayShort(dt.weekday),
          'dayNumber': day,
          'isFullDay': true,
          'startTime': null,
          'endTime': null,
        };
      }
    });
  }

  Widget buildCalendarDay(int day, bool isCurrentMonth) {
    final isVacationDay = vacations.containsKey(day) && isCurrentMonth;
    final isToday = isCurrentMonth &&
        selectedMonth.year == currentDate.year &&
        selectedMonth.month == currentDate.month &&
        day == currentDate.day;

    return GestureDetector(
      onTap: () => _toggleVacationForDay(day, isCurrentMonth),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isToday && !isVacationDay)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000).withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

            if (isVacationDay)
              Container(
                width: 35,
                height:35,
                decoration: BoxDecoration(
                  color: Colors.red, // red
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            Text(
              day.toString(),
              style: TextStyle(
                color: isCurrentMonth
                    ? (isVacationDay ? Colors.white : Colors.black87)
                    : Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendarGrid() {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final firstDayOfMonth =
    DateTime(selectedMonth.year, selectedMonth.month, 1);
    final startDayOfWeek = (firstDayOfMonth.weekday + 6) % 7;

    List<Widget> dayWidgets = [];

    final prevMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    final daysInPrev =
        DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    for (int i = startDayOfWeek - 1; i >= 0; i--) {
      final day = daysInPrev - i;
      dayWidgets.add(buildCalendarDay(day, false));
    }

    for (int d = 1; d <= daysInMonth; d++) {
      dayWidgets.add(buildCalendarDay(d, true));
    }

    int remaining = 42 - dayWidgets.length;
    for (int i = 1; i <= remaining; i++) {
      dayWidgets.add(buildCalendarDay(i, false));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: dayWidgets,
    );
  }

  String _getMonthName(int m) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[m];
  }

  String _weekdayShort(int w) {
    switch (w) {
      case DateTime.monday:
        return 'MON';
      case DateTime.tuesday:
        return 'TUE';
      case DateTime.wednesday:
        return 'WED';
      case DateTime.thursday:
        return 'THU';
      case DateTime.friday:
        return 'FRI';
      case DateTime.saturday:
        return 'SAT';
      case DateTime.sunday:
        return 'SUN';
      default:
        return '';
    }
  }

  Widget _calendarCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 30),
                onPressed: _prevMonth,
              ),
              Text(
                '${_getMonthName(selectedMonth.month)}, ${selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 30),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8FEEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                  .map((d) => SizedBox(
                width: 40,
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget buildVacationCard(Map<String, dynamic> v) {
    final bool isFullDay = (v['isFullDay'] ?? true) as bool;
    final String timeLabel =
    isFullDay ? 'Full day' : '${v['startTime'] ?? ''} - ${v['endTime'] ?? ''}';
    final DateTime dt = v['date'] as DateTime;
    final String dayLabel = _weekdayShort(dt.weekday);
    final int dayNumber = dt.day;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDD2C00).withOpacity(0.12)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayLabel,
                  style: const TextStyle(
                    color: Color(0xFFDD2C00),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dayNumber.toString(),
                  style: const TextStyle(
                    color: Color(0xFFDD2C00),
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'On Vacation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              onTapDown: (details) async {
                final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  items: [
                    const PopupMenuItem(
                      value: 'full',
                      child: Text('Set Full Day'),
                    ),
                    const PopupMenuItem(
                      value: 'time',
                      child: Text('Set Time'),
                    ),
                  ],
                );
                if (selected == 'full') {
                  setState(() {
                    v['isFullDay'] = true;
                    v['startTime'] = null;
                    v['endTime'] = null;
                  });
                } else if (selected == 'time') {
                  final initialStart =
                      _parseTimeOfDay(v['startTime']) ?? const TimeOfDay(hour: 9, minute: 0);
                  final initialEnd =
                      _parseTimeOfDay(v['endTime']) ?? const TimeOfDay(hour: 17, minute: 0);
                  final result = await _pickTimeRange(
                    initialStart: initialStart,
                    initialEnd: initialEnd,
                  );
                  if (result != null) {
                    setState(() {
                      v['isFullDay'] = false;
                      v['startTime'] = _formatTimeOfDay(result.item1);
                      v['endTime'] = _formatTimeOfDay(result.item2);
                    });
                  }
                }
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:2),
                  child: Text('Set Time'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<_TimeOfDayPair?> _pickTimeRange({
    required TimeOfDay initialStart,
    required TimeOfDay initialEnd,
  }) async {
    TimeOfDay start = initialStart;
    TimeOfDay end = initialEnd;

    final result = await showModalBottomSheet<_TimeOfDayPair>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 360,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                const Text('Set Your Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Pick a time of the day', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CupertinoTimeWheel(
                        initial: start,
                        onChanged: (t) => start = t,
                        label: 'From',
                        width: 140,
                      ),
                      const SizedBox(width: 8),
                      _CupertinoTimeWheel(
                        initial: end,
                        onChanged: (t) => end = t,
                        label: 'To',
                        width: 140,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDD2C00),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(_TimeOfDayPair(start, end)),
                      child: const Text('Set Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return result;
  }

  static TimeOfDay? _parseTimeOfDay(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(' ');
    if (parts.length != 2) return null;
    final hm = parts[0].split(':');
    if (hm.length != 2) return null;
    int hour = int.tryParse(hm[0]) ?? 0;
    int minute = int.tryParse(hm[1]) ?? 0;
    final ampm = parts[1].toUpperCase();
    if (ampm == 'PM' && hour < 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final mm = t.minute.toString().padLeft(2, '0');
    final suffix = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$mm $suffix';
  }

  void _onSave() {
    final selectedDates = vacations.values.map((v) {
      final dt = v['date'] as DateTime;
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}'
          ' (${v['isFullDay'] ? 'Full day' : '${v['startTime']} - ${v['endTime']}'})';
    }).toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${selectedDates.length} vacation day(s)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = vacations.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Set On Vacation', style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _calendarCard(context),
              const SizedBox(height: 16),
              // --- Fixed: create sorted list first, then map to widgets ---
              if (vacations.isNotEmpty)
                Builder(builder: (_) {
                  final sortedVacations = vacations.values.toList()
                    ..sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
                  return Column(
                    children: sortedVacations.map<Widget>((v) => buildVacationCard(v)).toList(),
                  );
                }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: hasSelection ? _onSave : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasSelection ? const Color(0xFFDD2C00) : Colors.grey.shade300,
              foregroundColor: hasSelection ? Colors.white : Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
            ),
            child: const Text('Update and Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

/* small components used by time picker */

class _CupertinoTimeWheel extends StatefulWidget {
  final TimeOfDay initial;
  final ValueChanged<TimeOfDay> onChanged;
  final String label;
  final double width;

  const _CupertinoTimeWheel({
    Key? key,
    required this.initial,
    required this.onChanged,
    required this.label,
    this.width = 100,
  }) : super(key: key);

  @override
  State<_CupertinoTimeWheel> createState() => _CupertinoTimeWheelState();
}

class _CupertinoTimeWheelState extends State<_CupertinoTimeWheel> {
  late int hour;
  late int minute;
  late String period;

  @override
  void initState() {
    super.initState();
    period = widget.initial.period == DayPeriod.am ? 'AM' : 'PM';
    hour = widget.initial.hourOfPeriod == 0 ? 12 : widget.initial.hourOfPeriod;
    minute = widget.initial.minute;
  }

  void _emit() {
    int h24 = hour % 12;
    if (period == 'PM') h24 += 12;
    widget.onChanged(TimeOfDay(hour: h24, minute: minute));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(widget.label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.55,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(initialItem: hour - 1),
                      onSelectedItemChanged: (i) {
                        setState(() => hour = i + 1);
                        _emit();
                      },
                      children: List.generate(12, (i) => Center(child: Text('${i + 1}', style: const TextStyle(fontSize: 18)))),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.4,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(initialItem: period == 'AM' ? 0 : 1),
                      onSelectedItemChanged: (i) {
                        setState(() => period = i == 0 ? 'AM' : 'PM');
                        _emit();
                      },
                      children: const [Center(child: Text('AM')), Center(child: Text('PM'))],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TimeOfDayPair {
  final TimeOfDay item1;
  final TimeOfDay item2;
  _TimeOfDayPair(this.item1, this.item2);
}
