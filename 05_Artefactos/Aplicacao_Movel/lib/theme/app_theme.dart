import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  static const laranja = Color(0xFFFF5A1F);
  static const laranjaPressionado = Color(0xFFE5521D);

  static const fundo = Color(0xFFF8FAFC);
  static const branco = Color(0xFFFFFFFF);
  static const asfalto = Color(0xFF111827);
  static const cinza = Color(0xFF64748B);
  static const linha = Color(0xFFE2E8F0);
  static const erro = Color(0xFFDC2626);
  
  static const margem = 20.0;
  static const espacamento = 12.0;
  static const paddingInterior = 16.0;

  static ThemeData get light {
    final cores = ColorScheme.fromSeed(
      seedColor: laranja,
      brightness: Brightness.light,
    ).copyWith(
      primary: laranja,
      onPrimary: branco,
      surface: branco,
      onSurface: asfalto,
      onSurfaceVariant: cinza,
      outline: cinza,
      outlineVariant: linha,
      error: erro,
      onError: branco,
    );

    final TextTheme textos = TextTheme(
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: asfalto,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: asfalto,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: asfalto,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: asfalto,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: asfalto,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: cinza,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600
      )
    );

    final contorno = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: linha),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cores,
      scaffoldBackgroundColor: fundo,
      textTheme: textos,

      appBarTheme: AppBarTheme(
        backgroundColor: fundo,
        foregroundColor: asfalto,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 56,
        titleTextStyle: textos.titleLarge,
      ),

      iconTheme: const IconThemeData(
        color: asfalto,
        size: 22,
      ),

      cardTheme: CardThemeData(
        color: branco,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: linha),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, 56),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (estados){
              if(estados.contains(WidgetState.disabled)){
                return linha;
              }

              if(estados.contains(WidgetState.pressed) || estados.contains(WidgetState.hovered)){
                return laranjaPressionado;
              }

              return laranja;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (estados) {
              return estados.contains(WidgetState.disabled)
                  ? cinza
                  : branco;
            },
          ),
          textStyle: WidgetStatePropertyAll(textos.labelLarge),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: asfalto,
          minimumSize: const Size(0, 56),
          side: const BorderSide(color: linha),
          textStyle: textos.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: branco,
        contentPadding: const EdgeInsets.all(paddingInterior),
        labelStyle: const TextStyle(color: cinza),
        hintStyle: const TextStyle(color: cinza),
        prefixIconColor: cinza,
        border: contorno,
        enabledBorder: contorno,
        focusedBorder: contorno.copyWith(
          borderSide: const BorderSide(
            color: laranja,
            width: 2,
          ),
        ),
        errorBorder: contorno.copyWith(
          borderSide: const BorderSide(color: erro),
        ),
        focusedErrorBorder: contorno.copyWith(
          borderSide: const BorderSide(
            color: erro,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(color: erro),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: branco,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (estados){
            return IconThemeData(
              size: 22,
              color: estados.contains(WidgetState.selected)
                  ? laranja
                  : cinza,
            );
          },
        ),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (estados){
            return GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: estados.contains(WidgetState.selected)
                  ? laranja
                  : cinza,
            );
          },
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: branco,
        selectedColor: asfalto,
        checkmarkColor: branco,
        labelStyle: WidgetStateTextStyle.resolveWith(
          (estados) => GoogleFonts.poppins(
            color: estados.contains(WidgetState.selected)
                ? branco
                : asfalto,
          ),
        ),
        side: const BorderSide(color: linha),
      ),

      dividerTheme: const DividerThemeData(
        color: linha,
        thickness: 1,
        space: 24,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: asfalto,
        textColor: asfalto,
        contentPadding: EdgeInsets.all(paddingInterior),
      ),
    );
  }
}