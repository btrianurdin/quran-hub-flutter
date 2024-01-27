import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyles {
  static final appbar = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.white,
  );

  static final title = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: Colors.white,
  );

  static final regular = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.white,
  );

  static final regularNoColor = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const arabic = TextStyle(
    fontFamily: 'uthman-light',
    fontWeight: FontWeight.w400,
    fontSize: 24,
    color: Colors.white
  );
}
