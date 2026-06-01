import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapters.dart';
import '../providers/verse_tracker_provider.dart';
import 'verse_screen.dart';

class HistoryScreen extends StatelessWidget {
  final Map<int, Chapter> chapterMap;

  const HistoryScreen({super.key, required this.chapterMap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final rawVerseIds = Provider.of<VerseTrackerProvider>(context).viewHistory
        .expand((entry) => entry.verseIds)
        .map((id) => int.tryParse(id))
        .whereType<int>()
        .toList();

    if (rawVerseIds.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No history yet.",
            style: TextStyle(color: colorScheme.onSurface.withAlpha(153)),
          ),
        ),
      );
    }

    final List<List<int>> grouped = [];
    for (final id in rawVerseIds) {
      if (grouped.isEmpty || id != grouped.last.last + 1) {
        grouped.add([id]);
      } else {
        grouped.last.add(id);
      }
    }

    final reversedGrouped = grouped.reversed.toList();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: reversedGrouped.length + 1,
            separatorBuilder: (_, __) =>
                Divider(color: colorScheme.onSurface.withAlpha(51)),
            itemBuilder: (context, index) {
              if (index == reversedGrouped.length) {
                return const SizedBox(height: 80);
              }

              final group = reversedGrouped[index];
              final start = group.first;
              final end = group.last;
              final title = start == end
                  ? 'Verse: $start'
                  : 'Verses: $start to $end';

              return ListTile(
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerseScreen(
                        chapterMap: chapterMap,
                        initialVerseId: end,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
