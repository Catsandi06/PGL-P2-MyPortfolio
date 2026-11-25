import 'dart:typed_data';

/// Utilitaria para validar la firma de archivos de imagen raster.
/// La extensión y el MIME del selector no son suficientes: comprobamos la
/// firma del contenido para permitir solo formatos raster conocidos.
class ImageValidator {
  ImageValidator._();

  /// Límite máximo de tamaño para imágenes (10 MB).
  static const int maxImageBytes = 10 * 1024 * 1024;

  /// Verifica si los bytes corresponden a una imagen JPEG, PNG o WebP válida.
  static bool isSupportedRasterImage(Uint8List bytes) {
    final isJpeg =
        bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
    final isPng =
        bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    final isWebp =
        bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP';
    return isJpeg || isPng || isWebp;
  }

  /// Valida el tamaño de la imagen y devuelve un mensaje de error si excede el límite.
  static String? validateSize(int byteCount) {
    if (byteCount > maxImageBytes) {
      return 'La imagen no puede superar los 10 MB.';
    }
    return null;
  }

  /// Valida el formato de la imagen y devuelve un mensaje de error si no es soportado.
  static String? validateFormat(Uint8List bytes) {
    if (!isSupportedRasterImage(bytes)) {
      return 'Solo se aceptan imágenes JPEG, PNG o WebP.';
    }
    return null;
  }
}
