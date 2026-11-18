import 'dart:typed_data';

/// Utilitario para validar imágenes raster (JPEG, PNG, WebP).
class ImageValidator {
  ImageValidator._();

  /// Tamaño máximo permitido para una imagen: 10 MB.
  static const int maxImageSizeBytes = 10 * 1024 * 1024;

  /// Verifica si los bytes corresponden a una imagen raster soportada
  /// comprobando la firma del contenido (magic bytes).
  static bool isSupportedRasterImage(Uint8List bytes) {
    final isJpeg = bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
    final isPng = bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    final isWebp = bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP';
    return isJpeg || isPng || isWebp;
  }

  /// Verifica si el tamaño de la imagen está dentro del límite permitido.
  static bool isWithinSizeLimit(int byteLength) {
    return byteLength <= maxImageSizeBytes;
  }
}
