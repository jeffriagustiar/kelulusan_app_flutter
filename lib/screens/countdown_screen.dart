import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_screen.dart';

class CountdownScreen extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final DateTime announcementTime;

  const CountdownScreen({
    Key? key,
    required this.studentData,
    required this.announcementTime,
  }) : super(key: key);

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();

    if (_timeRemaining.inSeconds <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToResult());
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        _calculateTimeRemaining();
        if (_timeRemaining.inSeconds <= 0) {
          _timer?.cancel();
          _navigateToResult();
        }
      });
    }
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    setState(() {
      if (widget.announcementTime.isAfter(now)) {
        _timeRemaining = widget.announcementTime.difference(now);
      } else {
        _timeRemaining = Duration.zero;
      }
    });
  }

  void _navigateToResult() {
    if (_isTransitioning) return;
    _isTransitioning = true;

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(studentData: widget.studentData),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Academic Blue
      body: SafeArea(
        child: Column(
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                  const SizedBox(height: 15),
                  Text(
                    'VERIFIKASI AKSES BERHASIL',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.studentData['nama_lengkap'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double cardWidth = constraints.maxWidth * 0.2;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 40,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'PENGUMUMAN SEGERA DIBUKA',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A237E),
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Silakan tunggu hingga hitung mundur selesai.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 50),

                            // CLEAN TIMER
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTimeBox(
                                    _timeRemaining.inDays.toString().padLeft(
                                      2,
                                      '0',
                                    ),
                                    'HARI',
                                    cardWidth,
                                  ),
                                  _buildSeparator(),
                                  _buildTimeBox(
                                    (_timeRemaining.inHours % 24)
                                        .toString()
                                        .padLeft(2, '0'),
                                    'JAM',
                                    cardWidth,
                                  ),
                                  _buildSeparator(),
                                  _buildTimeBox(
                                    (_timeRemaining.inMinutes % 60)
                                        .toString()
                                        .padLeft(2, '0'),
                                    'MENIT',
                                    cardWidth,
                                  ),
                                  _buildSeparator(),
                                  _buildTimeBox(
                                    (_timeRemaining.inSeconds % 60)
                                        .toString()
                                        .padLeft(2, '0'),
                                    'DETIK',
                                    cardWidth,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 60),
                            if (_timeRemaining.inSeconds <= 0 &&
                                _isTransitioning) ...[
                              const CircularProgressIndicator(
                                color: Color(0xFF0D47A1),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'SEDANG MEMUAT DATA KELULUSAN...',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D47A1),
                                  letterSpacing: 1,
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Color(0xFF1976D2),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        'Data kelulusan akan ditampilkan secara otomatis setelah waktu pengumuman tiba.',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF1976D2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value, String label, double width) {
    return Column(
      children: [
        Container(
          width: width,
          height: width * 1.1,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D47A1),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.grey[600],
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
