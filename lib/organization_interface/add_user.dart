import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_healthcare/widgets/appcolors.dart';

class CreateCredentialsScreen extends StatefulWidget {
  const CreateCredentialsScreen({super.key});

  @override
  State<CreateCredentialsScreen> createState() =>
      _CreateCredentialsScreenState();
}

class _CreateCredentialsScreenState extends State<CreateCredentialsScreen> {
  bool _showForm = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // List to store multiple credentials
  List<Map<String, dynamic>> savedCredentials = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3A7BD5), // Royal Blue
              Color(0xFF00D2FF), // Sky Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInBack,
            child: _showForm
                ? _buildCredentialsForm(context)
                : _buildInitialButton(context),
          ),
        ),
      ),
    );
  }

  // Step 1: Initial Button & Saved Credentials
  Widget _buildInitialButton(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('createButton'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (savedCredentials.isNotEmpty)
            ...savedCredentials
                .asMap()
                .entries
                .map((entry) => _buildSavedCredentialsCard(entry.key))
                .toList(),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showForm = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 6,
            ),
            child: const Text(
              "Create Credentials",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Form for New Credentials
  Widget _buildCredentialsForm(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('formContainer'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set Your Credentials",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Email
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                final emailRegex = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ); // Basic validation
                if (!emailRegex.hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                if (value.length < 8) {
                  return "Must be at least 8 characters";
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return "Add at least one uppercase letter";
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return "Add at least one number";
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      savedCredentials.add({
                        "email": emailController.text.trim(),
                        "password": passwordController.text.trim(),
                        "visible": false, // password visibility state
                      });
                      emailController.clear();
                      passwordController.clear();
                      _showForm = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Credentials Saved Successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: const Text(
                  "Save Credentials",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Back Button
            TextButton(
              onPressed: () {
                setState(() {
                  _showForm = false;
                });
              },
              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Saved Credentials Card
  Widget _buildSavedCredentialsCard(int index) {
    final credential = savedCredentials[index];
    final isVisible = credential["visible"] as bool;

    return GestureDetector(
      onLongPress: () {
        _showOptionsDialog(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Saved Credentials",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blueAccent),
                  onPressed: () {
                    final text =
                        "Email: ${credential["email"]}\nPassword: ${credential["password"]}";
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Copied to clipboard!"),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    credential["email"],
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.lock, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isVisible
                            ? credential["password"]
                            : "•" * credential["password"].length,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            credential["visible"] = !isVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: Long press options
  void _showOptionsDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Manage Credential"),
        content: const Text("Choose an action:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editCredential(index);
            },
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                savedCredentials.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editCredential(int index) {
    final cred = savedCredentials[index];
    emailController.text = cred["email"];
    passwordController.text = cred["password"];
    setState(() {
      _showForm = true;
      savedCredentials.removeAt(index);
    });
  }
}
