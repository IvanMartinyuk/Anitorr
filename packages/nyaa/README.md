# nyaa

A typed Dart client for searching and parsing `nyaa.si`.

```dart
import 'package:nyaa/nyaa.dart';

final client = NyaaClient();
final results = await client.search(
  const NyaaSearchRequest(
    query: 'Example Anime',
    filter: NyaaFilter.noRemakes,
    category: NyaaCategory.animeEnglishTranslated,
  ),
);

for (final torrent in results.items) {
  final title = TorrentTitleParser.parse(torrent.name);
  print('${title.publisher}: ${title.resolution} ${torrent.magnetUri}');
}
```

Search results expose both magnet and remote `.torrent` links. Torrent detail
pages can also be parsed with `getTorrentDetails`, including their file lists.
