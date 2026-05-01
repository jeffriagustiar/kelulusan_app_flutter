import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'countdown_screen.dart';
import 'result_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nisController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String nis = _nisController.text.trim();

    if (nis.isEmpty) {
      setState(() {
        _errorMessage = 'Silakan masukkan NIS Anda';
        _isLoading = false;
      });
      return;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/data/students.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      
      final String announcementTimeStr = jsonData['pengumuman_time'];
      final bool useCountdown = jsonData['use_countdown'] ?? true;
      final List<dynamic> studentsData = jsonData['students'];

      final student = studentsData.firstWhere(
        (element) => element['nis'] == nis,
        orElse: () => null,
      );

      if (student == null) {
        setState(() {
          _errorMessage = 'NIS tidak ditemukan di database';
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        
        if (useCountdown) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CountdownScreen(
                studentData: Map<String, dynamic>.from(student),
                announcementTime: DateTime.tryParse(announcementTimeStr) ?? DateTime.now().add(const Duration(days: 1)),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                studentData: Map<String, dynamic>.from(student),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan sistem';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40, left: 30, right: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1), // Deep Academic Blue
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'PORTAL PENGUMUMAN',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'SMK NEGERI 1 TELUK KUANTAN',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            
            // Login Form
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Silakan masukkan Nomor Induk Siswa (NIS) Anda untuk melihat status kelulusan.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Textfield
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nisController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: 'NOMOR INDUK SISWA (NIS)',
                        labelStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600], letterSpacing: 1),
                        hintText: 'Contoh: 12345',
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0D47A1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        errorText: _errorMessage,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                            )
                          : Text(
                              'LOGIN',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Tahun Ajaran 2025/2026',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '© SMK Negeri 1 Teluk Kuantan',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey[400],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
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
}
