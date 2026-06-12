import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/campsite/campsite_bloc.dart';
import '../../bloc/campsite/campsite_event.dart';
import '../../bloc/campsite/campsite_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/theme.dart';
import '../../data/repositories/campsite_repository.dart';
import '../widgets/campsite_card.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    context.read<CampsiteBloc>().add(LoadCampsites());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = (context.watch<AuthBloc>().state is AuthAuthenticated)
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user.name.split(' ').first
        : '';

    return Scaffold(
      backgroundColor: AppTheme.softWhite,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, $userName 👋',
                              style: const TextStyle(fontSize: 14, color: AppTheme.greyText),
                            ),
                            const Text(
                              'Find your campsite',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkText),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.forestGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: AppTheme.forestGreen),
                            onPressed: _showFilter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search bar
                    TextField(
                      controller: _searchCtrl,
                      onSubmitted: (q) {
                        if (q.isNotEmpty) {
                          context.read<CampsiteBloc>().add(SearchCampsites(q));
                        } else {
                          context.read<CampsiteBloc>().add(LoadCampsites());
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search campsites, states...',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.greyText),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  context.read<CampsiteBloc>().add(LoadCampsites());
                                  setState(() {});
                                },
                              )
                            : null,
                        hintStyle: const TextStyle(color: AppTheme.greyText),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // State filter chips
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _filterChip('All', null),
                          ...CampsiteRepository.malaysiaCampsiteStates.map(
                            (s) => _filterChip(s, s),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Available Campsites',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkText),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            BlocBuilder<CampsiteBloc, CampsiteState>(
              builder: (context, state) {
                if (state is CampsiteLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: AppTheme.forestGreen),
                      ),
                    ),
                  );
                }
                if (state is CampsiteError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppTheme.greyText),
                            const SizedBox(height: 8),
                            Text(state.message, style: const TextStyle(color: AppTheme.greyText)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (state is CampsitesLoaded) {
                  if (state.campsites.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 48, color: AppTheme.greyText),
                              SizedBox(height: 8),
                              Text('No campsites found',
                                  style: TextStyle(color: AppTheme.greyText, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final c = state.campsites[i];
                          return CampsiteCard(
                            campsite: c,
                            isFavorite: state.favorites.contains(c.id),
                            onTap: () => context.push('/campsite/${c.id}'),
                            onFavoriteTap: () =>
                                context.read<CampsiteBloc>().add(ToggleFavorite(c.id)),
                          );
                        },
                        childCount: state.campsites.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String? value) {
    final selected = _selectedState == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() => _selectedState = value);
          context.read<CampsiteBloc>().add(FilterCampsites(state: value));
        },
        selectedColor: AppTheme.forestGreen,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.darkText,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(color: selected ? AppTheme.forestGreen : const Color(0xFFDEE2E6)),
      ),
    );
  }

  void _showFilter() {
    double maxPrice = 500;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text('Max Price: RM ${maxPrice.toInt()}/night'),
              Slider(
                value: maxPrice,
                min: 50,
                max: 1000,
                divisions: 19,
                activeColor: AppTheme.forestGreen,
                onChanged: (v) => setModal(() => maxPrice = v),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CampsiteBloc>()
                      .add(FilterCampsites(state: _selectedState, maxPrice: maxPrice));
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
