import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/config.dart';

class JobCalendarScreen extends StatefulWidget {
  @override
  _JobCalendarScreenState createState() => _JobCalendarScreenState();
}

class _JobCalendarScreenState extends State<JobCalendarScreen> {
  DateTime currentDate = DateTime.now();
  DateTime selectedMonth = DateTime(2025, 3); // March 2025
  int selectedDay = 9; // Currently selected day

  // ======== JSON DATA (dynamic) ========
  // Orders & vacations are mutable lists so we can edit from UI.
  final List<Map<String, dynamic>> orders = [
    {
      "date": "2025-03-11",
      "day": "THU",
      "dayNumber": 11,
      "title": "AC Installation",
      "location": "Sheela Nagar, Gajuwaka, Vizag",
      "time": "10:00 AM - 12:00 PM"
    },
    {
      "date": "2025-03-13",
      "day": "SAT",
      "dayNumber": 13,
      "title": "Wash basin installation",
      "location": "Murali Nagar, Kancharapalem, Vizag",
      "time": "02:00 PM - 04:30 PM"
    },
    {
      "date": "2025-03-14",
      "day": "SUN",
      "dayNumber": 14,
      "title": "Cassette AC repair",
      "location": "Jagadhamba Junction, Allipuram, Vizag",
      "time": "10:00 AM - 12:00 PM"
    }
  ];

  /// Updated vacations JSON to support full-day or a time range.
  /// This is what the vacation cards read from and what the edit actions update.
  final List<Map<String, dynamic>> vacations = [
    {
      "date": "2025-03-17",
      "day": "SUN",
      "dayNumber": 17,
      "isFullDay": false,
      "startTime": "10:00 AM",
      "endTime": "12:00 PM"
    },
    {
      "date": "2025-03-27",
      "day": "THU",
      "dayNumber": 27,
      "isFullDay": true,
      "startTime": null,
      "endTime": null
    }
  ];

  // ======== Helpers to read JSON ========
  List<int> getOrderDays() =>
      orders.map<int>((order) => order['dayNumber'] as int).toList();

  List<int> getVacationDays() =>
      vacations.map<int>((v) => v['dayNumber'] as int).toList();

  List<Map<String, dynamic>> getOrdersForDisplay() =>
      List<Map<String, dynamic>>.from(orders);

