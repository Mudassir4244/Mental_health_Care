import 'package:flutter/material.dart';
import 'package:mental_healthcare/admin/admin_backend/admin_auth.dart';
import 'package:mental_healthcare/frontend/customer_interface/loginscreen.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            // -----------------------------
            // DESKTOP UI
            // -----------------------------
            return DesktopLoginUI();
          } else {
            // -----------------------------
            // MOBILE UI
            // -----------------------------
            return LoginScreen();
          }
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// DESKTOP LOGIN UI
// ------------------------------------------------------------
class DesktopLoginUI extends StatefulWidget {
  const DesktopLoginUI({super.key});

  @override
  State<DesktopLoginUI> createState() => _DesktopLoginUIState();
}

class _DesktopLoginUIState extends State<DesktopLoginUI> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _obscurePassword = true; // For toggle visibility

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 450,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 2),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.admin_panel_settings, size: 70, color: Colors.blue),
              SizedBox(height: 20),

              Text(
                "Admin Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              // EMAIL FIELD
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email can't be empty";
                  }
                  if (!value.contains("@")) {
                    return "Invalid email format";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // PASSWORD FIELD + VISIBILITY TOGGLE
              TextFormField(
                controller: password,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password can't be empty";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final adminLogin = AdminLogin();
                      adminLogin.performLogin(
                        email.text.trim(),
                        password.text.trim(),
                        context,
                      );
                    }
                  },
                  child: Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// MOBILE LOGIN UI
// ------------------------------------------------------------
class _MobileLoginUI extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, size: 80, color: Colors.blue),
          SizedBox(height: 25),

          Text(
            "Admin Login",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 40),

          // Email
          TextField(
            controller: email,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),

          // Password
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 35),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text("Login", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
