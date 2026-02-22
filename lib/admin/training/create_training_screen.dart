import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_healthcare/admin/provider%20Classes/training_provider.dart';
import 'package:mental_healthcare/frontend/widgets/appcolors.dart';

class CreateTrainingScreen extends StatefulWidget {
  const CreateTrainingScreen({super.key});

  @override
  State<CreateTrainingScreen> createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {
  int _selectedSlideIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrainingProvider>(context);

    // Ensure selection is valid
    if (_selectedSlideIndex >= provider.slides.length &&
        provider.slides.isNotEmpty) {
      _selectedSlideIndex = provider.slides.length - 1;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Create Training Module",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.cloud_upload, color: Colors.white),
            label: const Text(
              "SAVE MODULE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              try {
                await provider.uploadTrainingModule();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Training Module Uploaded Successfully!"),
                  ),
                );
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: provider.isUploading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildModuleHeader(provider),
                const Divider(height: 1),
                _buildSlideNavigator(provider),
                Expanded(
                  child: provider.slides.isEmpty
                      ? const Center(child: Text("Add a slide to begin."))
                      : _buildSlideEditor(provider),
                ),
              ],
            ),
    );
  }

  // --- 1. Module Header (Title & Desc) ---
  Widget _buildModuleHeader(TrainingProvider provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Module Title",
              border: OutlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            onChanged: (val) => provider.updateModuleTitle(val),
            controller: TextEditingController(text: provider.moduleTitle)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: provider.moduleTitle.length),
              ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: 2,
            onChanged: (val) => provider.updateModuleDescription(val),
            controller: TextEditingController(text: provider.moduleDescription)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: provider.moduleDescription.length),
              ),
          ),
        ],
      ),
    );
  }

  // --- 2. Slide Navigator (Horizontal Tabs) ---
  Widget _buildSlideNavigator(TrainingProvider provider) {
    return Container(
      height: 60,
      color: Colors.grey[200],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: provider.slides.length + 1,
        itemBuilder: (context, index) {
          if (index == provider.slides.length) {
            return IconButton(
              icon: const Icon(Icons.add_circle, size: 32, color: Colors.green),
              onPressed: () {
                provider.addSlide();
                setState(
                  () => _selectedSlideIndex = provider.slides.length - 1,
                );
              },
            );
          }

          bool isSelected = index == _selectedSlideIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedSlideIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                "Slide ${index + 1}",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 3. Slide Editor (Main Area) ---
  Widget _buildSlideEditor(TrainingProvider provider) {
    if (_selectedSlideIndex >= provider.slides.length) {
      return const SizedBox.shrink();
    }

    final slide = provider.slides[_selectedSlideIndex];
    final content = slide['content'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slide Title
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Slide Header",
                    prefixIcon: Icon(Icons.title),
                    border: UnderlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (val) =>
                      provider.updateSlideTitle(_selectedSlideIndex, val),
                  controller: TextEditingController(text: slide['title'])
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: (slide['title'] as String).length),
                    ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: "Delete Slide",
                onPressed: () {
                  if (provider.slides.length > 1) {
                    provider.removeSlide(_selectedSlideIndex);
                    setState(() {
                      if (_selectedSlideIndex > 0) _selectedSlideIndex--;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cannot delete the last slide."),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content Blocks
          if (content.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Empty Slide. Add content below.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...content.asMap().entries.map((entry) {
              return _buildContentBlockPreview(
                provider,
                _selectedSlideIndex,
                entry.key,
                entry.value,
              );
            }),

          const SizedBox(height: 20),

          // Add Content Bar
          const Text(
            "Add Element:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _addBtn(
                Icons.text_fields,
                "Text",
                Colors.blue,
                () =>
                    _showAddTextDialog(context, provider, _selectedSlideIndex),
              ),
              _addBtn(
                Icons.format_list_bulleted,
                "List",
                Colors.orange,
                () =>
                    _showAddListDialog(context, provider, _selectedSlideIndex),
              ),
              _addBtn(
                Icons.compare_arrows,
                "Compare",
                Colors.purple,
                () => _showAddComparisonDialog(
                  context,
                  provider,
                  _selectedSlideIndex,
                ),
              ),
              _addBtn(
                Icons.table_chart,
                "Table",
                Colors.teal,
                () =>
                    _showAddTableDialog(context, provider, _selectedSlideIndex),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _addBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlockPreview(
    TrainingProvider provider,
    int slideIndex,
    int blockIndex,
    Map block,
  ) {
    String type = block['type'];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIconForType(type), size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  type.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                  onPressed: () =>
                      provider.removeContentBlock(slideIndex, blockIndex),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(),
            _renderBlockContent(block),
          ],
        ),
      ),
    );
  }

  Widget _renderBlockContent(Map block) {
    String type = block['type'];
    dynamic data = block['data'];

    if (type == 'text') {
      return Text(
        data.toString(),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (type == 'bullet_list') {
      List items = data as List;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.take(3).map((e) => Text("• $e")).toList(),
      );
    }
    if (type == 'comparison') {
      return Text("${data['title1']} vs ${data['title2']}");
    }
    if (type == 'table') {
      return Text("Table (${(data['rows'] as List).length} rows)");
    }
    return const SizedBox.shrink();
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'text':
        return Icons.text_fields;
      case 'bullet_list':
        return Icons.format_list_bulleted;
      case 'comparison':
        return Icons.compare_arrows;
      case 'table':
        return Icons.table_chart;
      default:
        return Icons.block;
    }
  }

  // --- Dialogs (Reused logic) ---

  void _showAddTextDialog(
    BuildContext context,
    TrainingProvider provider,
    int slideIndex,
  ) {
    String text = "";
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Text Paragraph"),
        content: TextField(
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Enter text content...",
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => text = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (text.isNotEmpty) {
                provider.addTextContent(slideIndex, text);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddListDialog(
    BuildContext context,
    TrainingProvider provider,
    int slideIndex,
  ) {
    List<String> items = [];
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Bullet List"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "New Item",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            setState(() {
                              items.add(controller.text);
                              controller.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (ctx, i) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text("• ${items[i]}"),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red,
                          ),
                          onPressed: () => setState(() => items.removeAt(i)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (items.isNotEmpty) {
                    provider.addBulletList(slideIndex, items);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Add List"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddComparisonDialog(
    BuildContext context,
    TrainingProvider provider,
    int slideIndex,
  ) {
    String title1 = "";
    String title2 = "";
    List<String> list1 = [];
    List<String> list2 = [];

    TextEditingController t1Controller = TextEditingController();
    TextEditingController t2Controller = TextEditingController();
    TextEditingController item1Controller = TextEditingController();
    TextEditingController item2Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Comparison"),
            content: SizedBox(
              width: 800, // Wider for comparison
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: t1Controller,
                                  decoration: const InputDecoration(
                                    labelText: "Title 1 (e.g. Do's)",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (v) => title1 = v,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: item1Controller,
                                        decoration: const InputDecoration(
                                          hintText: "Add Item",
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        if (item1Controller.text.isNotEmpty) {
                                          setState(() {
                                            list1.add(item1Controller.text);
                                            item1Controller.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                ...list1
                                    .map(
                                      (e) => ListTile(
                                        title: Text("• $e"),
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    )
                                    ,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Column 2
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: t2Controller,
                                  decoration: const InputDecoration(
                                    labelText: "Title 2 (e.g. Don'ts)",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (v) => title2 = v,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: item2Controller,
                                        decoration: const InputDecoration(
                                          hintText: "Add Item",
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        if (item2Controller.text.isNotEmpty) {
                                          setState(() {
                                            list2.add(item2Controller.text);
                                            item2Controller.clear();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                ...list2
                                    .map(
                                      (e) => ListTile(
                                        title: Text("• $e"),
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    )
                                    ,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (title1.isNotEmpty && title2.isNotEmpty) {
                    provider.addComparison(
                      slideIndex,
                      title1,
                      list1,
                      title2,
                      list2,
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Add Comparison"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddTableDialog(
    BuildContext context,
    TrainingProvider provider,
    int slideIndex,
  ) {
    List<String> headers = ["Term", "Explanation", "Examples"];
    List<List<String>> rows = [];

    TextEditingController c1 = TextEditingController();
    TextEditingController c2 = TextEditingController();
    TextEditingController c3 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Table"),
            content: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Headers: Term | Explanation | Examples",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: c1,
                            decoration: const InputDecoration(
                              hintText: "Term",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: c2,
                            decoration: const InputDecoration(
                              hintText: "Explanation",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: c3,
                            decoration: const InputDecoration(
                              hintText: "Examples",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            if (c1.text.isNotEmpty) {
                              setState(() {
                                rows.add([c1.text, c2.text, c3.text]);
                                c1.clear();
                                c2.clear();
                                c3.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListView.builder(
                        itemCount: rows.length,
                        itemBuilder: (ctx, i) => Container(
                          color: i % 2 == 0 ? Colors.grey[50] : Colors.white,
                          child: ListTile(
                            dense: true,
                            title: Row(
                              children: rows[i]
                                  .map(
                                    (c) => Expanded(
                                      child: Text(
                                        c,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.red,
                              ),
                              onPressed: () => setState(() => rows.removeAt(i)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (rows.isNotEmpty) {
                    provider.addTable(slideIndex, headers, rows);
                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Add Table"),
              ),
            ],
          );
        },
      ),
    );
  }
}
