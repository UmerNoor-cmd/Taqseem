import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class PastDonationScreen extends StatefulWidget {
  const PastDonationScreen({super.key});

  @override
  State<PastDonationScreen> createState() => _PastDonationScreenState();
}

class _PastDonationScreenState extends State<PastDonationScreen> {
  DateTime _focusedDay = DateTime(2024, 5);
  DateTime _selectedDay = DateTime(2024, 5, 15);
  String _selectedTimeRange = 'This Month';
  String _selectedNGO = 'All NGOs';
  String _selectedFoodType = 'All Types';

  final List<Map<String, dynamic>> _allDonations = [
    {
      'ngo': 'FoodShare Foundation',
      'date': DateTime(2024, 5, 15, 10, 20),
      'quantity': '8 kg',
      'type': 'Fresh Vegetables + Packaged Goods',
      'status': 'Delivered',
      'foodType': 'Perishable',
      'meals': 40,
      'rating': 4.5,
    },
    {
      'ngo': 'Hunger Relief Organization',
      'date': DateTime(2024, 5, 15, 10, 30),
      'quantity': '8 kg',
      'type': 'Packaged Goods',
      'status': 'Delivered',
      'foodType': 'Non-Perishable',
      'meals': 40,
      'rating': 3.0,
    },
    {
      'ngo': 'FoodShare Foundation',
      'date': DateTime(2024, 4, 10, 9, 15),
      'quantity': '12 kg',
      'type': 'Cooked Meals',
      'status': 'Delivered',
      'foodType': 'Cooked Meal',
      'meals': 60,
      'rating': 5.0,
    },
    {
      'ngo': 'Community Kitchen',
      'date': DateTime(2024, 6, 2, 14, 0),
      'quantity': '15 kg',
      'type': 'Fresh Vegetables',
      'status': 'Delivered',
      'foodType': 'Perishable',
      'meals': 75,
      'rating': 4.0,
    },
  ];

  List<Map<String, dynamic>> get _filteredDonations {
    return _allDonations.where((donation) {
      final now = DateTime.now();
      final isInTimeRange =
          _selectedTimeRange == 'This Month'
              ? donation['date'].month == _focusedDay.month &&
                  donation['date'].year == _focusedDay.year
              : _selectedTimeRange == 'Last 6 Months'
              ? donation['date'].isAfter(
                DateTime(now.year, now.month - 6, now.day),
              )
              : _selectedTimeRange == 'This Year'
              ? donation['date'].year == now.year
              : true;

      final isNGOMatch =
          _selectedNGO == 'All NGOs' || donation['ngo'] == _selectedNGO;

      final isTypeMatch =
          _selectedFoodType == 'All Types' ||
          donation['foodType'] == _selectedFoodType;

      final isDateMatch =
          _selectedTimeRange == 'Specific Date'
              ? _isSameDay(donation['date'], _selectedDay)
              : true;

      return isInTimeRange && isNGOMatch && isTypeMatch && isDateMatch;
    }).toList();
  }

  int get _totalMealsServed {
    return _filteredDonations.fold(
      0,
      (sum, donation) => sum + (donation['meals'] as int),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Past Donations',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate:
                        (day) => _isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedTimeRange = 'Specific Date';
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        if (_selectedTimeRange == 'This Month') {
                          _selectedDay = focusedDay;
                        }
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Color(0xFF1B5E20),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFF1B5E20),
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextFormatter: (date, locale) => '',
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF1B5E20),
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      headerTitleBuilder: (context, date) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('MMMM').format(date),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              value: date.year,
                              items: List.generate(11, (index) {
                                final year = 2020 + index;
                                return DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _focusedDay = DateTime(
                                    value!,
                                    _focusedDay.month,
                                    _focusedDay.day,
                                  );
                                });
                              },
                              underline: Container(),
                              icon: const Icon(Icons.arrow_drop_down),
                              style: const TextStyle(
                                color: Color(0xFF1B5E20),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                      markerBuilder: (context, date, events) {
                        final hasDonation = _allDonations.any(
                          (d) => _isSameDay(d['date'], date),
                        );
                        return hasDonation
                            ? const Positioned(
                              bottom: 1,
                              child: Icon(
                                Icons.circle,
                                size: 5,
                                color: Color(0xFF1B5E20),
                              ),
                            )
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Donation Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Donations',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_filteredDonations.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Meals Served',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_totalMealsServed meals',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filters
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _selectedTimeRange,
                          items: const [
                            'This Month',
                            'Last 6 Months',
                            'This Year',
                            'Specific Date',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedTimeRange = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _selectedNGO,
                          items: const [
                            'All NGOs',
                            'FoodShare Foundation',
                            'Hunger Relief Organization',
                            'Community Kitchen',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedNGO = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _selectedFoodType,
                          items: const [
                            'All Types',
                            'Perishable',
                            'Non-Perishable',
                            'Cooked Meal',
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedFoodType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Past Donations Header
                  const Text(
                    'Past donations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Donation List
                  _filteredDonations.isEmpty
                      ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No donations found for selected filters',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                      : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _filteredDonations.length,
                        itemBuilder: (context, index) {
                          final donation = _filteredDonations[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      donation['ngo'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          donation['rating'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMMM d, yyyy - h:mm a',
                                  ).format(donation['date']),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  donation['quantity'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  donation['type'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1B5E20,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    donation['status'],
                                    style: const TextStyle(
                                      color: Color(0xFF1B5E20),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
          ),

          // // Fixed Back Button at bottom
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   color: Colors.white,
          //   child: ElevatedButton(
          //     onPressed: () => Navigator.pop(context),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xFF1B5E20),
          //       foregroundColor: Colors.white,
          //       minimumSize: const Size(double.infinity, 50),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //     child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
