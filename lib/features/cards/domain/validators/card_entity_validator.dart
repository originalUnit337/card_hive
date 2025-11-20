import 'dart:io';
import 'dart:ui';

class CardEntityValidator {
  static const _allowedImageExts = ['.png', '.jpg', '.jpeg', '.webp'];
  static const _maxFileBytes = 5 * 1024 * 1024; // 5 MB
  static const _maxNoteLength = 1000;
  static const _minNumberLength = 4;

  // В параметре requireIdForUpdate: если true — id должен быть > 0 (для update).
  static Map<String, String> validate({
    required int id,
    required String name,
    required String number,
    required Color color,
    String? label,
    String? logoPath,
    String? rawBarcodeSvg,
    String? backPath,
    String? frontPath,
    String? note,
    bool requireIdForUpdate = false,
    int maxFileBytes = _maxFileBytes,
  }) {
    final errors = <String, String>{};

    if (requireIdForUpdate && id <= 0) {
      errors['id'] = 'Invalid id for update';
    } else if (!requireIdForUpdate && id < 0) {
      errors['id'] = 'Id must be non-negative';
    }

    if (name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (number.trim().isEmpty) {
      errors['number'] = 'Number is required';
    } else if (number.trim().length < _minNumberLength) {
      errors['number'] = 'Number is too short';
    }

    // color is non-nullable in entity; still sanity check
    if (color.toARGB32() == 0) {
      // 0x00000000 is transparent black — accept or reject per app; here warn only if suspicious
      // errors['color'] = 'Invalid color value';
    }

    if (note != null && note.length > _maxNoteLength) {
      errors['note'] = 'Note is too long';
    }

    // files validation
    void validatePath(String? path, String key) {
      if (path == null) return;
      final trimmed = path.trim();
      if (trimmed.isEmpty) return;
      final f = File(trimmed);
      if (!f.existsSync()) {
        errors[key] = 'File does not exist';
        return;
      }
      final ext = _ext(trimmed);
      if (!_allowedImageExts.contains(ext)) {
        errors[key] = 'Unsupported extension: $ext';
        return;
      }
      final size = f.lengthSync();
      if (size > maxFileBytes) {
        errors[key] = 'File is too large';
      }
    }

    validatePath(logoPath, 'logoPath');
    validatePath(frontPath, 'frontPath');
    validatePath(backPath, 'backPath');

    if (rawBarcodeSvg != null) {
      final s = rawBarcodeSvg.trim();
      if (s.isNotEmpty && !s.toLowerCase().contains('<svg')) {
        errors['rawBarcodeSvg'] = 'Invalid SVG content';
      }
    }

    return errors;
  }

  static String _ext(String path) {
    final idx = path.lastIndexOf('.');
    if (idx == -1) return '';
    return path.substring(idx).toLowerCase();
  }
}
