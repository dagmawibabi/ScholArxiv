import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:photo_view/photo_view.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ThemeProvider.themeOf(context).id == "dark_theme";

    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            'Search Papers',
            'assets/banners/ScholArxiv.png',
            'Use the search bar at the top to find research papers. Enter keywords or author names.',
            isDarkTheme,
            context,
          ),
          _buildSection(
            'View Details',
            'assets/banners/ScholArxiv2.png',
            'Tap on any paper to view its details, abstract, and download options.',
            isDarkTheme,
            context,
          ),
        
          _buildSection(
            'Change Theme',
            'assets/banners/ScholArxiv3.png',
            'Toggle between light and dark themes using the theme icon in the app bar.',
            isDarkTheme,
            context,
          ),
          _buildSection(
            'AI Chat',
            'assets/banners/ScholArxiv6.png',
            'Discuss papers with AI by tapping the AI chat icon.',
            isDarkTheme,
            context,
          ),
          const SizedBox(height: 20),
          Text(
            'Need more help? Contact us at support@scholrxiv.com',
            style: TextStyle(
              color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String imagePath, String description, bool isDarkTheme, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDarkTheme ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(context, imagePath),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

