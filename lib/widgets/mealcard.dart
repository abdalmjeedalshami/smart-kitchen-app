import 'package:flutter/material.dart';

class ProMealCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int calories;
  final List<String> safeFor;
  final VoidCallback onAdd;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProMealCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.safeFor,
    required this.onAdd,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),

                const SizedBox(height: 12),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Chip(
                      label: Text('$calories kcal'),
                      backgroundColor: Colors.orange.shade100,
                    ),
                    ...safeFor.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.green.shade100,
                    )),
                  ],
                ),

                const SizedBox(height: 12),
                // Add Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Plan'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
