import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const ResultScreen({Key? key, required this.studentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLulus =
        studentData['status_kelulusan'].toString().toLowerCase() == 'lulus';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text(
          'KETERANGAN KELULUSAN',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // TOP Header Decoration
                Container(
                  height: 20,
                  width: double.infinity,
                  color: const Color(0xFF0D47A1),
                ),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      // Animation Section
                      SizedBox(
                        height: 150,
                        child: isLulus
                            ? Lottie.asset(
                                'assets/lottie/success.json',
                                repeat: true,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.check_circle_outline,
                                    size: 100,
                                    color: Colors.green,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.description_outlined,
                                size: 100,
                                color: Colors.grey,
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Main Certificate Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'INFORMASI DATA SISWA',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),

                            _buildInfoRow(
                              'NAMA LENGKAP',
                              studentData['nama_lengkap']
                                  .toString()
                                  .toUpperCase(),
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              'NOMOR INDUK SISWA',
                              studentData['nis'].toString(),
                            ),
                            const Divider(height: 30),
                            _buildInfoRow(
                              'KOMPETENSI KEAHLIAN',
                              studentData['jurusan'].toString().toUpperCase(),
                            ),

                            const SizedBox(height: 40),

                            // Final Status Banner
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: isLulus
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isLulus
                                      ? Colors.green[200]!
                                      : Colors.red[200]!,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'DINYATAKAN',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isLulus
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    studentData['status_kelulusan']
                                        .toString()
                                        .toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: isLulus
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer Text
                      Text(
                        'Catatan: Ini adalah hasil pengumuman sementara. Silakan hubungi pihak sekolah untuk pengambilan Surat Keterangan Lulus (SKL) resmi.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Confetti / Sprinkles Overlay
          if (isLulus)
            IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }
}
