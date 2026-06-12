import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/campsite/campsite_bloc.dart';
import '../../bloc/campsite/campsite_event.dart';
import '../../bloc/campsite/campsite_state.dart';
import '../../core/theme.dart';
import '../widgets/campsite_card.dart';
import '../widgets/bottom_nav.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CampsiteBloc>().add(LoadFavoriteCampsites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Campsites')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: BlocBuilder<CampsiteBloc, CampsiteState>(
        builder: (context, state) {
          if (state is CampsiteLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.forestGreen));
          }
          if (state is CampsitesLoaded && state.campsites.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.favorite_border, size: 64, color: AppTheme.greyText),
                const SizedBox(height: 16),
                const Text('No saved campsites yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                const SizedBox(height: 8),
                const Text('Tap ♥ on any campsite to save it',
                    style: TextStyle(color: AppTheme.greyText)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Explore Campsites'),
                ),
              ]),
            );
          }
          if (state is CampsitesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.campsites.length,
              itemBuilder: (_, i) {
                final c = state.campsites[i];
                return CampsiteCard(
                  campsite: c,
                  isFavorite: true,
                  onTap: () => context.push('/campsite/${c.id}'),
                  onFavoriteTap: () => context.read<CampsiteBloc>().add(ToggleFavorite(c.id)),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