  // ======== CALENDAR ========
  Widget buildCalendarDay(int day, bool isCurrentMonth) {
    final isOrderDay = getOrderDays().contains(day);
    final isVacationDay = getVacationDays().contains(day);
    final isSelected = day == selectedDay && isCurrentMonth;

    final isToday = isCurrentMonth &&
        selectedMonth.year == currentDate.year &&
        selectedMonth.month == currentDate.month &&
        day == currentDate.day;

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          setState(() {
            selectedDay = day;
          });
        }
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Frosted blur ring for today's date
            if (isToday)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF4285F4).withOpacity(0.3),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

            // Solid selection background if tapped/selected
            if (isSelected)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            // Day number
            Text(
              day.toString(),
              style: TextStyle(
                color: isCurrentMonth
                    ? (isSelected ? Colors.white : Colors.black)
                    : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Dots
            if (isOrderDay && isCurrentMonth)
              const Positioned(
                bottom: 6,
                child: _StatusDot(color: Colors.green),
              ),
            if (isVacationDay && isCurrentMonth)
              const Positioned(
                bottom: 6,
                right: 8,
                child: _StatusDot(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendar() {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    // 1=Mon..7=Sun; convert to 0-based with Monday=0
    final startDayOfWeek = (firstDayOfMonth.weekday + 6) % 7;

    List<Widget> dayWidgets = [];

    // Previous month days
    final previousMonth =
    DateTime(selectedMonth.year, selectedMonth.month - 1);
    final daysInPreviousMonth =
        DateTime(previousMonth.year, previousMonth.month + 1, 0).day;

    for (int i = startDayOfWeek - 1; i >= 0; i--) {
      dayWidgets.add(buildCalendarDay(daysInPreviousMonth - i, false));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(buildCalendarDay(day, true));
    }

    // Next month fillers to 6 rows
    int remainingDays = 42 - dayWidgets.length; // 6 rows * 7 days
    for (int day = 1; day <= remainingDays; day++) {
      dayWidgets.add(buildCalendarDay(day, false));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  // ======== CARDS ========
  Widget buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date chip (green style to match Orders legend)
          _DateChip(
            day: job['day'],
            number: job['dayNumber'],
            accent: Colors.green,
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_pin, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        job['location'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      job['time'],
                      style:
                      TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVacationCard(Map<String, dynamic> v) {
    final bool isFullDay = (v['isFullDay'] ?? false) as bool;
    final String timeLabel = isFullDay
        ? 'Full day'
        : '${v['startTime'] ?? ''} - ${v['endTime'] ?? ''}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date chip (red accent to match "On vacation")
          _DateChip(
            day: v['day'],
            number: v['dayNumber'],
            accent: Colors.red,
          ),
          const SizedBox(width: 16),

          // Details
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
                    const SizedBox(width: 6),
                    Text(
                      timeLabel,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Edit icon → popup menu
          InkWell(
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
                final result = await _pickTimeRange(
                  initialStart: _parseTimeOfDay(v['startTime']) ??
                      const TimeOfDay(hour: 9, minute: 0),
                  initialEnd: _parseTimeOfDay(v['endTime']) ??
                      const TimeOfDay(hour: 17, minute: 0),
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
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.edit, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // ======== TIME RANGE PICKER (Cupertino wheels) ========
  Future<_TimeOfDayPair?> _pickTimeRange({
    required TimeOfDay initialStart,
    required TimeOfDay initialEnd,
  }) async {
    TimeOfDay start = initialStart;
    TimeOfDay end = initialEnd;

    final result = await showModalBottomSheet<_TimeOfDayPair>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: SizedBox(
              height: 360,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Set Your Time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick a time of the day',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  // Two side-by-side Cupertino pickers (Start / End)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CupertinoTimeWheel(
                          initial: start,
                          onChanged: (t) => start = t,
                          label: 'From',
                          width: 120,
                        ),
                        const SizedBox(width: 8),
                        _CupertinoTimeWheel(
                          initial: end,
                          onChanged: (t) => end = t,
                          label: 'To',
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4285F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop(_TimeOfDayPair(start, end));
                        },
                        child: const Text(
                          'Set Time',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result;
  }

  // ======== WIDGET TREE ========
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: const Text(
            'Job Calendar',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                onPressed: () {
                  // Add new job/vacation functionality as needed sk
                  Navigator.pushNamed(
                    // ignore: use_build_context_synchronously
                    context,
                    Config.createVacationRouteName,
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Calendar
              _calendarCard(),

              // Tabs below the calendar
              Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: const Color(0xFF4285F4),
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatusDot(color: Colors.green, size: 12),
                          const SizedBox(width: 8),
                          const Text('Orders'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatusDot(color: Colors.red, size: 12),
                          const SizedBox(width: 8),
                          const Text('On vacation'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Set a fixed height for tab content
                child: TabBarView(
                  children: [
                    // ===== Orders Tab =====
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Order cards
                          ...getOrdersForDisplay().map(buildJobCard).toList(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // ===== Vacation Tab =====
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Vacation cards
                          ...vacations.map(buildVacationCard).toList(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======== Small UI helpers ========
  Widget _calendarCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                '${_getMonthName(selectedMonth.month)}, ${selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Week headers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                  .map((day) => SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          buildCalendar(),
        ],
      ),
    );
  }

  Widget _legendRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Row(
            children: const [
              _StatusDot(color: Colors.green, size: 12),
              SizedBox(width: 8),
              Text(
                'Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: const [
              _StatusDot(color: Colors.red, size: 12),
              SizedBox(width: 8),
              Text(
                'On vacation',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  // ======== Time parsing/formatting helpers ========
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
}

// ======== Small components ========
class _StatusDot extends StatelessWidget {
  final Color color;
  final double size;
  const _StatusDot({required this.color, this.size = 6, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String day;
  final int number;
  final Color accent;
  const _DateChip({
    Key? key,
    required this.day,
    required this.number,
    required this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            number.toString(),
            style: TextStyle(
              color: accent,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

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
  late int hour; // 1..12
  late int minute; // 0, 5, 10, ...
  late String period; // AM/PM

  @override
  void initState() {
    super.initState();
    period = widget.initial.period == DayPeriod.am ? 'AM' : 'PM';
    hour = widget.initial.hourOfPeriod == 0 ? 12 : widget.initial.hourOfPeriod;
    minute = 0; // Set minutes to 0 by default
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
          Text(
            widget.label,
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hour picker - reduced width
                    SizedBox(
                      width: constraints.maxWidth * 0.5, // Use 50% of available width
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(initialItem: (hour - 1)),
                        onSelectedItemChanged: (i) {
                          setState(() => hour = i + 1);
                          _emit();
                        },
                        children: List.generate(
                          12,
                              (i) => Center(
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(fontSize: 18), // Reduced font size
                            ),
                          ),
                        ),
                      ),
                    ),
                    // AM/PM picker - reduced width
                    SizedBox(
                      width: constraints.maxWidth * 0.4, // Use 40% of available width
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: period == 'AM' ? 0 : 1,
                        ),
                        onSelectedItemChanged: (i) {
                          setState(() => period = i == 0 ? 'AM' : 'PM');
                          _emit();
                        },
                        children: const [
                          Center(
                            child: Text(
                              'AM',
                              style: TextStyle(fontSize: 16), // Reduced font size
                            ),
                          ),
                          Center(
                            child: Text(
                              'PM',
                              style: TextStyle(fontSize: 16), // Reduced font size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
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