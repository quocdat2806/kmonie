import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedType = 'Tất cả';
  final List<String> types = ['Tất cả', 'Chi tiêu', 'Thu nhập', 'Chuyển khoản'];

  String selectedCategory = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('Tìm kiếm'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Type filter
              const Text("Kiểu", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: types.map((type) {
                  final isSelected = type == selectedType;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedType = type),
                    selectedColor: Colors.yellow[700],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.black87,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Category filter
              const Text(
                "Danh mục",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Tất cả'),
                    selected: selectedCategory == 'Tất cả',
                    onSelected: (_) =>
                        setState(() => selectedCategory = 'Tất cả'),
                    selectedColor: Colors.yellow[700],
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: selectedCategory == 'Tất cả'
                          ? Colors.black
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // xử lý thêm danh mục
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow[700],
                      ),
                      child: const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          selectedType = 'Tất cả';
                          selectedCategory = 'Tất cả';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text(''),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Gửi filter về hoặc thực hiện tìm kiếm
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text(''),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
