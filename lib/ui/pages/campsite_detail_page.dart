import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/campsite/campsite_bloc.dart';
import '../../bloc/campsite/campsite_event.dart';
import '../../bloc/campsite/campsite_state.dart';
import '../../core/theme.dart';

class CampsiteDetailPage extends StatefulWidget {
  final String id;
  const CampsiteDetailPage({super.key, required this.id});
  @override
  State<CampsiteDetailPage> createState() => _CampsiteDetailPageState();
}

class _CampsiteDetailPageState extends State<CampsiteDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CampsiteBloc>().add(LoadCampsiteDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampsiteBloc, CampsiteState>(
      builder: (context, state) {
        if (state is CampsiteLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.forestGreen)));
        }
        if (state is CampsiteError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is! CampsiteDetailLoaded) return const Scaffold();

        final c = state.campsite;
        final isFav = state.favorites.contains(c.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: AppTheme.darkText),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => context.read<CampsiteBloc>().add(ToggleFavorite(c.id)),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppTheme.darkText,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: c.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: c.imageUrls.first,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(color: AppTheme.warmBeige,
                              child: const Icon(Icons.landscape, size: 80, color: AppTheme.lightGreen)),
                        )
                      : Container(color: AppTheme.warmBeige,
                          child: const Icon(Icons.landscape, size: 80, color: AppTheme.lightGreen)),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(c.name,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(children: [
                                const Icon(Icons.star, size: 16, color: Color(0xFFFFB300)),
                                const SizedBox(width: 4),
                                Text(c.rating.toStringAsFixed(1),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ]),
                              Text('${c.reviewCount} reviews',
                                  style: const TextStyle(color: AppTheme.greyText, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.greyText),
                        const SizedBox(width: 4),
                        Text('${c.location}, ${c.state}',
                            style: const TextStyle(color: AppTheme.greyText, fontSize: 14)),
                      ]),
                      const SizedBox(height: 20),

                      // Price
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.forestGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payments_outlined, color: AppTheme.forestGreen),
                            const SizedBox(width: 12),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'RM ${c.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.forestGreen),
                                ),
                                const TextSpan(
                                  text: ' / night',
                                  style: TextStyle(color: AppTheme.greyText, fontSize: 14),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text('About', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(c.description, style: const TextStyle(color: AppTheme.greyText, height: 1.6)),
                      const SizedBox(height: 20),

                      // Amenities
                      const Text('Amenities', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: c.amenities.map((a) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.warmBeige,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.earthBrown.withOpacity(0.3)),
                          ),
                          child: Text(a, style: const TextStyle(fontSize: 13, color: AppTheme.earthBrown)),
                        )).toList(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
            ),
            child: ElevatedButton(
              onPressed: () => context.push('/book/${c.id}'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: const Text('Book Now', style: TextStyle(fontSize: 16)),
            ),
          ),
        );
      },
    );
  }
}
