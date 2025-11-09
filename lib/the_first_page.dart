import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart'; // ← تأكد أن اسم الملف صحيح

class TheFirstPage extends StatefulWidget {
  const TheFirstPage({super.key});

  @override
  State<TheFirstPage> createState() => _TheFirstPageState();
}

class _TheFirstPageState extends State<TheFirstPage> {
  String fullText = "alpha_one";
  String displayedText = "";
  int index = 0;

  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();

    // بدء تأثير الكتابة
    typeWriterEffect();

    // تأثير الدخول التدريجي
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    // الانتقال بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  void typeWriterEffect() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (index < fullText.length) {
        setState(() {
          displayedText += fullText[index];
          index++;
        });
        typeWriterEffect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: _opacity,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(seconds: 1),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB3E5FC),
                  Color(0xFFFFFFFF),
                  Color(0xFFE1BEE7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                displayedText,
                style: GoogleFonts.dancingScript(
                  textStyle: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
