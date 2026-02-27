import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class _EventData {
  final String title;
  final String date;
  final String location;
  final String tag;
  final String prize;
  final String image;
  final bool isFree;

  const _EventData({
    required this.title,
    required this.date,
    required this.location,
    required this.tag,
    required this.prize,
    required this.image,
    this.isFree = false,
  });
}

class EventsCompetitionsScreen extends StatelessWidget {
  const EventsCompetitionsScreen({super.key});

  static const List<_EventData> _events = [
    _EventData(title: 'National Hackathon 2026', date: '15 Mar 2026', location: 'Online', tag: 'HACKATHON', prize: '₹2,00,000', image: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&q=80&w=800', isFree: true),
    _EventData(title: 'AI/ML Workshop Series', date: '22 Mar 2026', location: 'Hyderabad', tag: 'WORKSHOP', prize: 'Certificate', image: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?auto=format&fit=crop&q=80&w=800', isFree: false),
    _EventData(title: 'Flutter Bootcamp 2026', date: '01 Apr 2026', location: 'Bangalore', tag: 'BOOTCAMP', prize: '₹50,000', image: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&q=80&w=800', isFree: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Events & Competitions', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildCategoryScroll(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Featured Events'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEventCard(_events[index]),
                childCount: _events.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search hackathons, workshops...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }

  Widget _buildCategoryScroll() {
    final categories = ['All', 'Hackathons', 'Workshops', 'Conferences', 'Bootcamps'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) => _buildCategoryChip(cat, cat == 'All')).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isSelected ? null : Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        Text('Filter', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildEventCard(_EventData event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(event.image), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(event.tag, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    ),
                    Text(event.isFree ? 'Free Entry' : 'Paid', style: GoogleFonts.inter(color: event.isFree ? Colors.green : Colors.orange, fontSize: 12, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(event.title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Text(event.date, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Text(event.location, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reward', style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                          Text(event.prize, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text('Join Now', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13)),
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
}
