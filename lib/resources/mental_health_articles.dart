import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';
import 'package:mental_healthcare/l10n/app_localizations.dart';

class MentalHealthArticles extends StatefulWidget {
  const MentalHealthArticles({super.key});

  @override
  State<MentalHealthArticles> createState() => _MentalHealthArticlesState();
}

class _MentalHealthArticlesState extends State<MentalHealthArticles> {
  bool isLoading = true;
  bool hasError = false;
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=mental%20health&apiKey=80d564e58bae48519702964aef162fba",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          // Filter out articles with null or empty images
          articles = (data["articles"] as List).where((item) {
            final url = item["urlToImage"];
            return url != null &&
                url.toString().isNotEmpty &&
                url.toString() != "null";
          }).toList();

          // Shuffle the articles
          articles.shuffle();

          isLoading = false;
        });
      } else {
        throw Exception("API Error");
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.mental_health_articles,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? _buildLoading()
          : hasError
          ? _buildError()
          : _buildArticleList(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Failed to load articles",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: fetchArticles, child: const Text("Retry")),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    if (articles.isEmpty) {
      return const Center(child: Text("No articles found"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final item = articles[index];
        return ArticleCard(key: ValueKey(item["url"] ?? index), article: item);
      },
    );
  }
}

class ArticleCard extends StatefulWidget {
  final Map article;

  const ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              widget.article["urlToImage"],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _isVisible) {
                    setState(() {
                      _isVisible = false;
                    });
                  }
                });
                return const SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.article["title"] ?? "No Title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  widget.article["description"] ?? "No description available",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
