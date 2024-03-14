import 'package:flutter/material.dart';
import 'package:my_app_car/screens/Car_list.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String username = TokenStorage.getUsername();
  String email = TokenStorage.getEmail();

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text(username),
              ],
            ),
            SizedBox(height: 5),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text(email),
              ],
            ),
            SizedBox(height: 5),
            SizedBox(height: 20),
            Text('Old Password'),
            SizedBox(height: 10),
            TextFormField(
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureOldPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleOldPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('New Password'),
            SizedBox(height: 10),
            TextFormField(
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleNewPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Confirm New Password'),
            SizedBox(height: 10),
            TextFormField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement password change logic here
                },
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
