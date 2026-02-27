import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SubmitFeedbackScreen extends StatefulWidget {
  final String expertName;
  final String projectName;
  final String expertAvatar;

  const SubmitFeedbackScreen({
    super.key,
    this.expertName = 'Dr. Julian Vance',
    this.projectName = 'Project: Quantum Physics Module 3',
    this.expertAvatar = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4fTMnfEtrz0lX_Uq-XmptgGD0frY1VmDsebdQX3Ue2q4TRMu4oCbzIglteiR5O6ApJE9wOBprlL4N2NAeEIfiR0u6b3BSdBfJiBXGWzF3AzszCPsiMqowPqyfYkLqcCnUTWE6C_PGLdRwVGX7BJPsOG7ZlL6WKkK_OWx7bIvA_qb02uuSfVA379s-1Q3rBjJqnwvWRfyNWsxHJMzna_EF17IXnscNMuK4Q4c_ySb927tj5CK8CeJR2iF4EMARDIQ7DmvzS95SNWA',
  });

  @override
  State<SubmitFeedbackScreen> createState() => _SubmitFeedbackScreenState();
}

class _SubmitFeedbackScreenState extends State<SubmitFeedbackScreen> {
  int _rating = 4;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Rate your Experience',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppTheme.primaryColor.withOpacity(0.1), height: 1),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExpertProfileCard(),
                _buildRatingSection(),
                _buildCommentSection(),
                _buildUploadSection(),
                const SizedBox(height: 120), // Spacer for sticky footer
              ],
            ),
          ),
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildExpertProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                image: DecorationImage(
                  image: NetworkImage(widget.expertAvatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.expertName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.projectName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF556591),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              children: [
                TextSpan(text: "How would you rate Julian's work? "),
                TextSpan(text: "*", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: index < _rating ? AppTheme.primaryColor : const Color(0xFFD2D7E5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            _getRatingText(),
            style: const TextStyle(
              color: Color(0xFF556591),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1: return 'Poor (1.0/5.0)';
      case 2: return 'Fair (2.0/5.0)';
      case 3: return 'Good (3.0/5.0)';
      case 4: return 'Excellent (4.0/5.0)';
      case 5: return 'Outstanding (5.0/5.0)';
      default: return '';
    }
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              children: [
                TextSpan(text: "Leave a comment "),
                TextSpan(text: "(Optional)", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Color(0xFF556591))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'How was your experience working with Julian? Did the project meet your expectations?',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '0 / 500 characters',
              style: TextStyle(fontSize: 11, color: Color(0xFF556591), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              children: [
                TextSpan(text: "Showcase the result "),
                TextSpan(text: "(Optional)", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Color(0xFF556591))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2), style: BorderStyle.none),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_a_photo_outlined, color: AppTheme.primaryColor, size: 28),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upload completed work',
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PNG, JPG up to 10MB.\nShow others what was achieved!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF556591), fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: AppTheme.primaryColor.withOpacity(0.1))),
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Feedback submitted successfully!'),
                backgroundColor: Color(0xFF16A34A),
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            minimumSize: const Size(double.infinity, 50),
            elevation: 8,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
          ),
          child: const Text(
            'Submit Feedback',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
