import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vimeoRepositoryProvider = Provider<VimeoRepository>((ref) {
  return VimeoRepository(dio: Dio());
});

class VimeoVideo {
  const VimeoVideo({
    required this.id,
    required this.name,
    required this.playerEmbedUrl,
  });

  final String id;
  final String name;
  final String playerEmbedUrl;
}

class VimeoRepository {
  VimeoRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<VimeoVideo?> fetchLatestShowcaseVideo() async {
    final token = dotenv.env['VIMEO_ACCESS_TOKEN'] ?? '';
    final showcaseId = dotenv.env['VIMEO_SHOWCASE_ID'] ?? '';
    if (token.isEmpty || showcaseId.isEmpty) return null;

    final response = await _dio.get<Map<String, dynamic>>(
      'https://api.vimeo.com/albums/$showcaseId/videos',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        'sort': 'date',
        'direction': 'desc',
        'per_page': 1,
      },
    );

    final data = response.data?['data'] as List<dynamic>? ?? [];
    if (data.isEmpty) return null;

    final latest = data.first as Map<String, dynamic>;
    final uri = latest['uri'] as String? ?? '';
    final id = uri.replaceAll('/videos/', '');
    final name = latest['name'] as String? ?? 'Livestream';
    return VimeoVideo(
      id: id,
      name: name,
      playerEmbedUrl: 'https://player.vimeo.com/video/$id',
    );
  }
}
