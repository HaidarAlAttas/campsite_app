import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/campsite_model.dart';

class CampsiteCard extends StatelessWidget {
  final CampsiteModel campsite;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const CampsiteCard({
    super.key,
    required this.campsite,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: campsite.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: campsite.imageUrls.first,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 200,
                            color: AppTheme.warmBeige,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 200,
                            color: AppTheme.warmBeige,
                            child: const Icon(Icons.image_not_supported, size: 48, color: AppTheme.greyText),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: AppTheme.warmBeige,
                          child: const Icon(Icons.landscape, size: 64, color: AppTheme.lightGreen),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : AppTheme.greyText,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          campsite.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppTheme.darkText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Color(0xFFFFB300)),
                          const SizedBox(width: 3),
                          Text(
                            campsite.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.greyText),
                      const SizedBox(width: 2),
                      Text(
                        '${campsite.location}, ${campsite.state}',
                        style: const TextStyle(color: AppTheme.greyText, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'RM ${campsite.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.forestGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' / night',
                          style: TextStyle(color: AppTheme.greyText, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
