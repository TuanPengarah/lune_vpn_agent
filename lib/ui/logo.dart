import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Image.asset(
          'assets/images/splash.png',
          scale: 3,
        ),
        Text.rich(
          TextSpan(
              text: 'Lune ',
              style: GoogleFonts.bebasNeue(
                fontSize: 29,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.blue[400] : Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'VPN',
                  style: GoogleFonts.bebasNeue(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
