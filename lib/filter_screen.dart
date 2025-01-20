import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _currentMinPrice = 0;
  double _currentMaxPrice = 100;
  List<String> _selectedCategories = [];

  final List<String> categories = [
    'Vegetables', 'Dairy', 'Bakery', 'Snacks', 'Beverages', 'Household Items'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Products'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Price Range (\$)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RangeSlider(
              min: 0,
              max: 100,
              divisions: 20,
              values: RangeValues(_currentMinPrice, _currentMaxPrice),
              labels: RangeLabels(
                '\$${_currentMinPrice.toInt()}',
                '\$${_currentMaxPrice.toInt()}'
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentMinPrice = values.start.toDouble();
                  _currentMaxPrice = values.end.toDouble();
                });
              },
            ),
            Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: categories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.green,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'minPrice': _currentMinPrice,
                  'maxPrice': _currentMaxPrice,
                  'categories': _selectedCategories,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
