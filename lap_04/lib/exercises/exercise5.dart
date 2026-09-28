import 'package:flutter/material.dart';

// Exercise 5: Debug & Fix Common UI Errors
// Goal: Understand common layout issues and fix them.
//
// Các lỗi được sửa:
// 1. Fix ListView inside Column bằng Expanded
// 2. Fix overflow trên màn hình nhỏ bằng SingleChildScrollView
// 3. Fix state update bằng setState()
// 4. Fix DatePicker context error bằng cách gọi từ widget tree hợp lệ
class Exercise5Debug extends StatefulWidget {
  const Exercise5Debug({super.key});

  @override
  State<Exercise5Debug> createState() => _Exercise5DebugState();
}

class _Exercise5DebugState extends State<Exercise5Debug> {
  // State cho counter (Fix 3: setState)
  int _counter = 0;

  // State cho DatePicker (Fix 4: valid context)
  DateTime? _pickedDate;

  // Toggle hiển thị section lỗi hay đã sửa
  bool _showFixed = true;

  // Fix 4: DatePicker phải được gọi từ widget tree hợp lệ
  // Không được gọi trong initState hoặc ngoài build context
  Future<void> _openDatePicker(BuildContext context) async {
    // ✅ Đúng: gọi từ một method được trigger bởi widget (Button press)
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // ✅ Fix 3: Dùng setState() để cập nhật UI sau khi chọn ngày
      setState(() {
        _pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 - Debug & Fix'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showFixed = !_showFixed),
            icon: Icon(
              _showFixed ? Icons.check_circle : Icons.bug_report,
              color: Colors.white,
            ),
            label: Text(
              _showFixed ? 'Đã Sửa' : 'Có Lỗi',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _showFixed ? _buildFixedVersion() : _buildBuggyVersion(),
    );
  }

  // ============================================================
  // PHIÊN BẢN ĐÃ SỬA (Fixed Version)
  // ============================================================
  Widget _buildFixedVersion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner
        Container(
          width: double.infinity,
          color: Colors.green[50],
          padding: const EdgeInsets.all(12),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '✅ Phiên bản ĐÃ SỬA - Tất cả lỗi đã được fix',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FIX 3: setState() hoạt động đúng
              const Text(
                'Fix 3: setState() - Counter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Giá trị: $_counter', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _counter++), // ✅ setState
                    child: const Text('Tăng'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => setState(() => _counter = 0),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // FIX 4: DatePicker context đúng
              const Text(
                'Fix 4: DatePicker - context hợp lệ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    _pickedDate == null
                        ? 'Chưa chọn ngày'
                        : '${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    // ✅ Gọi từ onPressed - context hợp lệ
                    onPressed: () => _openDatePicker(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Chọn ngày'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'Fix 1: ListView inside Column (Expanded)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const Text('→ Dùng Expanded bao quanh ListView', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),

        // FIX 1: Expanded bao quanh ListView.builder - tránh lỗi "unbounded height"
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 8,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Text('${index + 1}', style: TextStyle(color: Colors.green[800])),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: Text('ListView item - index $index'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PHIÊN BẢN CÓ LỖI (Buggy Version - để so sánh)
  // ============================================================
  Widget _buildBuggyVersion() {
    return SingleChildScrollView(
      // FIX 2: SingleChildScrollView - tránh overflow trên màn hình nhỏ
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.red[50],
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                Icon(Icons.bug_report, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '❌ Phiên bản CÓ LỖI - Nhấn nút toggle để xem bản đã sửa',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _errorCard(
                  title: 'Lỗi 1: ListView inside Column không có Expanded',
                  code: 'Column(\n  children: [\n    ListView(...) // ❌ Lỗi!\n  ]\n)',
                  fix: 'Bọc ListView trong Expanded:\nExpanded(\n  child: ListView(...) // ✅\n)',
                ),
                _errorCard(
                  title: 'Lỗi 2: Overflow trên màn hình nhỏ',
                  code: 'Column(\n  children: [\n    // nhiều widget cao\n  ]\n)',
                  fix: 'SingleChildScrollView(\n  child: Column(...) // ✅\n)',
                ),
                _errorCard(
                  title: 'Lỗi 3: Quên setState() khi update state',
                  code: 'void _increment() {\n  _counter++; // ❌ UI không cập nhật!\n}',
                  fix: 'void _increment() {\n  setState(() {\n    _counter++; // ✅\n  });\n}',
                ),
                _errorCard(
                  title: 'Lỗi 4: DatePicker context không hợp lệ',
                  code: 'initState() {\n  showDatePicker(context: context); // ❌\n}',
                  fix: 'onPressed: () {\n  showDatePicker(context: context); // ✅\n}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard({required String title, required String code, required String fix}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red[50],
              child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.green[50],
              child: Text(fix, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
