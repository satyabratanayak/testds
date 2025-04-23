import 'dart:convert';
import 'dart:developer';
import 'dart:io';

void main() {
  final file = File('tokens/tokens.json');
  final jsonContent = jsonDecode(file.readAsStringSync());

  final global = jsonContent['global'] as Map<String, dynamic>;
  final colors = global['color'] as Map<String, dynamic>;

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln('import \'package:flutter/material.dart\';');
  buffer.writeln('');
  buffer.writeln('class MinyColors {');

  void generateColorTokens(Map<String, dynamic> map, String prefix) {
    map.forEach((key, value) {
      final newPrefix = prefix.isEmpty ? key : '${prefix}_$key';
      if (value is Map && value.containsKey('value')) {
        final hex = value['value'].toString().replaceAll('#', '').toUpperCase();
        buffer.writeln('  static const Color $newPrefix = Color(0xFF$hex);');
      } else if (value is Map<String, dynamic>) {
        generateColorTokens(value, newPrefix);
      }
    });
  }

  generateColorTokens(colors, '');

  buffer.writeln('}');

  final outFile = File('lib/src/tokens/colors.dart');
  outFile.writeAsStringSync(buffer.toString());

  log('✅ Generated lib/src/tokens/colors.dart');
}
