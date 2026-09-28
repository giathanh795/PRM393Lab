import 'package:flutter/material.dart';

// Exercise 2: Input Widgets - Slider, Switch, RadioListTile, DatePicker
// Goal: Build interactive UI that lets users control values.
class Exercise2InputWidgets extends StatefulWidget {
  const Exercise2InputWidgets({super.key});

  @override
  State<Exercise2InputWidgets> createState() => _Exercise2InputWidgetsState();
}

class _Exercise2InputWidgetsState extends State<Exercise2InputWidgets> {
  // Slider value
  double _sliderValue = 50.0;

  // Switch value
  bool _switchValue = false;

  // RadioListTile: chọn thể loại phim
  String _selectedGenre = 'Action';
  final List<String> _genres = ['Action', 'Comedy', 'Drama', 'Sci-Fi'];

  // DatePicker
  DateTime? _selectedDate;

  // Hiển thị DatePicker khi nhấn nút
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Input Widgets'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- SLIDER --------
            const Text(
              '🎚 Slider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Volume: ${_sliderValue.toInt()}%',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              label: '${_sliderValue.toInt()}%',
              activeColor: Colors.teal,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),

            const Divider(height: 32),

            // -------- SWITCH --------
            const Text(
              '🔄 Switch',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _switchValue ? 'Dark Mode: BẬT' : 'Dark Mode: TẮT',
                  style: TextStyle(
                    fontSize: 14,
                    color: _switchValue ? Colors.deepPurple : Colors.grey,
                  ),
                ),
                Switch(
                  value: _switchValue,
                  activeThumbColor: Colors.teal,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),

            const Divider(height: 32),

            // -------- RADIO LIST TILE --------
            const Text(
              '🎬 RadioListTile - Chọn thể loại phim',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Tạo RadioListTile cho mỗi thể loại
            // ignore: deprecated_member_use
            ...(_genres.map(
              (genre) => RadioListTile<String>(
                title: Text(genre),
                value: genre,
                groupValue: _selectedGenre, // ignore: deprecated_member_use
                onChanged: (value) { // ignore: deprecated_member_use
                  setState(() {
                    _selectedGenre = value!;
                  });
                },
              ),
            )),
            Text(
              'Đã chọn: $_selectedGenre',
              style: const TextStyle(fontSize: 14, color: Colors.teal, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 32),

            // -------- DATE PICKER --------
            const Text(
              '📅 DatePicker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Chưa chọn ngày'
                        : 'Ngày đã chọn: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Chọn ngày'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // -------- SUMMARY CARD --------
            Card(
              elevation: 3,
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Tóm tắt giá trị hiện tại',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text('Volume: ${_sliderValue.toInt()}%'),
                    Text('Dark Mode: ${_switchValue ? "Bật" : "Tắt"}'),
                    Text('Genre: $_selectedGenre'),
                    Text(
                      'Ngày: ${_selectedDate == null ? "Chưa chọn" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
