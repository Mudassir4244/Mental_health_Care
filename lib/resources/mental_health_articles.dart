// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

// class MentalHealthArticles extends StatefulWidget {
//   const MentalHealthArticles({super.key});

//   @override
//   State<MentalHealthArticles> createState() => _MentalHealthArticlesState();
// }

// class _MentalHealthArticlesState extends State<MentalHealthArticles> {
//   bool isLoading = true;
//   bool hasError = false;
//   List articles = [];
//   List<bool> expanded = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchArticles();
//   }

//   // -------------------------------
//   // FETCH ARTICLES (API READY)
//   // -------------------------------
//   Future<void> fetchArticles() async {
//     try {
//       setState(() {
//         isLoading = true;
//         hasError = false;
//       });

//       // TODO: Paste your API URL & API key here
//       final url = Uri.parse(
//         "https://newsapi.org/v2/everything?q=mental%20health&apiKey=80d564e58bae48519702964aef162fba",
//       );

//       final res = await http.get(url);

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);

//         setState(() {
//           articles = data["articles"];
//           expanded = List.filled(articles.length, false);
//           isLoading = false;
//         });
//       } else {
//         throw Exception("API Error");
//       }
//     } catch (e) {
//       setState(() {
//         hasError = true;
//         isLoading = false;
//       });
//     }
//   }

//   // -------------------------------
//   // UI
//   // -------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primary, AppColors.accent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 0,
//         title: const Text(
//           "Mental Health Articles",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),

//       body: isLoading
//           ? _buildLoading()
//           : hasError
//           ? _buildError()
//           : _buildArticleList(),
//     );
//   }

//   // -------------------------------
//   // LOADING UI
//   // -------------------------------
//   Widget _buildLoading() {
//     return const Center(
//       child: CircularProgressIndicator(color: Colors.deepPurple),
//     );
//   }

//   // -------------------------------
//   // ERROR UI
//   // -------------------------------
//   Widget _buildError() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Failed to load articles",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(onPressed: fetchArticles, child: const Text("Retry")),
//         ],
//       ),
//     );
//   }

//   // -------------------------------
//   // MAIN LIST UI
//   // -------------------------------
//   Widget _buildArticleList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: articles.length,
//       itemBuilder: (context, index) {
//         final item = articles[index];

//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.deepPurple.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(14),
//                 ),
//                 child: item["urlToImage"] != null
//                     ? Image.network(
//                         item["urlToImage"],
//                         height: 180,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                     : Container(
//                         height: 180,
//                         width: double.infinity,
//                         color: Colors.deepPurple.shade100,
//                         child: const Icon(Icons.broken_image, size: 60),
//                       ),
//               ),

//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(14),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item["title"] ?? "No Title",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 6),

//                     Text(
//                       item["description"] ?? "No description available",
//                       maxLines: expanded[index] ? 20 : 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() => expanded[index] = !expanded[index]);
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             expanded[index] ? "Show Less" : "Read More",
//                             style: const TextStyle(
//                               color: AppColors.accent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Icon(
//                             expanded[index]
//                                 ? Icons.expand_less
//                                 : Icons.expand_more,
//                             color: AppColors.accent,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class MentalHealthArticles extends StatefulWidget {
  const MentalHealthArticles({super.key});

  @override
  State<MentalHealthArticles> createState() => _MentalHealthArticlesState();
}

class _MentalHealthArticlesState extends State<MentalHealthArticles> {
  bool isLoading = true;
  bool hasError = false;
  List articles = [];
  List<bool> expanded = [];

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
          articles = data["articles"];
          expanded = List.filled(articles.length, false);
          isLoading = false;
        });
      } else {
        throw Exception("API Error");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
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
          icon: Icon(
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
        title: const Text(
          "Mental Health Articles",
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final item = articles[index];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: item["urlToImage"] != null
                    ? Image.network(
                        item["urlToImage"],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.deepPurple.shade100,
                        child: const Icon(Icons.broken_image, size: 60),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selectable title
                    SelectableText(
                      item["title"] ?? "No Title",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Selectable description
                    SelectableText(
                      item["description"] ?? "No description available",
                      maxLines: expanded[index] ? 20 : 2,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        setState(() => expanded[index] = !expanded[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            expanded[index] ? "Show Less" : "Read More",
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            expanded[index]
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
