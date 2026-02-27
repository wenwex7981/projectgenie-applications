import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AdvancedFiltersScreen extends StatefulWidget {
  const AdvancedFiltersScreen({super.key});

  @override
  State<AdvancedFiltersScreen> createState() => _AdvancedFiltersScreenState();
}

class _AdvancedFiltersScreenState extends State<AdvancedFiltersScreen> {
  RangeValues _priceRange = const RangeValues(40, 350);
  String _deliveryTime = '3 Days';
  final List<String> _selectedDomains = ['Computer Science', 'Engineering'];
  double _minRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _priceRange = const RangeValues(40, 350);
                _deliveryTime = '3 Days';
                _selectedDomains.clear();
                _minRating = 4.0;
              });
            },
            child: const Text('Reset', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriceRangeSection(),
                _buildDeliveryTimeSection(),
                _buildDomainSection(),
                _buildRatingSection(),
                _buildUniversitySection(),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildSection(
      'Price Range',
      Column(
        children: [
          const SizedBox(height: 16),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 100,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.primaryColor.withOpacity(0.1),
            labels: RangeLabels('₹${_priceRange.start.round()}', '₹${_priceRange.end.round()}'),
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceBadge('₹${_priceRange.start.round()}'),
                _buildPriceBadge('₹${_priceRange.end.round()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 13)),
    );
  }

  Widget _buildDeliveryTimeSection() {
    final times = ['<24h', '3 Days', '1 Week', 'Any'];
    return _buildSection(
      'Delivery Time',
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: times.map((t) => Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _deliveryTime = t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _deliveryTime == t ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _deliveryTime == t ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
                ),
                child: Center(
                  child: Text(
                    t,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _deliveryTime == t ? FontWeight.bold : FontWeight.w500,
                      color: _deliveryTime == t ? AppTheme.primaryColor : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildDomainSection() {
    final domains = ['Computer Science', 'Business', 'Engineering', 'Medicine', 'Social Sciences', 'Arts & Design', 'Architecture'];
    return _buildSection(
      'Domain',
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: domains.map((d) {
          final isSelected = _selectedDomains.contains(d);
          return FilterChip(
            label: Text(d),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) _selectedDomains.add(d);
                else _selectedDomains.remove(d);
              });
            },
            selectedColor: AppTheme.primaryColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? AppTheme.primaryColor : const Color(0xFFE2E8F0)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildSection(
      'Minimum Rating',
      Column(
        children: [4.0, 3.0, 2.0].map((r) => RadioListTile<double>(
          value: r,
          groupValue: _minRating,
          onChanged: (value) => setState(() => _minRating = value!),
          title: Row(
            children: [
              ...List.generate(5, (index) => Icon(
                index < r.toInt() ? Icons.star : Icons.star_border,
                color: index < r.toInt() ? const Color(0xFFFBBF24) : const Color(0xFFE2E8F0),
                size: 20,
              )),
              const SizedBox(width: 12),
              Text('${r.toInt()} Stars & up', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            ],
          ),
          activeColor: AppTheme.primaryColor,
          contentPadding: EdgeInsets.zero,
        )).toList(),
      ),
    );
  }

  Widget _buildUniversitySection() {
    return _buildSection(
      'University Compatibility',
      Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search institution...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1))),
            ),
          ),
          const SizedBox(height: 16),
          _buildUniversityItem('Stanford University', 'Tier 1 Compliance', 'SU', true),
          const SizedBox(height: 8),
          _buildUniversityItem('MIT', 'Tier 1 Compliance', 'MU', false),
        ],
      ),
    );
  }

  Widget _buildUniversityItem(String name, String sub, String initial, bool isChecked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(initial, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                Text(sub, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
              ],
            ),
          ),
          Switch(
            value: isChecked,
            onChanged: (value) {},
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Reset All', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show 142 Results', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
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
